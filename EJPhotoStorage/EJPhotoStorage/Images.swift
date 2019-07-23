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
    var page = 0
    
    var isImageEnd = false
    var isVclipEnd = false
    var isEnd = false
    
    // MARK: - Initializer
    init(with id: String) {
        self.identifier = id
    }
    
    // MARK: - Public function
    // 얘는 둘 중 하나라도 없으면 못해...
    func appendImageRecords(with newRecords: [ImageRecord]) {
        newRecords.forEach { imageRecords.append($0) }
    }
    
    func sortImagesRecency() {
        imageRecords.sort { $0.dateTimeInt() > $1.dateTimeInt() }
    }
    
    func isRequestEnd() -> Bool {
        isEnd = isImageEnd && isVclipEnd
        return isEnd
    }
}
