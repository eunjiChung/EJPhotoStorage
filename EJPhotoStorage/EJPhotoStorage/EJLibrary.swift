//
//  EJLibrary.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 20/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Type alias
typealias SuccessHandler = (Any, String) -> ()
typealias FailureHandler = (Error, String) -> ()
typealias HTTPHeaders = [String:String]

// MARK: - API Path
fileprivate let kakaoHost                       =   "https://dapi.kakao.com"
fileprivate let APIPathVclip                    =   "/v2/search/vclip"
fileprivate let APIPathPhoto                    =   "/v2/search/image"

// MARK: - APP Key
fileprivate let kakaoAPPKey                     =   "3ca11558f438d6e3d4b0c00c6ab93450"

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
    
    // MARK: - Singleton
    static let shared = EJLibrary()
    let networkManager = NetworkManager.init(baseURL: kakaoHost)
    
    // MARK: - HTTP Request
    func requestPhoto(keyword: String,
                      success: @escaping SuccessHandler,
                      failure: @escaping FailureHandler) {
        self.networkManager.GETRequest(path: APIPathPhoto,
                                       query: keyword,
                                       header: generateRequestHeader(),
                                       success: success,
                                       failure: failure)
    }
    
    func requestVclip(keyword: String,
                      success: @escaping SuccessHandler,
                      failure: @escaping FailureHandler) {
        self.networkManager.GETRequest(path: APIPathVclip,
                                       query: keyword,
                                       header: generateRequestHeader(),
                                       success: success,
                                       failure: failure)
    }
    
    // MARK: - Private Method
    fileprivate func generateRequestHeader() -> HTTPHeaders {
        return ["Authorization": "KakaoAK \(kakaoAPPKey)"]
    }
    
}
