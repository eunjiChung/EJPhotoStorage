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
    
    func startRequest(keyword:String,
                      page: Int,
                      success: @escaping ([ImageRecord], Bool) -> ()) {

        let imageRequester = ImageRequester.init(keyword, page)
        
        imageRequester.completionBlock = {
            DispatchQueue.main.async {
                success(imageRequester.imageRecords, imageRequester.isEnd)
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
    var imageRecords: [ImageRecord] = []
    var keyword = ""
    
    var isImageEnd = false
    var isVclipEnd = false
    var isEnd = false
    var page = 0
    
    let group = DispatchGroup()
    
    // MARK: - Initializer
    init(_ keyword: String, _ page: Int) {
        self.keyword = keyword
        self.page = page
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
        EJLibrary.shared.requestPhoto(keyword: keyword,
                                      page: page,
                                      success: { (data) in
            self.appendImages(of: data, by: .image)
            self.isEndOfPage(of: data, by: .image)
            self.group.leave()
        }) { (error) in
            self.group.leave()
        }
    }
    
    fileprivate func requestVclip() {
        EJLibrary.shared.requestVclip(keyword: keyword,
                                      page: page,
                                      success: { (data) in
            self.appendImages(of: data, by: .vclip)
            self.isEndOfPage(of: data, by: .vclip)
            self.sortImagesByDateTime()
            self.group.leave()
        }) { (error) in
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
                    self.imageRecords.append(newImageRecord)
                }
            }
        case .vclip:
            let result = VMVclipModel.init(object: data)
            
            if let documents = result.documents {
                documents.forEach {
                    let newImageRecord = ImageRecord.init(with: $0)
                    self.imageRecords.append(newImageRecord)
                }
            }
        }
    }
    
    fileprivate func isEndOfPage(of data: Any, by type: requestType) {
        switch type {
        case .image:
            let model = IMImageModel.init(object: data)
            
            if let meta = model.meta, let isEnd = meta.isEnd {
                self.isImageEnd = isEnd
                print("isImageEnd:", self.isImageEnd)
            }
        case .vclip:
            let model = VMVclipModel.init(object: data)
            
            if let meta = model.meta, let isEnd = meta.isEnd {
                self.isVclipEnd = isEnd
                print("isVclipEnd:", self.isVclipEnd)
                self.isEnd = self.isImageEnd && self.isVclipEnd
                print("isEnd:", self.isEnd)
            }
        }
    }
    
    fileprivate func sortImagesByDateTime() {
        self.imageRecords = self.imageRecords.sorted { $0.dateTime() > $1.dateTime() }
    }
}























