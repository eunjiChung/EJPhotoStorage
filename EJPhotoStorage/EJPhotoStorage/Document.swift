//
//  Document.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 24/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import Foundation

struct Document: Decodable {
    
    var datetime: String
    var imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case datetime, thumbnail, thumbnailUrl = "thumbnail_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let containerKeys = Set(container.allKeys)
        let imageKeys = Set<CodingKeys>([.datetime, .thumbnailUrl])
        let vclipKeys = Set<CodingKeys>([.datetime, .thumbnail])
        
        switch containerKeys {
        case imageKeys:
            datetime = try container.decode(String.self, forKey: .datetime)
            imageUrl = try container.decode(String.self, forKey: .thumbnailUrl)
        case vclipKeys:
            datetime = try container.decode(String.self, forKey: .datetime)
            imageUrl = try container.decode(String.self, forKey: .thumbnail)
        default:
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Not enough keys!")
            throw DecodingError.dataCorrupted(context)
        }
    }
}
