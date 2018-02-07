//
//  Created by Eugen Filipkov on 2/2/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

public enum GoalType: String {
  case goal
  case own
  case penalty
}

public enum MatchPeriodStatus: String {
  case undefined
  case firstHalf = "firsthalf"
  case secondHalf = "secondhalf"
  case extraFirstHalf = "extrafirsthalf"
  case extraSecondHalf = "extrasecondhalf"
  case extraHalfTime = "extrahalftime"
  case shootOut = "shootout"
}

public enum MatchStatus {
  case undefined
  case preMatch
  case fullTime
  case postponed
  case abandoned
  case halfTime
  case live

  private static func statusForString(statusString: String) -> MatchStatus {
    let statusString = statusString.lowercased()
    if let value = mapping.filter({ $0.value.contains(statusString) }).first {
      return value.key
    }
    return .undefined
  }

  private static let mapping: [MatchStatus: [String]] = [
    .preMatch: ["prematch", "pre-match", "fixture"],
    .fullTime: ["fulltime", "full", "played", "ft", "full time", "postmatch", "result"],
    .postponed: ["postponed"],
    .abandoned: ["abandoned", "cancelled"],
    .halfTime: ["half-time", "half time", "halftime", "extrahalftime"],
    .live: ["live", "playing", "firsthalf", "secondhalf", "extrafirsthalf", "extrasecondhalf", "shootout"]
  ]

  public init(statusString: String) {
    self = MatchStatus.statusForString(statusString: statusString)
  }

  public func isLive() -> Bool {
    return self == .live || self == .halfTime
  }

  public func isWithScore() -> Bool {
    return isLive() || self == .fullTime
  }
}

public enum RoundType: String {
  case undefined
  case qualifier = "qualifier round"
  case round = "round"
  case playOffs = "play-offs"
  case roundOf16 = "round of 16"
  case roundOf32 = "round of 32"
  case quarterFinals = "quarter-finals"
  case semiFinals = "semi-finals"
  case thirdAndFourthPlace = "3rd and 4th place"
  case final = "final"
}

public enum TeamSide: String {
  case undefined
  case home
  case away
}
