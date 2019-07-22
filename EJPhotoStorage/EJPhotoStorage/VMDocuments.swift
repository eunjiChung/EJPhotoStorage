//
//  VMDocuments.swift
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 21/07/2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class VMDocuments: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let playTime = "play_time"
    static let datetime = "datetime"
    static let title = "title"
    static let author = "author"
    static let url = "url"
    static let thumbnail = "thumbnail"
  }

  // MARK: Properties
  public var playTime: Int?
  public var datetime: String?
  public var title: String?
  public var author: String?
  public var url: String?
  public var thumbnail: String?

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
    playTime = json[SerializationKeys.playTime].int
    datetime = json[SerializationKeys.datetime].string
    title = json[SerializationKeys.title].string
    author = json[SerializationKeys.author].string
    url = json[SerializationKeys.url].string
    thumbnail = json[SerializationKeys.thumbnail].string
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = playTime { dictionary[SerializationKeys.playTime] = value }
    if let value = datetime { dictionary[SerializationKeys.datetime] = value }
    if let value = title { dictionary[SerializationKeys.title] = value }
    if let value = author { dictionary[SerializationKeys.author] = value }
    if let value = url { dictionary[SerializationKeys.url] = value }
    if let value = thumbnail { dictionary[SerializationKeys.thumbnail] = value }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.playTime = aDecoder.decodeObject(forKey: SerializationKeys.playTime) as? Int
    self.datetime = aDecoder.decodeObject(forKey: SerializationKeys.datetime) as? String
    self.title = aDecoder.decodeObject(forKey: SerializationKeys.title) as? String
    self.author = aDecoder.decodeObject(forKey: SerializationKeys.author) as? String
    self.url = aDecoder.decodeObject(forKey: SerializationKeys.url) as? String
    self.thumbnail = aDecoder.decodeObject(forKey: SerializationKeys.thumbnail) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(playTime, forKey: SerializationKeys.playTime)
    aCoder.encode(datetime, forKey: SerializationKeys.datetime)
    aCoder.encode(title, forKey: SerializationKeys.title)
    aCoder.encode(author, forKey: SerializationKeys.author)
    aCoder.encode(url, forKey: SerializationKeys.url)
    aCoder.encode(thumbnail, forKey: SerializationKeys.thumbnail)
  }

}
