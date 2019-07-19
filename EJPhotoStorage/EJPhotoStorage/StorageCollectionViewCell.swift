//
//  StorageCollectionViewCell.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 20/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class StorageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    static let identifier = "StorageCollectionViewCell"
    
    // MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
