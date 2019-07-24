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
    var imageUrl: String?
    
    var width: Int?
    var height: Int?
    var detailUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case datetime, thumbnail, thumbnailUrl = "thumbnail_url", width, height, detailUrl = "image_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        datetime = try container.decode(String.self, forKey: .datetime)
        
        if container.contains(.thumbnail) {
            imageUrl = try container.decodeIfPresent(String.self, forKey: .thumbnail)
        } else {
            imageUrl = try container.decodeIfPresent(String.self, forKey: .thumbnailUrl)
        }
        
        width = try container.decodeIfPresent(Int.self, forKey: .width)
        height = try container.decodeIfPresent(Int.self, forKey: .height)
        detailUrl = try container.decodeIfPresent(String.self, forKey: .detailUrl)
    }
    
    func dateToString() -> String {
        print("Date:", datetime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss.SSS+XX:XX"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return ""
//        print("String:", dateFormatter.string(from: datetime))
//        return dateFormatter.string(from: datetime)
    }
}
