//
//  Created by Eugen Filipkov on 2/9/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

/*
 This class represents F9 live match when include player stats. Sample request:
 "/feed_type=F9&game_id=920777"
 Specification:
 http://praxis.optasports.com/documentation/football-feed-specifications
 /f09-live-match-feed-plus-team-player-stats.aspx
 */

// swiftlint:disable variable_name
public struct F9StadiumModel: XMLFuziModel {
  public let id: String
  public let country: String
  public let name: String

  public init(_ xml: XMLElement) throws {
    id = String(xml.attr("uID")?.dropFirst() ?? "")
    country = xml.firstChild(staticTag: "Country")?.stringValue ?? ""
    name = xml.firstChild(staticTag: "Name")?.stringValue ?? ""
  }
}

// swiftlint:disable variable_name
public struct F9Model: XMLFuziModel {

  public let id: String
  public let competitionInfo: F9CompetitionInfoModel
  public let stadium: F9StadiumModel
  public let matchInfo: F9MatchInfoModel
  public let homeTeam: F9TeamModel
  public let awayTeam: F9TeamModel

  public init(_ xml: XMLElement) throws {
    let attributes = xml.attributes
    guard let uId = attributes["uID"] else { throw "miss F9 game id" }
    guard let competition = xml.firstChild(staticTag: "Competition") else { throw "miss F9 Competition root" }
    guard let venue = xml.firstChild(staticTag: "Venue") else { throw "miss F9 Venue root" }
    guard let matchData = xml.firstChild(staticTag: "MatchData") else { throw "miss F9 MatchData root" }

    id = String(uId.dropFirst())
    competitionInfo = try F9CompetitionInfoModel(competition)
    stadium = try F9StadiumModel(venue)
    matchInfo = try F9MatchInfoModel(matchData)
    let homeTeamData = matchData.children(staticTag: "TeamData")
      .first(where: { $0.attr("Side")?.lowercased() == "home" })
    let awayTeamData = matchData.children(staticTag: "TeamData")
      .first(where: { $0.attr("Side")?.lowercased() == "away" })
    let teams = xml.children(staticTag: "Team")
    homeTeam = try F9TeamModel(homeTeamData,
                               team: teams.first(where: { $0.attr("uID") == homeTeamData?.attr("TeamRef")}))
    awayTeam = try F9TeamModel(awayTeamData,
                               team: teams.first(where: { $0.attr("uID") == awayTeamData?.attr("TeamRef")}))
  }
}
