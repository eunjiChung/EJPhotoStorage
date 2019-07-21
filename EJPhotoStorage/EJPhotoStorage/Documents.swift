//
//  Documents.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 21/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class Documents: NSObject {
    
    let identifier: String
    var images: [Image]
    
    init(with id:String) {
        self.identifier = id
        self.images = []
    }
    
    // MARK: - Public Method
    public func addImageDocument(_ images:[IMDocuments]) {
        images.forEach {
            let newImage = Image.init(by: $0)
            self.images.append(newImage)
        }
    }
    
    public func addVclipDocument(_ vclips:[VMDocuments]) {
        vclips.forEach {
            let newVclip = Image.init(by: $0)
            self.images.append(newVclip)
        }
    }
    
    public func generateUrlToImage() {
        images.forEach { (image) in
            image.generateUrlToImage(urlString: image.imageUrl!)
        }
    }
}
