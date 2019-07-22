//
//  ImageOperations.swift
//  TwoApiCallText
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 22/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

public class PendingOperations {
    
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "download"
        return queue
    }()
    
    lazy var requestQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "request"
        return queue
    }()
    
    func startRequest(imagePath: String,
                      vclipPath: String,
                      query: [URLQueryItem],
                      header: HTTPHeaders,
                      success: @escaping (Images) -> (),
                      failure: @escaping (Error) -> ()) {

        let imageRequester = ImageRequester.init(imagePath: imagePath,
                                                 vclipPath: vclipPath,
                                                 query: query,
                                                 header: header)
        
        imageRequester.completionBlock = {
            
            if let error = imageRequester.error {
                failure(error)
            }
            
            DispatchQueue.main.async {
                // 혼란...여기서 해도 되나?
                success(imageRequester.images)
            }
        }
        
        requestQueue.addOperation(imageRequester)
    }
    
    // 이거 진짜 옮기고 싶다...
    // 일단 넘어가
    var imageCache: [String: UIImage] = [:]
    func downloadImage(with imageUrl: String, completionHandler: @escaping (UIImage) -> ()) {
        
        let imageDownloader = ImageDownloader.init(with: imageUrl, imageCache)
        
        imageDownloader.completionBlock = {
            self.imageCache = imageDownloader.imageCache
            completionHandler(imageDownloader.imageCache[imageUrl]!)
        }
        
        downloadQueue.addOperation(imageDownloader)
    }
}


class ImageDownloader: BlockOperation {
    
    var imageUrl = ""
    var imageCache: [String: UIImage] = [:]
    
    init(with imageUrl: String, _ cache: [String:UIImage]) {
        self.imageUrl = imageUrl
        self.imageCache = cache
    }
    
    override func main() {
        print("Download start....")
        if let resourceURL = URL(string: imageUrl) {
            
            // 캐시는 어디에 두지?ㅠㅠ
            if imageCache[imageUrl] == nil {
                guard let imageData = try? Data(contentsOf: resourceURL) else { return }
                
                if !imageData.isEmpty {
                    imageCache[imageUrl] = UIImage(data: imageData) // 캐시 처리
                } else {
                    imageCache[imageUrl] = UIImage(named: "Failed")!
                }
            } else {
                print("Image Already Exists")
            }
        }
    }
}



enum requestType {
    case image, vclip
}

class ImageRequester: BlockOperation {
    
    // MARK: - Variables
    let networkManager = NetworkManager()
    var imagePath: String
    var vclipPath: String
    var query: [URLQueryItem]
    var header: HTTPHeaders
    var error: Error?
    
    var images = Images.init(with: "temp")
    
    let group = DispatchGroup()
    
    // MARK: - Initializer
    init(imagePath: String, vclipPath: String, query: [URLQueryItem], header: HTTPHeaders) {
        self.imagePath = imagePath
        self.vclipPath = vclipPath
        self.query = query
        self.header = header
    }
    
    // MARK: - Operation Execution
    override func main() {
        print("Request Image")
        
        group.enter()
        requestImage()
        
        group.enter()
        requestVclip()
        
        print("Request finished!!")
        group.wait()
        // 이 밑으로 아무것도 넣지 마세요...
    }
    
    // MARK: - Private Method
    // 둘 중 하나의 결과가 먼저 떨어진다면?
    fileprivate func requestImage() {
        networkManager.GETRequest(path: imagePath, query: query, header: header, success: { (data) in
            self.appendImages(of: data, by: .image)
            self.isEndOfPage(of: data, by: .image)
            self.group.leave()
        }) { (error) in
            self.error = error
            self.group.leave()
        }
    }
    
    fileprivate func requestVclip() {
        networkManager.GETRequest(path: vclipPath, query: query, header: header, success: { (data) in
            self.appendImages(of: data, by: .vclip)
            self.isEndOfPage(of: data, by: .vclip)
            self.group.leave()
        }) { (error) in
            self.error = error
            self.group.leave()
        }
    }
    
    fileprivate func appendImages(of data: Any, by type: requestType) {
        
        switch type {
        case .image:
            let result = IMImageModel.init(object: data)
            
            if let documents = result.documents {
                documents.forEach {
                    let newImageRecord = ImageRecord.init(with: $0)
                    self.images.imageRecords.append(newImageRecord)
                }
            }
        case .vclip:
            let result = VMVclipModel.init(object: data)
            
            if let documents = result.documents {
                documents.forEach {
                    let newImageRecord = ImageRecord.init(with: $0)
                    self.images.imageRecords.append(newImageRecord)
                }
            }
        }
    }
    
    fileprivate func isEndOfPage(of data: Any, by type: requestType) {
        switch type {
        case .image:
            let model = IMImageModel.init(object: data)
            
            if let meta = model.meta, let isEnd = meta.isEnd {
                self.images.isImageEnd = isEnd
            }
        case .vclip:
            let model = VMVclipModel.init(object: data)
            
            if let meta = model.meta, let isEnd = meta.isEnd {
                self.images.isVclipEnd = isEnd
            }
        }
    }
    
}























