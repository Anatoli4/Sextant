//
//  Created by Eugen Filipkov on 2/2/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

// swiftlint:disable variable_name
public struct F1CompetitionInfoModel: XMLFuziModel {
  public let id: String
  public let name: String
  public let code: String
  public let season: String
  public let seasonName: String

  public init(_ xml: XMLElement) throws {
    let attributes = xml.attributes
    id = attributes["competition_id"] ?? ""
    name = attributes["competition_name"] ?? ""
    code = attributes["competition_code"] ?? ""
    season = attributes["season_id"] ?? ""
    seasonName = attributes["season_name"] ?? ""
  }
}
