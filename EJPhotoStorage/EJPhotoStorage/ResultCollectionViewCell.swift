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
    func setCellImage(by imageRecord: ImageRecord) {
        pendingOperations.downloadImage(with: imageRecord) {
            if let image = $0 { self.imageView.ej_setImage(with: image) }
        }
    }
}
