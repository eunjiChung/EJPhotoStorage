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
    
    // MARK: - Alc of Layout constraints
    @IBOutlet weak var alcBottomOfImageDatetime: NSLayoutConstraint!
    @IBOutlet weak var alcTopOfImageDatetime: NSLayoutConstraint!
    @IBOutlet weak var alcTopOfImageName: NSLayoutConstraint!
    @IBOutlet weak var alcTopOfImageView: NSLayoutConstraint!
    @IBOutlet weak var alcLeadingOfDatetime: NSLayoutConstraint!
    
    
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        alcBottomOfImageDatetime.constant = EJSizeHeight(32.0)
        alcLeadingOfDatetime.constant = EJSizeWidth(16.0)
        alcTopOfImageDatetime.constant = EJSizeHeight(5.0)
        alcTopOfImageName.constant = EJSizeHeight(10.0)
        alcTopOfImageView.constant = EJSizeHeight(32.0)
    }

}
