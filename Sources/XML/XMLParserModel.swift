//
//  Created by Vladimir Burdukov on 08/23/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Gnomon

public protocol XMLParserModel: BaseModel {
  init(_ xmlParser: XMLParser) throws
}

public extension XMLParserModel {

  static func model(with data: Data, atPath path: String?) throws -> Self {

//    guard path == nil else {
//      throw Gnomon.Error.unableToParseModel("xpath is not supporterd with XMLParser")
//    }

    let xmlParser = XMLParser(data: data)
    return try Self(xmlParser)
  }

  static func models(with data: Data, atPath path: String?) throws -> [Self] {
    throw "Not implemented"
  }

  static func optionalModels(with data: Data, atPath path: String?) throws -> [Self?] {
    throw "Not implemented"
  }

}
