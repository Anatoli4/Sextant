//
//  Created by Eugen Filipkov on 2/15/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

// swiftlint:disable variable_name
public struct F9PlayerSubstitutionModel: XMLFuziModel {
  public let id: String
  public let onPlayerId: String
  public let offPlayerId: String
  public let minute: Int
  public let reason: SubstitutionReason
  public let period: MatchPeriod
  public let position: PlayerPosition
  private(set) var timeStamp: Date?
  /*
   Unique within the game. The first digit indicates the half/period.
   The middle digits indicate the event minute. the last indicates the event number
   (from cards, goals and subs) which are processed in blocks indepedently of chronological order;
   cards first, then goals, then substitutes
   */
  public let eventNumber: Int
  public let eventId: String
  public let isRetired: Bool?

  public init(_ xml: XMLElement) throws {
    let attributes = xml.attributes
    id = String(attributes["uID"]?.dropFirst() ?? "")
    onPlayerId = String(attributes["SubOn"]?.dropFirst() ?? "")
    offPlayerId = String(attributes["SubOff"]?.dropFirst() ?? "")
    minute = Int(attributes["Time"] ?? "0") ?? 0
    reason = SubstitutionReason(rawValue: attributes["Reason"]?.lowercased() ?? "") ?? .undefined
    period = MatchPeriod(periodString: attributes["Period"]?.lowercased() ?? "")
    position = PlayerPosition(positionString: attributes["SubstitutePosition"]?.lowercased() ?? "")
    if let timestamp = attributes["TimeStamp"] {
      timeStamp = DateUtils.dateFormaterWith().date(from: timestamp)
    }
    eventNumber = Int(attributes["EventNumber"] ?? "0") ?? 0
    eventId = attributes["EventID"] ?? ""
    isRetired = attributes["Retired"] == "1" ? true : false
  }
}
