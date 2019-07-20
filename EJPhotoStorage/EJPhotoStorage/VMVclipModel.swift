//
//  VMVclipModel.swift
//
//  Created by DEV_MOBILE_IOS_JUNIOR on 21/07/2019
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public final class VMVclipModel: NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let documents = "documents"
    static let meta = "meta"
  }

  // MARK: Properties
  public var documents: [VMDocuments]?
  public var meta: VMMeta?

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
    if let items = json[SerializationKeys.documents].array { documents = items.map { VMDocuments(json: $0) } }
    meta = VMMeta(json: json[SerializationKeys.meta])
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = documents { dictionary[SerializationKeys.documents] = value.map { $0.dictionaryRepresentation() } }
    if let value = meta { dictionary[SerializationKeys.meta] = value.dictionaryRepresentation() }
    return dictionary
  }

  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.documents = aDecoder.decodeObject(forKey: SerializationKeys.documents) as? [VMDocuments]
    self.meta = aDecoder.decodeObject(forKey: SerializationKeys.meta) as? VMMeta
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(documents, forKey: SerializationKeys.documents)
    aCoder.encode(meta, forKey: SerializationKeys.meta)
  }

}
