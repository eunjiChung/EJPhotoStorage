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
    
    func startRequest(images: Images,
                      imagePath: String,
                      vclipPath: String,
                      query: [URLQueryItem],
                      header: HTTPHeaders,
                      success: @escaping (Images) -> (),
                      failure: @escaping (Error) -> ()) {

        let imageRequester = ImageRequester.init(images: images,
                                                 imagePath: imagePath,
                                                 vclipPath: vclipPath,
                                                 query: query,
                                                 header: header)
        
        imageRequester.completionBlock = {
            print("Request finished!!")
            // 얘를 어디다 옮길까...
            imageRequester.images.sortImagesRecency()
            
            if let error = imageRequester.error {
                failure(error)
            }
            
            DispatchQueue.main.async {
                success(imageRequester.images)
            }
        }
        
        requestQueue.addOperation(imageRequester)
    }
    
    func downloadImage(with imageUrl: String, completionHandler: @escaping (UIImage) -> ()) {
        
        let imageDownloader = ImageDownloader.init(with: imageUrl)
    
        imageDownloader.completionBlock = {
            completionHandler(imageDownloader.image!)
        }
        
        downloadQueue.addOperation(imageDownloader)
    }
}


class ImageDownloader: BlockOperation {
    
    var imageUrl = ""
    var image = UIImage.init(named: "Placeholder")
    
    init(with imageUrl: String) {
        self.imageUrl = imageUrl
    }
    
    override func main() {
        print("Download start....")
        if let resourceURL = URL(string: imageUrl) {
            
            guard let imageData = try? Data(contentsOf: resourceURL) else { return }
            
            if !imageData.isEmpty {
                self.image = UIImage(data: imageData)! // 캐시 처리
            } else {
                self.image = UIImage(named: "Failed")!
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
    
    // 기존 이미지들을 가져옴...
    var images = Images.init(with: "new")
    
    let group = DispatchGroup()
    
    // MARK: - Initializer
    init(images: Images,
         imagePath: String,
         vclipPath: String,
         query: [URLQueryItem],
         header: HTTPHeaders) {
        self.images = images
        self.imagePath = imagePath
        self.vclipPath = vclipPath
        self.query = query
        self.header = header
    }
    
    // MARK: - Operation Execution
    override func main() {
        if !images.isImageEnd {
            group.enter()
            requestImage()
        }
        
        if !images.isVclipEnd {
            group.enter()
            requestVclip()
        }

        group.wait()
    }
    
    // MARK: - Private Method
    fileprivate func requestImage() {
        print("Request Image")
        
        networkManager.GETRequest(path: imagePath,
                                  query: query,
                                  header: header,
                                  success: { (data) in
                                    self.appendImages(of: data, by: .image)
                                    self.group.leave()
        }) { (error) in
            self.error = error
            self.group.leave()
        }
    }
    
    fileprivate func requestVclip() {
        print("Request Vclip")
        
        networkManager.GETRequest(path: vclipPath,
                                  query: query,
                                  header: header,
                                  success: { (data) in
                                    self.appendImages(of: data, by: .vclip)
                                    self.group.leave()
        }) { (error) in
            self.error = error
            self.group.leave()
        }
    }
    
    fileprivate func appendImages(of data: Any, by type: requestType) {
        
        switch type {
        case .image:
            
            let model = IMImageModel.init(object: data)
            
            if let meta = model.meta, let documents = model.documents, let isEnd = meta.isEnd {
                
                if isEnd && (documents.count == 0) { return }
                
                documents.forEach {
                    let newImageRecord = ImageRecord.init(with: $0)
                    self.images.imageRecords.append(newImageRecord)
                }
                
                self.images.isImageEnd = isEnd
            }
        case .vclip:
            
            let model = VMVclipModel.init(object: data)
            
            if let meta = model.meta, let isEnd = meta.isEnd, let documents = model.documents {
                
                if isEnd && (documents.count == 0) { return }
                
                documents.forEach {
                    let newImageRecord = ImageRecord.init(with: $0)
                    self.images.imageRecords.append(newImageRecord)
                }
                
                self.images.isVclipEnd = isEnd
            }
        }
    }
}























