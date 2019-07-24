//
//  Extension.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 22/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadImageNone(_ urlString: String) {
        
        if let cacheImage = imageCache.object(forKey: urlString as NSString) {
            self.run(with: cacheImage)
            return
        }
        
        EJLibrary.shared.downloadImage(with: urlString) { (image) in
            
            imageCache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    func run(with image: UIImage) {
        UIView.transition(with: self,
                          duration: 0.5,
                          options: [],
                          animations: { self.image = image },
                          completion: nil)
    }
}
