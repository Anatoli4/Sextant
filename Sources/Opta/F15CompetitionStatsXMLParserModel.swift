//
//  F15CompetitionStatsXMLParserModel.swift
//  Opta
//
//  Created by Dmitry Duleba on 4/7/16.
//  Copyright © 2016 NETCOSPORTS. All rights reserved.
//

public final class F15CompetitionStatsXMLParserModel: NSObject, XMLParserModel, XMLParserDelegate {

  public var seasonId = ""
  public var seasonName = ""
  public var competitionId = ""
  public var competitionName = ""
  public var competitionCode = ""
  public var statisticsType = ""

  public var teams: [F15TeamXMLParserModel] = []

  public required init(_ xmlParser: XMLParser) throws {
    super.init()
    let now = Date()
    xmlParser.delegate = self
    xmlParser.parse()
  }

  var currentTeam: F15TeamXMLParserModel?
  var currentPlayer: F15PlayerXMLParserModel?
  var currentTeamStat: F15TeamXMLParserModel.Stat?
  var currentPlayerStat: F15PlayerXMLParserModel.Stat?
  var value = ""

  public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
    if elementName == "Stat" {
      if let currentPlayer = currentPlayer {
        let stat = F15PlayerXMLParserModel.Stat(attributeDict)
        currentPlayerStat = stat
        currentPlayer.stats.append(stat)
      } else if let currentTeam = currentTeam {
        let stat = F15TeamXMLParserModel.Stat(attributeDict)
        currentTeamStat = stat
        currentTeam.stats.append(stat)
      }
    } else if elementName == "Player" {
      let player = F15PlayerXMLParserModel(attributeDict)
      player.teamId = currentTeam?.id ?? ""
      currentTeam?.players.append(player)
      currentPlayer = player
    } else if elementName == "Team" {
      let team = F15TeamXMLParserModel(attributeDict)
      teams.append(team)
      currentTeam = team
    } else if elementName == "SoccerDocument" {
      seasonId = attributeDict["season_id"] ?? ""
      seasonName = attributeDict["season_name"] ?? ""
      competitionId = attributeDict["competition_id"] ?? ""
      competitionName = attributeDict["competition_name"] ?? ""
      competitionCode = attributeDict["competition_code"] ?? ""
      statisticsType = attributeDict["Type"] ?? ""
    }
  }

  public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

    if elementName == "Stat" {
      if let currentPlayerStat = currentPlayerStat {
        currentPlayerStat.value = value
      } else if let currentTeamStat = currentTeamStat {
        currentTeamStat.value = value
      }
      currentTeamStat = nil
      currentPlayerStat = nil
    } else if elementName == "Player" {
      currentPlayer = nil
    } else if elementName == "Team" {
      currentTeam = nil
    } else if elementName == "Name" {
      if let currentPlayer = currentPlayer {
        currentPlayer.name = value
      } else if let currentTeam = currentTeam {
        currentTeam.name = value
      }
    }
    value = ""
  }

  public func parser(_ parser: XMLParser, foundCharacters string: String) {
    value += string.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
  }
}

public class F15TeamXMLParserModel {

  public var id = ""
  public var name = ""
  public var stats: [Stat] = []
  public var players: [F15PlayerXMLParserModel] = []

  public init(_ attributeDict: [String: String]) {
    let teamId = (attributeDict["uID"] ?? "").trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
    id = teamId
  }

  public class Stat {

    public let kind: F15Stats.TeamKind
    public var value: String = ""
    public let ranking: Bool

    public init(_ attributeDict: [String: String]) {
      let type = attributeDict["Type"] ?? ""
      self.ranking = type.hasSuffix("ranking")
      self.kind = F15Stats.TeamKind.kind(for: type, ranking: self.ranking)
    }
  }
}

public class F15PlayerXMLParserModel {

  public enum Position: String {
    case defender = "Defender"
  }

  public var id = ""
  public var name = ""
  public var position: Position?
  public var stats: [Stat] = []
  public var teamId = ""

  public init(_ attributeDict: [String: String]) {
    id = (attributeDict["uID"] ?? "").trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
  }

  public class Stat {

    public let kind: F15Stats.PlayerKind
    public var value: String = ""
    public let ranking: Bool

    public init(_ attributeDict: [String: String]) {
      let type = attributeDict["Type"] ?? ""
      self.ranking = type.hasSuffix("ranking")
      self.kind = F15Stats.PlayerKind.kind(for: type, ranking: self.ranking)
    }
  }
}
