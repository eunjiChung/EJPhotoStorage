//
//  Image.swift
//  TwoApiCallText
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 22/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

// 아예 Codable로 바꾸는 작업이 필요할 듯.....
class ImageRecord: Codable {
    
    var image: UIImage
    var datetime: String?
    var imageUrl: String?
    
    var imageWidth: Int?
    var imageHeight: Int?
    
    // MARK: - Initializer
    init(with imageDocument: IMDocuments) {
        self.imageUrl = imageDocument.thumbnailUrl
        self.datetime = imageDocument.datetime
        self.imageWidth = imageDocument.width
        self.imageHeight = imageDocument.height
        self.image = UIImage.init(named: "Placeholder")!
    }
    
    init(with vclipDocument: VMDocuments) {
        self.imageUrl = vclipDocument.thumbnail
        self.datetime = vclipDocument.datetime
        self.image = UIImage.init(named: "Placeholder")!
    }
    
    // MARK: - Public Method
    public func dateTimeInt() -> Int {
        if let datetime = self.datetime {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
        }
        return 0
    }
    
}
