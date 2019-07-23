//
//  Meta2.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 24/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import Foundation

struct Meta: Decodable {
    
    var pageableCount: Int
    var totalCount: Int
    var isEnd: Bool
    
    enum CodingKeys: String, CodingKey {
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
        case isEnd = "is_end"
    }
    
}
