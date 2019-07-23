//
//  Extension.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 22/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageNone(_ urlString: String) {
        // 뭐하러...
        let tinyDelay = DispatchTime.now() + Double(Int64(0.001 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.run(with: cacheImage)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Couldn't download image: ", error)
                return
            }
            
            guard let data = data else { return }
            let image = UIImage(data: data)!
            imageCache.setObject(image, forKey: urlString as AnyObject)
            
            //            DispatchQueue.main.asyncAfter(deadline: tinyDelay) {
            //                self.run(with: image)
            //            }
            DispatchQueue.main.async {
                self.image = image
            }
            }.resume()
    }
    
    func loadImageCrossDissolve(_ urlString: String) {
        
        // 뭐하러...
        let tinyDelay = DispatchTime.now() + Double(Int64(0.001 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.run(with: cacheImage)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Couldn't download image: ", error)
                return
            }
            
            guard let data = data else { return }
            let image = UIImage(data: data)!
            imageCache.setObject(image, forKey: urlString as AnyObject)
            
//            DispatchQueue.main.asyncAfter(deadline: tinyDelay) {
//                self.run(with: image)
//            }
            DispatchQueue.main.async {
                self.run(with: image)
            }
        }.resume()
    }
    
    func run(with image: UIImage) {
        UIView.transition(with: self,
                          duration: 0.5,
                          options: UIView.AnimationOptions.transitionCrossDissolve,
                          animations: { self.image = image },
                          completion: nil)
    }
}
