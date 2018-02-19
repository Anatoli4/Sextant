//
//  Created by Eugen Filipkov on 2/15/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

// swiftlint:disable variable_name
public struct F9PlayerGoalModel: XMLFuziModel {
  public enum Kind: String {
    case undefined
    case goal
    case own
    case penalty
  }
  public let id: String
  public let playerId: String
  public let minute: Int
  public let kind: Kind
  public let period: MatchPeriod
  private(set) var timeStamp: Date?
  private(set) var assistPlayerId: String?
  private(set) var secondAssistPlayerId: String?
  /*
   Unique within the game. The first digit indicates the half/period.
   The middle digits indicate the event minute. the last indicates the event number
   (from cards, goals and subs) which are processed in blocks indepedently of chronological order;
   cards first, then goals, then substitutes
   */
  public let eventNumber: Int
  public let eventId: String
  public let isSoloRun: Bool?

  public init(_ xml: XMLElement) throws {
    let attributes = xml.attributes
    id = String(attributes["uID"]?.dropFirst() ?? "")
    playerId = String(attributes["PlayerRef"]?.dropFirst() ?? "")
    minute = Int(attributes["Time"] ?? "0") ?? 0
    kind = Kind(rawValue: attributes["Type"]?.lowercased() ?? "") ?? .undefined
    period = MatchPeriod(periodString: attributes["Period"]?.lowercased() ?? "")
    if let timestamp = attributes["TimeStamp"] {
      timeStamp = DateUtils.dateFormaterWith().date(from: timestamp)
    }
    if let id = xml.firstChild(staticTag: "Assist")?.stringValue {
      assistPlayerId = String(id.dropFirst())
    }
    if let id = xml.firstChild(staticTag: "2ndAssist")?.stringValue {
      secondAssistPlayerId = String(id.dropFirst())
    }
    eventNumber = Int(attributes["EventNumber"] ?? "0") ?? 0
    eventId = attributes["EventID"] ?? ""
    isSoloRun = attributes["SoloRun"] == "1" ? true : false
  }
}
