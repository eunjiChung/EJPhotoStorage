//
//  ResultCollectionViewCell.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ResultCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Public Method
    public func setImage(url: String) {
        EJLibrary.shared.setImageUrlToImageView(imageUrl: url, imageView: imageView) {
            print("Setting Image....Completion is going on..")
        }
    }

}
