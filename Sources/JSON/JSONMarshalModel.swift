//
//  Created by Vladimir Burdukov on 08/23/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Gnomon
import Marshal

public protocol JSONMarshalModel: BaseModel, Unmarshaling {
}

public extension JSONMarshalModel {

  static func model(with data: Data, atPath path: String?) throws -> Self {
//    let json = try JSON(data: data)
//
//
//    let xpathed = try json.xpath(path)
//    if let error = xpathed.error {
//      throw Gnomon.Error.unableToParseModel(error)
//    }
//    return try Self(xpathed)

    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
      throw "No json"
    }
    guard let path = path else {
      return try Self(object: json)
    }
    return try json.value(for: path.replacingOccurrences(of: "/", with: "."))
  }

  static func models(with data: Data, atPath path: String?) throws -> [Self] {
    throw "Not supported"
  }

  static func optionalModels(with data: Data, atPath path: String?) throws -> [Self?] {
    throw "Not supported"
  }

}

//extension Unmarshaling {
//
//  func xpath(_ path: String) throws -> Unmarshaling {
//    guard path.count > 0 else { throw "empty xpath" }
//    let components = path.components(separatedBy: "/")
//    guard components.count > 0 else { return self }
//    return try xpath(components)
//  }
//
//  private func xpath(_ components: [String]) throws -> Unmarshaling {
//    guard let key = components.first else { return self }
//    let value = self[key]
//    guard value.exists() else {
//      throw "can't find key \(key) in json \(self)"
//    }
//    return try value.xpath(Array(components.dropFirst()))
//  }
//
//}

