//
//  VMMeta.swift
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 21/07/2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class VMMeta: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let pageableCount = "pageable_count"
    static let totalCount = "total_count"
    static let isEnd = "is_end"
  }

  // MARK: Properties
  public var pageableCount: Int?
  public var totalCount: Int?
  public var isEnd: Bool? = false

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
    pageableCount = json[SerializationKeys.pageableCount].int
    totalCount = json[SerializationKeys.totalCount].int
    isEnd = json[SerializationKeys.isEnd].boolValue
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = pageableCount { dictionary[SerializationKeys.pageableCount] = value }
    if let value = totalCount { dictionary[SerializationKeys.totalCount] = value }
    dictionary[SerializationKeys.isEnd] = isEnd
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.pageableCount = aDecoder.decodeObject(forKey: SerializationKeys.pageableCount) as? Int
    self.totalCount = aDecoder.decodeObject(forKey: SerializationKeys.totalCount) as? Int
    self.isEnd = aDecoder.decodeBool(forKey: SerializationKeys.isEnd)
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(pageableCount, forKey: SerializationKeys.pageableCount)
    aCoder.encode(totalCount, forKey: SerializationKeys.totalCount)
    aCoder.encode(isEnd, forKey: SerializationKeys.isEnd)
  }

}
