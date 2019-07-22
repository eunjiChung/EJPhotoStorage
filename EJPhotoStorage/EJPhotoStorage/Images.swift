//
//  Images.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 22/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

public class Images: NSObject {
    
    let identifier: String?
    
    var imageRecords: [ImageRecord] = []
    var imageCache: [String: UIImage] = [:]
    var page = 0
    
    var isImageEnd = false
    var isVclipEnd = false
    var isEnd = false
    
    // MARK: - Initializer
    init(with id: String) {
        self.identifier = id
    }
    
    // MARK: - Public function
    func appendImageRecords(with vclipRecords: [ImageRecord]) {
        // append image and vclip records
        vclipRecords.forEach { imageRecords.append($0) }
    }
}
