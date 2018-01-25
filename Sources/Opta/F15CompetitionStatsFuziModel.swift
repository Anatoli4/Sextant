//
//  F15CompetitionStatsFuziModel.swift
//  Opta
//
//  Created by Dmitry Duleba on 4/7/16.
//  Copyright © 2016 NETCOSPORTS. All rights reserved.
//

import protocol Sextant.XMLFuziModel
import Fuzi

public struct F15CompetitionStatsFuziModel: XMLFuziModel {

  public let seasonId: String
  public let seasonName: String
  public let competitionId: String
  public let competitionName: String
  public let competitionCode: String
  public let statisticsType: String

  public let teams: [F15TeamFuziModel]

  public init(_ xml: XMLElement) throws {
    let attributes = xml.attributes

    seasonId = attributes["season_id"] ?? ""
    seasonName = attributes["season_name"] ?? ""
    competitionId = attributes["competition_id"] ?? ""
    competitionName = attributes["competition_name"] ?? ""
    competitionCode = attributes["competition_code"] ?? ""
    statisticsType = attributes["Type"] ?? ""

    teams = try xml.children(tag: "Team").map { try F15TeamFuziModel($0) }
  }
}

public struct F15TeamFuziModel: XMLFuziModel {

  public let id: String
  public let name: String
  public let stats: [Stat]

  public var players: [F15PlayerFuziModel]

  public init(_ xml: XMLElement) throws {
    guard let teamId = xml.attributes["uID"]?.trimmingCharacters(in: CharacterSet.decimalDigits.inverted) else { throw "no team" }
    id = teamId
    name = ""//xml["Name"].string ?? ""
    stats = xml.children(tag: "Stat").flatMap { try? Stat($0) }
    players = try xml.children(tag: "Player").map { try F15PlayerFuziModel(xml: $0, teamId: teamId) }
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

public struct F15PlayerFuziModel: XMLFuziModel {

  public enum Position: String {
    case defender = "Defender"
  }

  public let id: String
  public let name: String
  public let position: Position?
  public let stats: [Stat]
  public var teamId: String?

  public init(xml: XMLElement, teamId: String) throws {
    try self.init(xml)
    self.teamId = teamId
  }

  public init(_ xml: XMLElement) throws {
    id = xml.attributes["uID"] ?? ""
    name = ""//xml["Name"].string
    self.position = Position(rawValue: /*xml["Position"].string*/"")
    stats = xml.children(tag: "Stat").flatMap { try? Stat($0) }
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
