//
//  Created by Eugen Filipkov on 2/23/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

public struct F3QualificationModel: XMLFuziModel {
  public enum Kind: String {
    case undefined
    case promotion = "promotion"
    case relegation = "relegation"
    case europaCup = "europa_cup"
    case championsLeagueQualifying = "champions_league_qualifying"
    case championsLeagueGroup = "champions_league group"
  }
  public let kind: Kind
  public let teams: [F3QualificationTeamModel]

  public init(_ xml: XMLElement) throws {
    kind = Kind(rawValue: xml.attr("qualify")?.lowercased() ?? "") ?? .undefined
    teams = try xml.children(staticTag: "Team").flatMap { try F3QualificationTeamModel($0) }
  }
}

// swiftlint:disable variable_name
public struct F3QualificationTeamModel: XMLFuziModel {
  public enum Kind: String {
    case undefined
    case leagueWinners = "league_winners"
    case leaguePosition = "league_position"
    case cupWinners = "cup_winners"
    case cupRunnerUp = "cup_runner_up"
    case uefaFairPlay = "uefa_fair_play"
    case titleHolder = "title_holder"
    case playOff = "play_off"
    case playoffRelegation = "playoff_relegation"
    case playoffPromotion = "playoff_promotion"
  }
  public let id: String
  public let name: String
  public let kind: Kind

  public init(_ xml: XMLElement) throws {
    let attributes = xml.attributes
    kind = Kind(rawValue: attributes["method"]?.lowercased() ?? "") ?? .undefined
    id = attributes["team_id"] ?? ""
    name = attributes["team_name"] ?? ""
  }
}
