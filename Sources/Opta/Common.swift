//
//  Created by Eugen Filipkov on 2/2/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

public enum GoalType {
  case undefined
  case goal
  case own
  case penalty

  private static let mapping: [GoalType: [String]] = [
    .goal: ["goal"],
    .own: ["own", "owng"],
    .penalty: ["penalty", "peng"]
  ]
  private static func goalForString(goalString: String) -> GoalType {
    let goalString = goalString.lowercased()
    if let value = mapping.filter({ $0.value.contains(goalString) }).first {
      return value.key
    }
    return .undefined
  }

  public init(goalString: String) {
    self = GoalType.goalForString(goalString: goalString)
  }
}

public enum MatchPeriod {
  case undefined
  case preMatch
  case firstHalf
  case halftime
  case secondHalf
  case extraTime
  case extraFirstHalf
  case extraSecondHalf
  case extraHalfTime
  case shootOut
  case fullTime
  case fullTime90
  case fullTimePens
  case postMatch
  case abandoned

  private static let mapping: [MatchPeriod: [String]] = [
    .preMatch: ["prematch"],
    .firstHalf: ["firsthalf", "first half", "1"],
    .halftime: ["halftime", "half time"],
    .secondHalf: ["secondhalf", "second half", "2"],
    .extraTime: ["extra time"],
    .extraFirstHalf: ["extrafirsthalf", "extra first half", "3"],
    .extraSecondHalf: ["extrasecondhalf", "extra second half", "4"],
    .extraHalfTime: ["extrahalftime", "extra half time"],
    .shootOut: ["shootout", "penalty shootout"],
    .fullTime: ["fulltime", "full time"],
    .fullTime90: ["fulltime90"],
    .fullTimePens: ["fulltimepens"],
    .postMatch: ["postmatch"],
    .abandoned: ["abandoned"]
    ]
  private static func periodForString(periodString: String) -> MatchPeriod {
    let periodString = periodString.lowercased()
    if let value = mapping.filter({ $0.value.contains(periodString) }).first {
      return value.key
    }
    return .undefined
  }

  public init(periodString: String) {
    self = MatchPeriod.periodForString(periodString: periodString)
  }
}

public enum MatchType: String {
  case undefined = ""
  case regular = "regular"
  case cup = "cup"
  case cupGold = "cup gold"
  case replay = "replay"
  case cupEnglish = "cup english"
  case cupShort = "cup short"
  case firstLeg = "1st leg"
  case secondLeg = "2nd leg"
  case secondLegAwayGoal = "2nd leg away goal"
  case secondLegCupShort = "2nd leg cup short"
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

public enum SubstitutionReason: String {
  case undefined
  case injury
  case tactical
}

public enum CardType {
  case undefined
  case yellow
  case secondYellow
  case red

  private static let mapping: [CardType: [String]] = [
    .yellow: ["yellow"],
    .secondYellow: ["secondyellow", "second yellow"],
    .red: ["straightred", "straight red", "red"]
  ]
  private static func cardForString(cardString: String) -> CardType {
    let cardString = cardString.lowercased()
    if let value = mapping.filter({ $0.value.contains(cardString) }).first {
      return value.key
    }
    return .undefined
  }

  public init(cardString: String) {
    self = CardType.cardForString(cardString: cardString)
  }
}

public enum PlayerPosition {
  case undefined
  case goalkeeper
  case defender
  case midfielder
  case striker
  case substitute

  private static let mapping: [PlayerPosition: [String]] = [
    .goalkeeper: ["goalkeeper", "1"],
    .defender: ["defender", "2"],
    .midfielder: ["midfielder", "3"],
    .striker: ["striker", "4"],
    .substitute: ["substitute"]
  ]
  private static func positionForString(positionString: String) -> PlayerPosition {
    let positionString = positionString.lowercased()
    if let value = mapping.filter({ $0.value.contains(positionString) }).first {
      return value.key
    }
    return .undefined
  }

  public init(positionString: String) {
    self = PlayerPosition.positionForString(positionString: positionString)
  }
}
