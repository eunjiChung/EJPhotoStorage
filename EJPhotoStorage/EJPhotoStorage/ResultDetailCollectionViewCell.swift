//
//  ResultDetailCollectionViewCell.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 19/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class ResultDetailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    static let identifier = "ResultDetailCollectionViewCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageName: UILabel!
    @IBOutlet weak var imageDatetime: UILabel!
    
    // MARK: - Alc Layout Constraint
    @IBOutlet weak var alcTopOfImageView: NSLayoutConstraint!
    @IBOutlet weak var alcTopOfNameLabel: NSLayoutConstraint!
    @IBOutlet weak var alcTopOfDateTime: NSLayoutConstraint!
    @IBOutlet weak var alcBottomOfDatetime: NSLayoutConstraint!
    @IBOutlet weak var alcHeightOfImageView: NSLayoutConstraint!
    @IBOutlet weak var alcHeightOfImageName: NSLayoutConstraint!
    @IBOutlet weak var alcHeightOfImageDatetime: NSLayoutConstraint!
    
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        alcTopOfImageView.constant = EJSizeHeight(16.0)
        alcTopOfNameLabel.constant = EJSizeHeight(10.0)
        alcTopOfDateTime.constant = EJSizeHeight(5.0)
        alcBottomOfDatetime.constant = EJSizeHeight(16.0)
        
        alcHeightOfImageView.constant = EJSizeHeight(586.0)
        alcHeightOfImageName.constant = EJSizeHeight(28.0)
        alcHeightOfImageDatetime.constant = EJSizeHeight(20.0)
        
//        imageName.font = imageName.font.withSize(1)
//        imageDatetime.font = imageDatetime.font.withSize(1)
    }

}
