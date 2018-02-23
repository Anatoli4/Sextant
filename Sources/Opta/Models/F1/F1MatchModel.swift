//
//  Created by Eugen Filipkov on 2/2/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

// swiftlint:disable variable_name
public struct F1MatchModel {
  public struct StadiumInfo: XMLFuziModel {
    public let id: String
    public let name: String
    public let city: String

    public init(_ xml: XMLElement) throws {
      id = xml.firstChild(staticTag: "MatchInfo")?.attr("Venue_id") ?? ""
      name = xml.children(staticTag: "Stat").first { $0.attr("Type") == "Venue" }?.stringValue ?? ""
      city = xml.children(staticTag: "Stat").first { $0.attr("Type") == "City" }?.stringValue ?? ""
    }
  }
  public enum PostponedOrAbandonedReason: String {
    case undefined = ""
    case unknown = "unknown"
    case fog = "fog"
    case snow = "snow"
    case waterloggedPitch = "waterlogged pitch"
    case frozenPitch = "frozen pitch"
    case weather = "weather"
    case lightFailure = "flood light failure"
    case insufficientPlayers = "insufficient players"
    case crowd = "Crowd"
    case other = "other"
  }
  public enum LegType: String {
    case undefined = ""
    case first = "1st Leg"
    case second = "2nd Leg"
  }
  public enum GameWinnerType: String {
    case undefined = ""
    case extraTime = "AfterExtraTime"
    case shootOut = "ShootOut"
  }

  public let id: String
  public let competitionInfo: F1CompetitionInfoModel
  public let stadiumInfo: StadiumInfo
  public let day: Int
  public let type: MatchType
  public let winnerId: String
  public let status: MatchStatus
  public private(set) var postponedOrAbandonedReason: PostponedOrAbandonedReason?
  public private(set) var legType: LegType?
  public private(set) var firstLegId: String?
  public private(set) var legWinnerId: String?
  public private(set) var nextMatchId: String?
  public private(set) var nextMatchLoserId: String?
  public private(set) var roundNumber: Int?
  public private(set) var roundType: RoundType?
  public private(set) var groupName: String?
  public private(set) var gameWinnerType: GameWinnerType?
  public private(set) var date: Date?
  public let homeTeam: F1TeamModel
  public let awayTeam: F1TeamModel

  // swiftlint:disable:next function_body_length cyclomatic_complexity
  public init(_ xml: XMLElement,
              teamsInfo: [XMLElement],
              competitionInfo: F1CompetitionInfoModel) throws {
    let attributes = xml.attributes
    guard let uId = attributes["uID"], uId.isEmpty == false else { throw "miss F1 match id" }
    let teams = xml.children(staticTag: "TeamData")
    guard let home = teams.first(where: { $0.attr("Side") == "Home" }) else { throw "miss F1 home team" }
    guard let away = teams.first(where: { $0.attr("Side") == "Away" }) else { throw "miss F1 away team" }

    id = String(uId.dropFirst())
    self.competitionInfo = competitionInfo
    stadiumInfo = try StadiumInfo(xml)
    let matchInfo = xml.firstChild(staticTag: "MatchInfo")
    let matchInfoAttributes = matchInfo?.attributes
    day = Int(matchInfoAttributes?["MatchDay"] ?? "0") ?? 0
    type = MatchType(rawValue: (matchInfoAttributes?["MatchType"] ?? "").lowercased()) ?? .undefined
    let winner = matchInfoAttributes?["MatchWinner"] ?? ""
    let gameWinner = matchInfoAttributes?["GameWinner"] ?? ""
    winnerId = String(winner.isEmpty ? (gameWinner.isEmpty ? "" : gameWinner.dropFirst()) : winner.dropFirst())
    status = MatchStatus(statusString: matchInfoAttributes?["Period"] ?? "")
    if let reason = xml.children(staticTag: "Stat").first(where: { $0.attr("Type") == "Abandoned" ||
      $0.attr("Type") == "Postponed" })?.stringValue {
        postponedOrAbandonedReason = PostponedOrAbandonedReason(rawValue: reason)
    }
    if let leg = matchInfoAttributes?["Leg"] {
      legType = LegType(rawValue: leg)
    }
    if let id = matchInfoAttributes?["FirstLegId"] {
      firstLegId = String(id.dropFirst())
    }
    if let id = matchInfoAttributes?["LegWinner"] {
      legWinnerId = String(id.dropFirst())
    }
    if let id = matchInfoAttributes?["NextMatch"] {
      nextMatchId = String(id.dropFirst())
    }
    if let id = matchInfoAttributes?["NextMatchLoser"] {
      nextMatchLoserId = id
    }
    if let number = matchInfoAttributes?["RoundNumber"] {
      roundNumber = Int(number)
    }
    if let type = matchInfoAttributes?["RoundType"] {
      roundType = RoundType(rawValue: type) ?? .undefined
    }
    groupName = matchInfoAttributes?["GroupName"]
    if let type = matchInfoAttributes?["GameWinnerType"] {
      gameWinnerType = GameWinnerType(rawValue: type) ?? .undefined
    }
    let dateString = matchInfo?.firstChild(staticTag: "Date")?.stringValue ?? ""
    let timeZoneAbbreviation = matchInfo?.firstChild(staticTag: "TZ")?.stringValue ??
      DateUtils.defaultTimeZoneAbbreviation
    let formatter = DateUtils.dateFormaterWith("yyyy-MM-dd HH:mm:ss",
                                               timeZoneAbbreviation: timeZoneAbbreviation)
    let dateFormatter = DateUtils.dateFormaterWith("yyyy-MM-dd",
                                                   timeZoneAbbreviation: timeZoneAbbreviation)
    let timeFormatter = DateUtils.dateFormaterWith("HH:mm:ss",
                                                   timeZoneAbbreviation: timeZoneAbbreviation)
    if let date = formatter.date(from: dateString) {
      self.date = date
    } else if let date = dateFormatter.date(from: dateString) {
      self.date = date
    } else if let date = timeFormatter.date(from: dateString) {
      self.date = date
    }
    homeTeam = try F1TeamModel(home,
                               teamsInfo: teamsInfo)
    awayTeam = try F1TeamModel(away,
                               teamsInfo: teamsInfo)
  }
}
