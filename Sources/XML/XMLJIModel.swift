//
//  Created by Vladimir Burdukov on 08/23/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Gnomon
import Ji

public protocol XMLJIModel: BaseModel {
  init(_ xml: JiNode) throws
}

public extension XMLJIModel {

  static func model(with data: Data, atPath path: String?) throws -> Self {
//    let xml = try AEXMLDocument(xml: data)
//
    guard let path = path else {
      throw Gnomon.Error.unableToParseModel("invalid xpath")
    }
//
//    let xpathed = xml.xpath(path)
//
//    guard xpathed.error == nil else {
//      throw Gnomon.Error.unableToParseModel("invalid response or xpath")
//    }
//
//    return try Self(xpathed)

    guard let rootNode = Ji(data: data, isXML: true)?.xPath("//" + path)?.first else {
      throw Gnomon.Error.unableToParseModel("invalid response or xpath")
    }

//    let attributes = rootNode.attributes
//
//    print(attributes["season_id"] ?? "")
//    print(attributes["season_name"] ?? "")
//    print(attributes["competition_id"] ?? "")
//    print(attributes["competition_name"] ?? "")
//    print(attributes["competition_code"] ?? "")
//    print(attributes["Type"] ?? "")

    return try Self(rootNode)
  }

  static func models(with data: Data, atPath path: String?) throws -> [Self] {
    throw "Not implemented"
  }

  static func optionalModels(with data: Data, atPath path: String?) throws -> [Self?] {
    throw "Not implemented"
  }

}

