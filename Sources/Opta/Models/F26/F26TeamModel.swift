//
//  Created by Eugen Filipkov on 2/21/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

// swiftlint:disable variable_name
public struct F26TeamModel: XMLFuziModel {
  public let id: String
  public let name: String
  // 3 letter team name abbreviation
  public let code: String
  public let score: Int
  public private(set) var penaltyScore: Int?
  public let substitutions: [F26SubstitutionModel]?
  public let goals: [F26GoalModel]?
  public private(set) var cards: [F26CardModel]?

  public init(_ xml: XMLElement) throws {
    id = xml.firstChild(staticTag: "team-id")?.stringValue ?? ""
    name = xml.firstChild(staticTag: "team-name")?.stringValue ?? ""
    code = xml.firstChild(staticTag: "team-code")?.stringValue ?? ""
    score = Int(xml.firstChild(staticTag: "score")?.stringValue ?? "0") ?? 0
    if let penalty = xml.firstChild(staticTag: "pen_score")?.stringValue {
      penaltyScore = Int(penalty)
    }
    substitutions = try xml.firstChild(staticTag: "substitutions")?
      .children(staticTag: "substitution").flatMap { try F26SubstitutionModel($0) }
    goals = try xml.firstChild(staticTag: "scorers")?
      .children(staticTag: "scorer").flatMap { try F26GoalModel($0) }
    let yellowCards = try xml.firstChild(staticTag: "bookings")?
      .children(staticTag: "yellow-card").flatMap { try F26CardModel($0, name: .yellow) }
    let redCards = try xml.firstChild(staticTag: "bookings")?
      .children(staticTag: "red-card").flatMap { try F26CardModel($0, name: .red) }
    if let yellowCards = yellowCards,
      let redCards = redCards,
      yellowCards.count > 0 || redCards.count > 0 {
      cards = yellowCards + redCards
    }
  }
}

public struct F26PlayerModel: XMLFuziModel {
  public let id: String
  public let firstName: String
  public let lastName: String

  public init(_ xml: XMLElement) throws {
    id = xml.firstChild(staticTag: "player-firstname")?.stringValue ?? ""
    firstName = xml.firstChild(staticTag: "player-code")?.stringValue ?? ""
    lastName = xml.firstChild(staticTag: "player-name")?.stringValue ?? ""
  }

  public init(id: String,
              firstName: String,
              lastName: String) {
    self.id = id
    self.firstName = firstName
    self.lastName = lastName
  }
}

public struct F26SubstitutionModel: XMLFuziModel {
  public let eventId: String
  public let period: MatchPeriod
  public let time: Int
  public let minute: Int
  public let seconds: Int
  public let reason: SubstitutionReason
  public private(set) var timeStamp: Date?
  public let onPlayer: F26PlayerModel
  public let offPlayer: F26PlayerModel

  public init(_ xml: XMLElement) throws {
    guard let subOff = xml.firstChild(staticTag: "sub-off") else { throw "F26 miss sub-off root" }
    guard let subOn = xml.firstChild(staticTag: "sub-on") else { throw "F26 miss sub-on root" }
    let attributes = xml.attributes
    eventId = attributes["event_id"] ?? ""
    period = MatchPeriod(periodString: attributes["period"] ?? "")
    time = Int(attributes["time"] ?? "0") ?? 0
    minute = Int(attributes["min"] ?? "0") ?? 0
    seconds = Int(attributes["sec"] ?? "0") ?? 0
    reason = SubstitutionReason(rawValue: attributes["reason"]?.lowercased() ?? "") ?? .undefined
    let dateString = attributes["sub-timestamp"] ?? ""
    let formatter = DateUtils.dateFormaterWith("yyyy-MM-dd HH:mm:ss")
    if let date = formatter.date(from: dateString) {
      timeStamp = date
    }
    onPlayer = try F26PlayerModel(subOn)
    offPlayer = try F26PlayerModel(subOff)
  }
}

public struct F26GoalModel: XMLFuziModel {
  public let eventId: String
  public let period: MatchPeriod
  public let time: Int
  public let minute: Int
  public let seconds: Int
  public let kind: GoalType
  public private(set) var timeStamp: Date?
  public let player: F26PlayerModel

  public init(_ xml: XMLElement) throws {
    let attributes = xml.attributes
    eventId = attributes["event_id"] ?? ""
    period = MatchPeriod(periodString: attributes["period"] ?? "")
    time = Int(attributes["time"] ?? "0") ?? 0
    minute = Int(attributes["min"] ?? "0") ?? 0
    seconds = Int(attributes["sec"] ?? "0") ?? 0
    kind = GoalType(goalString: attributes["goal-type"] ?? "")
    let dateString = attributes["goal-timestamp"] ?? ""
    let formatter = DateUtils.dateFormaterWith("yyyy-MM-dd HH:mm:ss")
    if let date = formatter.date(from: dateString) {
      timeStamp = date
    }
    player = try F26PlayerModel(xml)
  }
}

public struct F26CardModel {
  public let name: CardType
  public private(set) var type: CardType?
  public let eventId: String
  public let period: MatchPeriod
  public let time: Int
  public let minute: Int
  public let seconds: Int
  public private(set) var timeStamp: Date?
  public let player: F26PlayerModel

  public init(_ xml: XMLElement, name: CardType) throws {
    let attributes = xml.attributes
    self.name = name
    if let type = attributes["type"] {
      self.type = CardType(cardString: type)
    }
    eventId = attributes["event_id"] ?? ""
    period = MatchPeriod(periodString: attributes["period"] ?? "")
    time = Int(attributes["time"] ?? "0") ?? 0
    minute = Int(attributes["min"] ?? "0") ?? 0
    seconds = Int(attributes["sec"] ?? "0") ?? 0
    let dateString = attributes["timestamp"] ?? ""
    let formatter = DateUtils.dateFormaterWith("yyyy-MM-dd HH:mm:ss")
    if let date = formatter.date(from: dateString) {
      timeStamp = date
    }
    if name == .yellow {
      player = F26PlayerModel(id: attributes["id"] ?? "",
                              firstName: attributes["first"] ?? "",
                              lastName: attributes["last"] ?? "")
    } else {
      player = try F26PlayerModel(xml)
    }
  }
}
