//
//  Photos.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class Photos: NSObject {
    
    var name: String
    var photos = [Photo]()
    
    init(name: String) {
        self.name = name
        self.photos = []
    }
    
    func buildDataSource(){
        photos = (1...9).map { Photo.init(name: "image\($0)", image: UIImage(named: "image\($0)")!, dateTime: "\($0)") }
    }
}
