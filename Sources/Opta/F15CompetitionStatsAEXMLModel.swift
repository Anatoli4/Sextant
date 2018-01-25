//
//  F15CompetitionStatsAEXMLModel.swift
//  Opta
//
//  Created by Dmitry Duleba on 4/7/16.
//  Copyright © 2016 NETCOSPORTS. All rights reserved.
//

import protocol Gnomon.XMLModel
import AEXML

public struct F15CompetitionStatsAEXMLModel: XMLModel {

  public let seasonId: String
  public let seasonName: String
  public let competitionId: String
  public let competitionName: String
  public let competitionCode: String
  public let statisticsType: String

  public let teams: [F15TeamAEXMLModel]

  public init(_ xml: AEXMLElement) throws {
    let attributes = xml.attributes

    seasonId = attributes["season_id"] ?? ""
    seasonName = attributes["season_name"] ?? ""
    competitionId = attributes["competition_id"] ?? ""
    competitionName = attributes["competition_name"] ?? ""
    competitionCode = attributes["competition_code"] ?? ""
    statisticsType = attributes["Type"] ?? ""

    teams = try xml.children.filter({ $0.name == "Team" }).map { try F15TeamAEXMLModel($0) }
  }
}

public struct F15TeamAEXMLModel: XMLModel {

  public let id: String
  public let name: String
  public let stats: [Stat]

  public var players: [F15PlayerAEXMLModel]

  public init(_ xml: AEXMLElement) throws {
    let teamId = (xml.attributes["uID"] ?? "").trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
    id = teamId
    name = xml["Name"].string
    stats = xml.children.filter({ $0.name == "Stat" }).flatMap { try? Stat($0) }
    players = try xml.children.filter({ $0.name == "Player" }).map { try F15PlayerAEXMLModel(xml: $0, teamId: teamId) }
  }

  public struct Stat: XMLModel {

    public let kind: F15Stats.TeamKind
    public let value: String
    public let ranking: Bool

    public init(_ xml: AEXMLElement) throws {
      let type = xml.attributes["Type"] ?? ""
      self.ranking = type.hasSuffix("ranking")
      self.kind = F15Stats.TeamKind.kind(for: type, ranking: self.ranking)
      self.value = xml.value ?? ""
    }
  }
}

public struct F15PlayerAEXMLModel: XMLModel {

  public enum Position: String {
    case defender = "Defender"
  }

  public let id: String
  public let name: String
  public let position: Position?
  public let stats: [Stat]
  public var teamId: String?

  public init(xml: AEXMLElement, teamId: String) throws {
    try self.init(xml)
    self.teamId = teamId
  }

  public init(_ xml: AEXMLElement) throws {
    id = xml.attributes["uID"] ?? ""
    name = xml["Name"].string
    self.position = Position(rawValue: xml["Position"].value ?? "")
    stats = xml.children.filter({ $0.name == "Stat" }).flatMap { try? Stat($0) }
  }

  public struct Stat: XMLModel {

    public let kind: F15Stats.PlayerKind
    public let value: String
    public let ranking: Bool

    public init(_ xml: AEXMLElement) throws {
      let type = xml.attributes["Type"] ?? ""
      self.ranking = type.hasSuffix("ranking")
      self.kind = F15Stats.PlayerKind.kind(for: type, ranking: self.ranking)
      self.value = xml.value ?? ""
    }
  }
}
