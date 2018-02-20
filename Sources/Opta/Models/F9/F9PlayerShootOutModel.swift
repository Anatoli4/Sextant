//
//  Created by Eugen Filipkov on 2/15/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

// swiftlint:disable variable_name
public struct F9PlayerShootOutModel: XMLFuziModel {
  public enum Outcome: String {
    case undefined
    case scored
    case missed
    case saved
  }

  public let id: String
  public let playerId: String
  public let outcome: Outcome
  private(set) var timeStamp: Date?
  /*
   Unique within the game. The first digit indicates the half/period.
   The middle digits indicate the event minute. the last indicates the event number
   (from cards, goals and subs) which are processed in blocks indepedently of chronological order;
   cards first, then goals, then substitutes
   */
  public let eventNumber: Int
  public let eventId: String

  public init(_ xml: XMLElement) throws {
    let attributes = xml.attributes
    id = attributes["uID"] ?? ""
    playerId = String(attributes["PlayerRef"]?.dropFirst() ?? "")
    outcome = Outcome(rawValue: attributes["Outcome"]?.lowercased() ?? "") ?? .undefined
    if let timestamp = attributes["TimeStamp"] {
      timeStamp = DateUtils.dateFormaterWith().date(from: timestamp)
    }
    eventNumber = Int(attributes["EventNumber"] ?? "0") ?? 0
    eventId = attributes["EventID"] ?? ""
  }
}
