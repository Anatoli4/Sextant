//
//  Created by Eugen Filipkov on 2/22/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

/*
 This class represents F3 standings for select competition with season. Sample request:
 "/feed_type=F26&competition=24&&season_id=2017"
 Specification:
 http://praxis.optasports.com/documentation/football-feed-specifications/f03-standings.aspx
 */

public struct F3Model: XMLFuziModel {
  public let competitionInfo: F3CompetitionInfoModel
  public let groups: [F3GroupModel]
  private(set) var qualification: F3QualificationModel?

  public init(_ xml: XMLElement) throws {
    guard let competition = xml.firstChild(staticTag: "Competition") else { throw "F3 miss Competition root" }
    competitionInfo = try F3CompetitionInfoModel(xml)
    let teams = xml.children(staticTag: "Team")
    groups = try competition.children(staticTag: "TeamStandings")
      .flatMap { try F3GroupModel($0,
                                  allTeams: teams) }
    if let qualificationType = xml.firstChild(staticTag: "Qualification")?.firstChild(staticTag: "Type") {
      qualification = try F3QualificationModel(qualificationType)
    }
  }
}

// swiftlint:disable variable_name
public struct F3CompetitionInfoModel: XMLFuziModel {
  public let id: String
  public let name: String
  public let code: String
  public let season: String
  public let seasonName: String
  private(set) var currentRound: Int?
  private(set) var round: Int?

  public init(_ xml: XMLElement) throws {
    let attributes = xml.attributes
    id = attributes["competition_id"] ?? ""
    name = attributes["competition_name"] ?? ""
    code = attributes["competition_code"] ?? ""
    season = attributes["season_id"] ?? ""
    seasonName = attributes["season_name"] ?? ""
    if let value = attributes["Round"] {
      round = Int(value)
    }
    if let value = attributes["CurrentRound"] {
      currentRound = Int(value)
    }
  }
}
