//
//  Created by Vladimir Burdukov on 08/23/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Gnomon
import Fuzi

public protocol XMLFuziModel: BaseModel {
  init(_ xml: XMLElement) throws
}

public extension XMLFuziModel {

  static func model(with data: Data, atPath path: String?) throws -> Self {

    guard let path = path else {
      throw Gnomon.Error.unableToParseModel("invalid xpath")
    }

    let document = try XMLDocument(data: data)

    guard let rootNode = document.root?.xpath("//" + path).first else {
      throw Gnomon.Error.unableToParseModel("invalid response or xpath")
    }

    return try Self(rootNode)
  }

  static func models(with data: Data, atPath path: String?) throws -> [Self] {
    throw "Not implemented"
  }

  static func optionalModels(with data: Data, atPath path: String?) throws -> [Self?] {
    throw "Not implemented"
  }

}
