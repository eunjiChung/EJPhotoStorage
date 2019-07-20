//
//  PhotoDetailCollectionViewCell.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class PhotoDetailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    static let identifier = "PhotoDetailCollectionViewCell"

    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var imageDatetime: UILabel!
    
    // MARK: - Alc of Constraints
    @IBOutlet weak var alcHeightOfImageView: NSLayoutConstraint!
    @IBOutlet weak var alcHeightOfImageName: NSLayoutConstraint!
    
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        alcHeightOfImageView.constant = EJSizeHeight(569.0)
        alcHeightOfImageName.constant = EJSizeHeight(28.0)
    
    }

}
