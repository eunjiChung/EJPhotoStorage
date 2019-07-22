//
//  ImageOperations.swift
//  TwoApiCallText
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 22/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class PendingOperations {
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
}


class ImageDownloader: Operation {
    
    let imageRecord: ImageRecord
    
    init(_ imageRecord: ImageRecord) {
        self.imageRecord = imageRecord
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        guard let url = imageRecord.imageUrl else { return }
        let resourceURL = URL(string: url)!
        guard let imageData = try? Data(contentsOf: resourceURL) else { return }
        
        if isCancelled {
            return
        }
        
        if !imageData.isEmpty {
            imageRecord.image = UIImage(data: imageData)!
            imageRecord.state = .downloaded
        } else {
            imageRecord.image = UIImage.init(named: "Fail")
            imageRecord.state = .fail
        }
    }
}


class ImageRequester: BlockOperation {
    
    var images: [ImageRecord] = []
    var keyword: String?
    
    let group = DispatchGroup()
    
    init(_ keyword: String) {
        self.keyword = keyword
    }
    
    // MARK: - Operation Execution
    override func main() {

        guard let keyword = keyword else { return }
        
        group.enter()
        requestImage(by: keyword)
        
        group.enter()
        requestVclip(by: keyword)
        
        group.wait()
    }
    
    func appendImages(of data: Any) {
        let result = IMImageModel.init(object: data)
        
        if let documents = result.documents {
            documents.forEach {
                let newImageRecord = ImageRecord.init(with: $0)
                self.images.append(newImageRecord)
            }
        }
    }
    
    // MARK: - Private Method
    fileprivate func requestImage(by keyword: String) {
        EJLibrary.shared.requestPhoto(keyword: keyword, success: { (data) in
            self.appendImages(of: data)
            self.group.leave()
        }) { (error) in
            self.group.leave()
        }
    }
    
    fileprivate func requestVclip(by keyword: String) {
        EJLibrary.shared.requestVclip(keyword: keyword, success: { (data) in
            self.appendImages(of: data)
            self.group.leave()
        }) { (error) in
            self.group.leave()
        }
    }
}























