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
    
    public func ej_setImage(with image: UIImage) {
        let tinyDelay = DispatchTime.now() + Double(Int64(0.001 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: tinyDelay) {
            self.run(with: image)
        }
    }
    
    public func run(with image: UIImage) {
        UIView.transition(with: self,
                          duration: 0.5,
                          options: UIView.AnimationOptions.transitionCrossDissolve,
                          animations: { self.image = image },
                          completion: nil)
    }
}
