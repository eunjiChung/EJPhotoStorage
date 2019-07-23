//
//  SearchResult.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 24/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import Foundation

class SearchResult: Decodable {
    
    // MARK: - Decodable Property
    var meta: Meta
    var documents: [Document]
    
    enum CodingKeys: CodingKey {
        case meta, documents
    }
}
