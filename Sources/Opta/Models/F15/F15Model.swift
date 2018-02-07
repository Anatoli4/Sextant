//
//  Created by Sergei Mikhan on 01/31/18.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Fuzi

/*
 This class represents F15 season statistics including all matches',
 teams' and players' statistics. Sample request:
 "/competition.php?feed_type=f15&competition=5&season_id=2016"
 Note: matches' statistics are not present yet.
 */

public struct F15Model: XMLFuziModel {

  public let seasonId: String
  public let seasonName: String
  public let competitionId: String
  public let competitionName: String
  public let competitionCode: String
  public let statisticsType: String

  public let teams: [F15TeamModel]

  public init(_ xml: XMLElement) throws {
    let attributes = xml.attributes

    seasonId = attributes["season_id"] ?? ""
    seasonName = attributes["season_name"] ?? ""
    competitionId = attributes["competition_id"] ?? ""
    competitionName = attributes["competition_name"] ?? ""
    competitionCode = attributes["competition_code"] ?? ""
    statisticsType = attributes["Type"] ?? ""

    teams = try xml.children(tag: "Team").map { try F15TeamModel($0) }
  }
}
