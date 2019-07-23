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
    @IBOutlet weak var alcBottomOfDatetime: NSLayoutConstraint!
    @IBOutlet weak var alcTopOfDateTime: NSLayoutConstraint!
    @IBOutlet weak var alcTopOfNameLabel: NSLayoutConstraint!
    @IBOutlet weak var alcTopOfImageView: NSLayoutConstraint!
    @IBOutlet weak var alcLeadingOfDatetime: NSLayoutConstraint!
    
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        alcTopOfImageView.constant = EJSizeHeight(16.0)
        alcTopOfNameLabel.constant = EJSizeHeight(10.0)
        alcTopOfDateTime.constant = EJSizeHeight(5.0)
        alcBottomOfDatetime.constant = EJSizeHeight(32.0)
        alcLeadingOfDatetime.constant = EJSizeWidth(16.0)
    }

}
