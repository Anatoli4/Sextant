//
//  Created by Eugen Filipkov on 2/14/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

// swiftlint:disable variable_name
public struct F9OfficialModel: XMLFuziModel {
  public enum Kind: String {
    case undefined
    case manager = "manager"
    case matchdayManager = "matchday manager"
  }
  public let id: String
  public let kind: Kind
  public let firstName: String
  public let lastName: String

  public init(_ xml: XMLElement) throws {
    let attributes = xml.attributes
    id = attributes["uID"]?.replacingOccurrences(of: "man", with: "") ?? ""
    kind = Kind(rawValue: attributes["Type"]?.lowercased() ?? "") ?? .undefined
    firstName = xml.firstChild(staticTag: "First")?.stringValue ?? ""
    lastName = xml.firstChild(staticTag: "Last")?.stringValue ?? ""
  }
}

// swiftlint:disable variable_name
public struct F9PlayerModel {
  public struct Stat: XMLFuziModel {
    public let kind: F9TeamStatModel.Kind
    public let value: Int

    public init(_ xml: XMLElement) throws {
      kind = F9TeamStatModel.Kind(rawValue: xml.attr("Type") ?? "") ?? .undefined
      value = Int(xml.stringValue) ?? 0
    }
  }
  public enum Status: String {
    case undefined
    case start = "start"
    case substitution = "sub"
  }

  public let id: String
  public let teamId: String
  public let firstName: String
  public let lastName: String
  public let nickname: String?
  public var status: Status
  public let position: PlayerPosition
  public let subPosition: PlayerPosition
  public let shirtNumber: String
  private(set) var formationPosition: Int = 0
  public let stats: [Stat]?
  private(set) var goals: [F9PlayerGoalModel]?
  private(set) var cards: [F9PlayerCardModel]?
  private(set) var substitutions: [F9PlayerSubstitutionModel]?
  private(set) var shootOuts: [F9PlayerShootOutModel]?

  public init(_ xml: XMLElement,
              team: XMLElement?,
              allGoals: [F9PlayerGoalModel]?,
              allCards: [F9PlayerCardModel]?,
              allSubstitutions: [F9PlayerSubstitutionModel]?,
              allShootOuts: [F9PlayerShootOutModel]?) throws {
    let players = team?.children(staticTag: "Player")
    let attributes = xml.attributes
    guard let playerRef = attributes["PlayerRef"] else { throw "F9 miss player id" }
    id = String(playerRef.dropFirst())
    teamId = String(team?.attr("uID")?.dropFirst() ?? "")
    let info = players?.first(where: { $0.attr("uID") == playerRef })
    let personName = info?.firstChild(staticTag: "PersonName")
    firstName = personName?.firstChild(staticTag: "First")?.stringValue ?? ""
    lastName = personName?.firstChild(staticTag: "Last")?.stringValue ?? ""
    nickname = personName?.firstChild(staticTag: "Known")?.stringValue
    status = Status(rawValue: attributes["Status"]?.lowercased() ?? "") ?? .undefined
    position = PlayerPosition(positionString: attributes["Position"] ?? "")
    subPosition = PlayerPosition(positionString: attributes["SubPosition"] ?? "")
    shirtNumber = attributes["ShirtNumber"] ?? ""
    let allStats = xml.children(staticTag: "Stat")
    if let position = allStats.first(where: { $0.attr("Type") == "formation_place" })?.stringValue {
      formationPosition = Int(position) ?? 0
    }
    stats = try allStats.filter { $0.attr("Type") != "formation_place" }.flatMap { try Stat($0) }
    goals = allGoals?.filter { $0.playerId == id }
    cards = allCards?.filter { $0.playerId == id }
    substitutions = allSubstitutions?.filter { $0.onPlayerId == id || $0.offPlayerId == id }
    shootOuts = allShootOuts?.filter { $0.playerId == id }
  }
}
