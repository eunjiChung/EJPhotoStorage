//
//  Image.swift
//  TwoApiCallText
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 22/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

enum ImageRecordState {
    case new, downloaded, fail, cancel
}

class ImageRecord: NSObject {
    
    var image: UIImage?
    var datetime: String?
    var imageUrl: String?
    var state: ImageRecordState
    
    init(with imageDocument: IMDocuments) {
        self.imageUrl = imageDocument.thumbnailUrl
        self.datetime = imageDocument.datetime
        self.image = UIImage.init() // 나중에는 placeholder 이미지 넣기!
        self.state = .new
    }
    
    init(with vclipDocument: VMDocuments) {
        self.imageUrl = vclipDocument.thumbnail
        self.datetime = vclipDocument.datetime
        self.image = UIImage.init()
        self.state = .new
    }
    
}
