//
//  Photo.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class Photo: NSObject {
    
    var name: String
    var image: UIImage
    var dateTime: String
    
    init(name: String, image: UIImage, dateTime: String) {
        self.name = name
        self.image = image
        self.dateTime = dateTime
    }
}
