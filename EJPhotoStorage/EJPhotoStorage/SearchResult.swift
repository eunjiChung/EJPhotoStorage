//
//  SearchResult.swift
//  EJPhotoStorage
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 24/07/2019.
//  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
//

import Foundation

class SearchResult: Decodable {
    
    enum CodingKeys: CodingKey {
        case meta, documents
    }
    
    // MARK: - Decodable Property
    let meta: Meta
    var documents: [Document]
    
    // MARK: - init
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        meta = try container.decode(Meta.self, forKey: .meta)
        
        var documentArray = try container.nestedUnkeyedContainer(forKey: .documents)
        
        var array: [Document] = []
        
        while !documentArray.isAtEnd {
            let document = try documentArray.decode(Document.self)
            array.append(document)
        }
        
        documents = array
    }
}
