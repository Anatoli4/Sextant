//
//  F15CompetitionStatsSwiftyJSONModel.swift
//  Opta
//
//  Created by Dmitry Duleba on 4/7/16.
//  Copyright © 2016 NETCOSPORTS. All rights reserved.
//

import Gnomon
import SwiftyJSON

public struct F15CompetitionStatsSwiftyJSONModel: JSONModel {

  public let seasonId: String
  public let seasonName: String
  public let competitionId: String
  public let competitionName: String
  public let competitionCode: String
  public let statisticsType: String

  public let teams: [F15TeamSwiftyJSONModel]

  public init(_ json: JSON) {
    let attributes = json["@attributes"]

    seasonId = attributes["season_id"].stringValue
    seasonName = attributes["season_name"].stringValue
    competitionId = attributes["competition_id"].stringValue
    competitionName = attributes["competition_name"].stringValue
    competitionCode = attributes["competition_code"].stringValue
    statisticsType = attributes["Type"].stringValue

    teams = json["Team"].arrayValue.map { F15TeamSwiftyJSONModel($0) }
  }
}

public struct F15TeamSwiftyJSONModel: JSONModel {

  public let id: String
  public let name: String
  public let stats: [Stat]

  public var players: [F15PlayerSwiftyJSONModel]

  public init(_ json: JSON) {
    let teamId = json["@attributes"]["uID"].stringValue.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
    id = teamId
    name = json["Name"].stringValue
    stats = json["Stat"].arrayValue.flatMap { try? Stat($0) }
    players = json["Player"].arrayValue.map { F15PlayerSwiftyJSONModel(json: $0, teamId: teamId) }
  }

  public struct Stat: JSONModel {

    public let kind: F15Stats.TeamKind
    public let value: String
    public let ranking: Bool

    public init(_ json: JSON) throws {
      let type = json["@attributes"]["Type"].stringValue
      self.ranking = type.hasSuffix("ranking")
      self.kind = F15Stats.TeamKind.kind(for: type, ranking: self.ranking)
      self.value = json["@value"].stringValue
    }
  }
}

public struct F15PlayerSwiftyJSONModel: JSONModel {

  public enum Position: String {
    case defender = "Defender"
  }

  public let id: String
  public let name: String
  public let position: Position?
  public let stats: [Stat]
  public var teamId: String?

  public init(json: JSON, teamId: String) {
    self.init(json)
    self.teamId = teamId
  }

  public init(_ json: JSON) {
    id = json["@attributes"]["uID"].stringValue
    name = json["Name"].stringValue
    self.position = Position(rawValue: json["Position"].stringValue)
    stats = json["Stat"].arrayValue.flatMap { try? Stat($0) }
  }

  public struct Stat: JSONModel {

    public let kind: F15Stats.PlayerKind
    public let value: String
    public let ranking: Bool

    public init(_ json: JSON) throws {
      let type = json["@attributes"]["Type"].stringValue
      self.ranking = type.hasSuffix("ranking")
      self.kind = F15Stats.PlayerKind.kind(for: type, ranking: self.ranking)
      self.value = json["@value"].stringValue
    }
  }
}
