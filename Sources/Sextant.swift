//
//  Created by Sergei Mikhan on 01/31/18.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Foundation

public struct Settings {
  public var baseUrl: String
  public var username: String
  public var password: String

  public init(baseUrl: String = "", username: String = "", password: String = "") {
    self.baseUrl = baseUrl
    self.username = username
    self.password = password
  }
}
