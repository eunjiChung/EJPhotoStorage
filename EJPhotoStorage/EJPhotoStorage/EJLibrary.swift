//
//  EJLibrary.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 20/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import Foundation
import UIKit

// MARK: - API Path
public let photoAPI                             =   ""
public let videoAPI                             =   ""

// MARK: - Screen Size
public let EJ_SCREEN_WIDTH: CGFloat             =   UIScreen.main.bounds.width
public let EJ_SCREEN_HEIGHT: CGFloat            =   UIScreen.main.bounds.height
public let EJ_SCREEN_HEIGHT_812 : CGFloat       =   812.0
public let EJ_SCREEN_WIDTH_414: CGFloat         =   414.0
public let EJ_SCREEN_WIDTH_375: CGFloat         =   375.0

// MARK: - Auto Layout
func EJSize(_ standardSize: CGFloat) -> CGFloat {
    // iPhoneX 기준으로 잡음
    return round(standardSize * (EJ_SCREEN_WIDTH / EJ_SCREEN_WIDTH_375))
}

func EJSizeHeight(_ size: CGFloat) -> CGFloat {
    return round(size * (EJ_SCREEN_HEIGHT / EJ_SCREEN_HEIGHT_812))
}

class EJLibrary : NSObject {
    
}
