//
//  IMDocuments.swift
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 21/07/2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class IMDocuments: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let height = "height"
    static let thumbnailUrl = "thumbnail_url"
    static let width = "width"
    static let docUrl = "doc_url"
    static let displaySitename = "display_sitename"
    static let imageUrl = "image_url"
    static let collection = "collection"
    static let datetime = "datetime"
  }

  // MARK: Properties
  public var height: Int?
  public var thumbnailUrl: String?
  public var width: Int?
  public var docUrl: String?
  public var displaySitename: String?
  public var imageUrl: String?
  public var collection: String?
  public var datetime: String?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public convenience init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public required init(json: JSON) {
    height = json[SerializationKeys.height].int
    thumbnailUrl = json[SerializationKeys.thumbnailUrl].string
    width = json[SerializationKeys.width].int
    docUrl = json[SerializationKeys.docUrl].string
    displaySitename = json[SerializationKeys.displaySitename].string
    imageUrl = json[SerializationKeys.imageUrl].string
    collection = json[SerializationKeys.collection].string
    datetime = json[SerializationKeys.datetime].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = height { dictionary[SerializationKeys.height] = value }
    if let value = thumbnailUrl { dictionary[SerializationKeys.thumbnailUrl] = value }
    if let value = width { dictionary[SerializationKeys.width] = value }
    if let value = docUrl { dictionary[SerializationKeys.docUrl] = value }
    if let value = displaySitename { dictionary[SerializationKeys.displaySitename] = value }
    if let value = imageUrl { dictionary[SerializationKeys.imageUrl] = value }
    if let value = collection { dictionary[SerializationKeys.collection] = value }
    if let value = datetime { dictionary[SerializationKeys.datetime] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.height = aDecoder.decodeObject(forKey: SerializationKeys.height) as? Int
    self.thumbnailUrl = aDecoder.decodeObject(forKey: SerializationKeys.thumbnailUrl) as? String
    self.width = aDecoder.decodeObject(forKey: SerializationKeys.width) as? Int
    self.docUrl = aDecoder.decodeObject(forKey: SerializationKeys.docUrl) as? String
    self.displaySitename = aDecoder.decodeObject(forKey: SerializationKeys.displaySitename) as? String
    self.imageUrl = aDecoder.decodeObject(forKey: SerializationKeys.imageUrl) as? String
    self.collection = aDecoder.decodeObject(forKey: SerializationKeys.collection) as? String
    self.datetime = aDecoder.decodeObject(forKey: SerializationKeys.datetime) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(height, forKey: SerializationKeys.height)
    aCoder.encode(thumbnailUrl, forKey: SerializationKeys.thumbnailUrl)
    aCoder.encode(width, forKey: SerializationKeys.width)
    aCoder.encode(docUrl, forKey: SerializationKeys.docUrl)
    aCoder.encode(displaySitename, forKey: SerializationKeys.displaySitename)
    aCoder.encode(imageUrl, forKey: SerializationKeys.imageUrl)
    aCoder.encode(collection, forKey: SerializationKeys.collection)
    aCoder.encode(datetime, forKey: SerializationKeys.datetime)
  }

}
