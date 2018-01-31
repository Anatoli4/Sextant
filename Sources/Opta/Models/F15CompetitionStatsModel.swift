//
//  Created by Sergei Mikhan on 01/31/18.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Fuzi

/*
 This class represents full F15 season statistics including all matches',
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

public struct F15TeamModel: XMLFuziModel {

  // swiftlint:disable:next identifier_name
  public let id: String
  public let name: String
  public let stats: [Stat]

  public var players: [F15PlayerModel]

  public init(_ xml: XMLElement) throws {
    guard let teamUId = xml.attributes["uID"] else { throw "no team" }
    let teamId = teamUId.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
    id = teamId
    name = xml.firstChild(tag: "Name")?.stringValue ?? ""
    stats = xml.children(tag: "Stat").flatMap { try? Stat($0) }
    players = try xml.children(tag: "Player").map { try F15PlayerModel(xml: $0, teamId: teamId) }
  }

  public struct Stat: XMLFuziModel {

    public let kind: F15Stats.TeamKind
    public let value: String
    public let ranking: Bool

    public init(_ xml: XMLElement) throws {
      let type = xml.attributes["Type"] ?? ""
      self.ranking = type.hasSuffix("ranking")
      self.kind = F15Stats.TeamKind.kind(for: type, ranking: self.ranking)
      self.value = xml.stringValue
    }
  }
}

public struct F15PlayerModel: XMLFuziModel {

  // swiftlint:disable:next identifier_name
  public let id: String
  public let name: String
  public let stats: [Stat]
  public var teamId: String

  public init(xml: XMLElement, teamId: String) throws {
    try self.init(xml)
    self.teamId = teamId
  }

  public init(_ xml: XMLElement) throws {
    id = xml.attributes["uID"] ?? ""
    name = xml.firstChild(tag: "Name")?.stringValue ?? ""
    stats = xml.children(tag: "Stat").flatMap { try? Stat($0) }
    teamId = ""
  }

  public struct Stat: XMLFuziModel {

    public let kind: F15Stats.PlayerKind
    public let value: String
    public let ranking: Bool

    public init(_ xml: XMLElement) throws {
      let type = xml.attributes["Type"] ?? ""
      self.ranking = type.hasSuffix("ranking")
      self.kind = F15Stats.PlayerKind.kind(for: type, ranking: self.ranking)
      self.value = xml.stringValue
    }
  }
}
