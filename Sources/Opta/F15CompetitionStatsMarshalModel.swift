//
//  F15CompetitionStatsMarshalModel.swift
//  Tests
//
//  Created by Sergei Mikhan on 1/23/18.
//

import protocol Sextant.JSONMarshalModel
import Marshal

public struct F15CompetitionStatsMarshalModel: JSONMarshalModel {

  public let seasonId: String
  public let seasonName: String
  public let competitionId: String
  public let competitionName: String
  public let competitionCode: String
  public let statisticsType: String

  public let teams: [F15TeamMarshalModel]

  public init(object: MarshaledObject) throws {
    guard let attributes = object.optionalAny(for: "@attributes") as? NSDictionary else {
      throw "no attributes"
    }
    seasonId = try attributes.value(for: "season_id")
    seasonName = try attributes.value(for: "season_name")
    competitionId = try attributes.value(for: "competition_id")
    competitionName = try attributes.value(for: "competition_name")
    competitionCode = try attributes.value(for: "competition_code")
    statisticsType = try attributes.value(for: "Type")
    teams = try object.value(for: "Team")
  }
}

public struct F15TeamMarshalModel: JSONMarshalModel {

  public let id: String
  public let name: String
  public let stats: [Stat]
  public var players: [F15PlayerMarshalModel]

  public init(object: MarshaledObject) throws {
    guard let attributes = object.optionalAny(for: "@attributes") as? NSDictionary else {
      throw "no attributes"
    }
    let untrimmedTeamId: String = try attributes.value(for: "uID")
    id = untrimmedTeamId.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
    name = try object.value(for: "Name")
    stats = try object.value(for: "Stat")
    players = try object.value(for: "Player")

//    players.forEach { _ in
//      $0.teamId = self.id
//    }
  }

  public struct Stat: JSONMarshalModel {

    public let kind: F15Stats.TeamKind
    public let value: String
    public let ranking: Bool

    public init(object: MarshaledObject) throws {
      guard let attributes = object.optionalAny(for: "@attributes") as? NSDictionary else {
        throw "no attributes"
      }
      let type: String = try attributes.value(for: "Type")
      self.ranking = type.hasSuffix("ranking")
      self.kind = F15Stats.TeamKind.kind(for: type, ranking: self.ranking)
      self.value = (object.optionalAny(for: "@value") as? String) ?? ""
    }
  }
}

public struct F15PlayerMarshalModel: JSONMarshalModel {

  public enum Position: String {
    case defender = "Defender"
  }

  public let id: String
  public let name: String
  public let position: Position?
  public let stats: [Stat]
  public var teamId: String?

  public init(object: MarshaledObject) throws {
    guard let attributes = object.optionalAny(for: "@attributes") as? NSDictionary else {
      throw "no attributes"
    }
    id = try attributes.value(for: "uID")
    name = try object.value(for: "Name")
    let rawPosition: String = try object.value(for: "Position")
    self.position = Position(rawValue: rawPosition)
    stats = try object.value(for: "Stat")
  }

  public struct Stat: JSONMarshalModel {

    public let kind: F15Stats.PlayerKind
    public let value: String
    public let ranking: Bool

    public init(object: MarshaledObject) throws {
      guard let attributes = object.optionalAny(for: "@attributes") as? NSDictionary else {
        throw "no attributes"
      }
      let type: String = try attributes.value(for: "Type")
      self.ranking = type.hasSuffix("ranking")
      self.kind = F15Stats.PlayerKind.kind(for: type, ranking: self.ranking)
      self.value = (object.optionalAny(for: "@value") as? String) ?? ""
    }
  }
}
