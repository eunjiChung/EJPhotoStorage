//
//  BasicViewController.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 22/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController {

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Alert View Controller
    public func presentAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }

}
