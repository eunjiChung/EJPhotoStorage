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
    
    func startRequest(searchOperator: SearchOperator,
                      imagePath: String,
                      vclipPath: String,
                      query: [URLQueryItem],
                      header: HTTPHeaders,
                      success: @escaping (SearchOperator) -> (),
                      failure: @escaping (Error) -> ()) {

        let imageRequester = ImageRequester.init(searchOperator: searchOperator,
                                                 imagePath: imagePath,
                                                 vclipPath: vclipPath,
                                                 query: query,
                                                 header: header)
        
        imageRequester.completionBlock = {
            print("Request finished!!")
            
            
            if let error = imageRequester.error {
                failure(error)
            }
            
            DispatchQueue.main.async {
                success(imageRequester.searchOperator)
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


class ImageRequester: BlockOperation {
    
    // MARK: - Variables
    let networkManager = NetworkManager()
    
    var imagePath: String
    var vclipPath: String
    var query: [URLQueryItem]
    var header: HTTPHeaders
    var error: Error?
    
    var searchOperator: SearchOperator
    
    let group = DispatchGroup()
    
    // MARK: - Initializer
    init(searchOperator: SearchOperator,
         imagePath: String,
         vclipPath: String,
         query: [URLQueryItem],
         header: HTTPHeaders) {
        self.searchOperator = searchOperator
        self.imagePath = imagePath
        self.vclipPath = vclipPath
        self.query = query
        self.header = header
    }
    
    // MARK: - Operation Execution
    override func main() {
        if !searchOperator.isImageEnd() {
            group.enter()
            requestImage()
        } else {
            self.searchOperator.imageData = nil
        }
        
        if !searchOperator.isVclipEnd() {
            group.enter()
            requestVclip()
        } else {
            self.searchOperator.vclipData = nil
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
                                    self.searchOperator.imageData = data
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
                                    self.searchOperator.vclipData = data
                                    self.group.leave()
        }) { (error) in
            self.error = error
            self.group.leave()
        }
    }
}























