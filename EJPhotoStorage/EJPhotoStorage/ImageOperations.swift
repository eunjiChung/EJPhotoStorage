//
//  ImageOperations.swift
//  TwoApiCallText
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 22/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

public class PendingOperations {
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
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
    
    func startRequest(for searchKeyword:String?, success: @escaping ([ImageRecord]) -> ()) {
        
        guard let keyword = searchKeyword else { return }
        
        let imageRequester = ImageRequester.init(keyword)
//        let imageDownloader = ImageDownloader()
        
        imageRequester.completionBlock = {
//            imageDownloader.imageRecords = imageRequester.imageRecords
            DispatchQueue.main.async {
                success(imageRequester.imageRecords)
            }
        }
        
//        imageDownloader.completionBlock = {
//            print("Image Download Completed!!")
//
//            // 만약 loadMore라면 append...해야될것 같은데
//            imageRequester.imageRecords = imageDownloader.downloadedImageRecords
//            print(imageRequester.imageRecords)
//
//            DispatchQueue.main.async {
//                success(imageRequester.imageRecords)
//            }
//        }
        
//        imageDownloader.addDependency(imageRequester)
        requestQueue.addOperation(imageRequester)
//        requestQueue.addOperation(imageDownloader)
    }
    
    func downloadImage(with imageRecord: ImageRecord, completionHandler: @escaping (UIImage?) -> ()) {
        
        let imageDownloader = ImageDownloader.init(with: imageRecord)
        
        imageDownloader.completionBlock = {
            completionHandler(imageDownloader.imageRecord.image)
        }
        
        downloadQueue.addOperation(imageDownloader)
    }
}


class ImageDownloader: BlockOperation {
    
//    var imageRecords: [ImageRecord] = []
//    var downloadedImageRecords: [ImageRecord] = []

    var imageRecord: ImageRecord
    var imageCache: [ImageRecord]?
    
    init(with imageRecord: ImageRecord) {
        self.imageRecord = imageRecord
    }
    
    override func main() {
        print("Download start....")
        
        if let url = imageRecord.imageUrl,
            let resourceURL = URL(string: url) {
            
            print("Get image url")
            
            if let imageData = try? Data(contentsOf: resourceURL),
                let newImage = UIImage(data: imageData) {
                print("Get new image!!!! YeY!")
                imageRecord.image = newImage
                imageRecord.state = .downloaded
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
    var keyword: String?
    
    var loadMoreImageRecords: [ImageRecord] = []
    var isLoadMore: Bool?
    
    let group = DispatchGroup()
    
    // MARK: - Initializer
    init(_ keyword: String) {
        self.keyword = keyword
        self.isLoadMore = false
    }
    
    // MARK: - Operation Execution
    override func main() {
        print("Request Image")

        guard let keyword = keyword else { return }
        
        group.enter()
        requestImage(by: keyword)
        
        group.enter()
        requestVclip(by: keyword)
        
        print("Request finished!!")
        group.wait()
        // 이 밑으로 아무것도 넣지 마세요...
    }
    
    // MARK: - Private Method
    fileprivate func requestImage(by keyword: String) {
        EJLibrary.shared.requestPhoto(keyword: keyword, success: { (data) in
            self.appendImages(of: data, by: .image)
            self.group.leave()
        }) { (error) in
            self.group.leave()
        }
    }
    
    fileprivate func requestVclip(by keyword: String) {
        EJLibrary.shared.requestVclip(keyword: keyword, success: { (data) in
            self.appendImages(of: data, by: .vclip)
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
    
    fileprivate func sortImagesByDateTime() {
        self.imageRecords = self.imageRecords.sorted { $0.dateTime() > $1.dateTime() }
    }
}























