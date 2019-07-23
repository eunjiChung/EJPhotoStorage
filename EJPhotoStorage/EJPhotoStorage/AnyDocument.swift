//
//  Documents2.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 24/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import Foundation

enum AnyDocument: Codable {
    // thumbnailUrl, datetime, imageurl, width, height
    case ImageDocument(String, String, String, Int, Int)
    // thumbnail, datetime
    case VclipDocument(String, String)
    case noDocument
    
    enum CodingKeys: String, CodingKey {
        case thumbnailUrl = "thumbnail_url", imageUrl = "image_url", width, height, datetime, thumbnail
    }
    
    // MARK: - Encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .ImageDocument(let thumbnailUrl, let datetime, let imageUrl, let width, let height):
            try container.encode(thumbnailUrl, forKey: .thumbnailUrl)
            try container.encode(datetime, forKey: .datetime)
            try container.encode(imageUrl, forKey: .imageUrl)
            try container.encode(width, forKey: .width)
            try container.encode(height, forKey: .height)
        case .VclipDocument(let thumbnail, let datetime):
            try container.encode(thumbnail, forKey: .thumbnail)
            try container.encode(datetime, forKey: .datetime)
        case .noDocument:
            let context = EncodingError.Context(codingPath: encoder.codingPath,
                                                debugDescription: "Invalid employee!")
            throw EncodingError.invalidValue(self, context)
        }
    }
    
    // MARK: - Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let containerKeys = Set(container.allKeys)
        let imageKey = Set<CodingKeys>([.thumbnailUrl, .datetime, .imageUrl, .width, .height])
        let vclipKey = Set<CodingKeys>([.thumbnail, .datetime])
        
        switch containerKeys {
        case imageKey:
            let thumbnailUrl = try container.decode(String.self, forKey: .thumbnailUrl)
            let datetime = try container.decode(String.self, forKey: .datetime)
            let imageUrl = try container.decode(String.self, forKey: .imageUrl)
            let width = try container.decode(Int.self, forKey: .width)
            let height = try container.decode(Int.self, forKey: .height)
            self = .ImageDocument(thumbnailUrl, datetime, imageUrl, width, height)
        case vclipKey:
            let thumbnail = try container.decode(String.self, forKey: .thumbnail)
            let datetime = try container.decode(String.self, forKey: .datetime)
            self = .VclipDocument(thumbnail, datetime)
        default:
            self = .noDocument
        }
    }
}
