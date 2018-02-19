//
//  Created by Eugen Filipkov on 2/12/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

public struct F9MatchResultModel: XMLFuziModel {
  public enum Kind: String {
    case undefined
    case normalResult = "normalresult"
    case aggregate = "aggregate"
    case awayGoals = "awaygoals"
    case penaltyShootout = "penalty shootout"
    case afterExtraTime = "afterextratime"
    case goldenGoal = "goldengoal"
    case abandoned = "abandoned"
    case postponed = "postponed"
    case void = "void"
    case delayed = "delayed"
  }
  public enum DelayReason: String {
    case crowd = "crowd"
    case floodlightFailure = "floodlight failure"
    case frozenPitch = "frozen pitch"
    case insufficientPlayers = "insufficient players"
    case other = "other"
    case suspended = "suspended"
    case unknown = "unknown"
    case waterloggedPitch = "waterlogged pitch"
    case weather = "weather"
  }
  private(set) var winnerId: String?
  private(set) var kind: Kind?
  private(set) var delayMinutes: Int?
  private(set) var delayReason: DelayReason?

  public init(_ xml: XMLElement) throws {
    let attributes = xml.attributes
    if let winner = attributes["Winner"] {
      winnerId = String(winner.dropFirst())
    }
    if let type = attributes["Type"] {
    kind = Kind(rawValue: type.lowercased())
    }
    if let minutes = attributes["Minutes"] {
      delayMinutes = Int(minutes)
    }
    if let reason = attributes["Reason"] {
      delayReason = DelayReason(rawValue: reason.lowercased())
    }
  }
}
