////
////  Documents2.swift
////  EJPhotoStorage
////
////  Created by DEV_MOBILE_IOS_JUNIOR on 24/07/2019.
////  Copyright © 2019 DEV_MOBILE_IOS_JUNIOR. All rights reserved.
////
//
//import Foundation
//
//enum DocumentType: String, Codable {
//    case image, vclip
//
//    var metatype: AnyDocument.Type {
//        switch self {
//        case .image:
//            return ImageDocument.self
//        case .vclip:
//            return VclipDocument.self
//        }
//    }
//}
//
//protocol AnyDocument {
//    var imageUrl: String { get set }
//    var datetime: Date { get set }
//    
//    var type: DocumentType { get }
//}
//
//struct AnyDocumentWrapper: Decodable {
//    var anyDocument: AnyDocument
//}
//
//extension AnyDocumentWrapper {
//    // thumbnailUrl, datetime, imageurl, width, height
////    case ImageDocument(String, String, String, Int, Int)
////    // thumbnail, datetime
////    case VclipDocument(String, String)
////    case noDocument
//    
//    private enum CodingKeys: CodingKey {
//        case type, anyDocument
//    }
//    
//    // MARK: - Decodable
//    init(from decoder: Decoder) throws {
//        
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let type = try container.decode(DocumentType.self, forKey: .type)
//        self.anyDocument = try type.metatype.init(from: container.superDecoder(forKey: .anyDocument))
////        let container = try decoder.container(keyedBy: CodingKeys.self)
////        let containerKeys = Set(container.allKeys)
////        let imageKey = Set<CodingKeys>([.thumbnailUrl, .datetime, .imageUrl, .width, .height])
////        let vclipKey = Set<CodingKeys>([.thumbnail, .datetime])
////
////        switch containerKeys {
////        case imageKey:
////            let thumbnailUrl = try container.decode(String.self, forKey: .thumbnailUrl)
////            let datetime = try container.decode(String.self, forKey: .datetime)
////            let imageUrl = try container.decode(String.self, forKey: .imageUrl)
////            let width = try container.decode(Int.self, forKey: .width)
////            let height = try container.decode(Int.self, forKey: .height)
////            self = .ImageDocument(thumbnailUrl, datetime, imageUrl, width, height)
////        case vclipKey:
////            let thumbnail = try container.decode(String.self, forKey: .thumbnail)
////            let datetime = try container.decode(String.self, forKey: .datetime)
////            self = .VclipDocument(thumbnail, datetime)
////        default:
////            self = .noDocument
//        }
//    }
//}
//
//
//let decoder = JSONDecoder()
//let data = Data()
//let resp = try decoder.decode(AnyDocument.self, from: data)
//
//switch resp {
//    case .ImageDocument(<#T##String#>, <#T##String#>, <#T##String#>, <#T##Int#>, <#T##Int#>)
//}
//
