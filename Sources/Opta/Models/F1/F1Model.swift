//
//  Created by Eugen Filipkov on 2/2/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

/*
 This class represents F1 competion all matches. Sample request:
 "/competition.php?feed_type=f1&competition=24&season_id=2017"
 Specification:
  http://optasports.com/en/praxis/documentation/football-feed-specifications/f01-fixtures-and-results.aspx
 */

public struct F1Model: XMLFuziModel {
  public let competitionInfo: F1CompetitionInfo
  public let matches: [F1MatchModel]
  public var teams: [F1TeamMatchesModel]

  public init(_ xml: XMLElement) throws {
    competitionInfo = try F1CompetitionInfo(xml)
    let teamsInfo = xml.children(staticTag: "Team")
    matches = try xml.children(staticTag: "MatchData")
      .map { try F1MatchModel($0,
                              teamsInfo: teamsInfo) }
    teams = Array(matches.reduce([String: F1TeamMatchesModel]()) { teams, match ->
      [String: F1TeamMatchesModel] in
      var teams = teams
      var homeTeam: F1TeamMatchesModel
      if let _homeTeam = teams[match.homeTeam.id] {
        homeTeam = _homeTeam
      } else {
        homeTeam = F1TeamMatchesModel(matchTeam: match.homeTeam)
      }
      homeTeam.matches.append(match)
      var awayTeam: F1TeamMatchesModel
      if let _awayTeam = teams[match.awayTeam.id] {
        awayTeam = _awayTeam
      } else {
        awayTeam = F1TeamMatchesModel(matchTeam: match.awayTeam)
      }
      awayTeam.matches.append(match)
      teams[homeTeam.id] = homeTeam
      teams[awayTeam.id] = awayTeam

      return teams
      }.values)
  }
}
