//
//  Created by Sergei Mikhan on 01/31/18.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Gnomon

public class OptaAPIManager {

  // swiftlint:disable variable_name
  public struct Competition {
    let id: String
    let season: String

    public init(id: String, season: String) {
      self.id = id
      self.season = season
    }
  }

  public static var settings = Settings()

  fileprivate static func buider<ResultType: Result>(for feedType: FeedType) -> RequestBuilder<ResultType> {
    let feedParams = params(forFeedType: feedType)
    return RequestBuilder()
      .setURLString(URLStringForFeedType(type: feedType))
      .setParams(feedParams)
  }
}

// MARK: - F1
// swiftlint:disable variable_name
extension OptaAPIManager {
  public typealias F1Result = SingleOptionalResult<F1Model>
  public typealias F1Request = Request<F1Result>

  public static func f1Request(competition: OptaAPIManager.Competition) throws -> F1Request {
    return try buider(for: .f1(competition: competition))
      .setXPath("SoccerFeed/SoccerDocument")
      .build()
  }

  public static  func f1Requests(competitions: [OptaAPIManager.Competition]) throws -> [F1Request] {
      let requests = try competitions.map {
        return try f1Request(competition: $0)
      }
      return requests
  }
}

// MARK: - F15
extension OptaAPIManager {
  public typealias F15Result = SingleOptionalResult<F15Model>
  public typealias F15Request = Request<F15Result>

  public static func f15Request(for competitionId: String, season: String) throws -> F15Request {
    return try buider(for: .f15(competition: Competition(id: competitionId, season: season)))
      .setXPath("SoccerFeed/SoccerDocument")
      .build()
  }
}

extension OptaAPIManager {

  enum FeedType {
    case f1(competition: Competition)
    case standings(competition: Competition)
    case liveScores(competition: Competition)
    case liveMatch(id: String)
    case matchCommentary(id: String)
    case matchStatistics(id: String)
    case teamStatistics(competition: Competition, teamId: String)
    case f15(competition: Competition)
    case detailedPrematchStatistics(matchId: String)
    case liveMatchStatistics(id: String)

    var key: String {
      switch self {
      case .f1:
        return "F1"
      case .standings:
        return "F3"
      case .liveScores:
        return "F26"
      case .liveMatch:
        return "F9"
      case .matchCommentary:
        return "F13"
      case .matchStatistics:
        return "F9"
      case .teamStatistics:
        return "F30"
      case .f15:
        return "F15"
      case .detailedPrematchStatistics:
        return "F2"
      case .liveMatchStatistics:
        return "F24"
      }
    }

    var URLPath: String {
      switch self {
      case .f1, .standings, .liveScores, .f15:
        return "competition.php"
      case .teamStatistics:
        return "team_competition.php"
      case .liveMatch, .matchCommentary, .detailedPrematchStatistics, .matchStatistics, .liveMatchStatistics:
        return ""
      }
    }
  }

  static func URLStringForFeedType(type: FeedType) -> String {
    guard let url = URL(string: settings.baseUrl) else {
      assertionFailure("invalid opta base URL")
      return ""
    }
    return url.appendingPathComponent(type.URLPath).absoluteString
  }

  static func params(forFeedType: FeedType) -> [String: String] {
    var allParams: [String: String] = [
      "feed_type": forFeedType.key,
      "user": settings.username,
      "psw": settings.password
    ]

    switch forFeedType {
    case .f1(let competiton):
      allParams += params(with: competiton)
    case .standings(let competiton):
      allParams += params(with: competiton)
    case .liveScores(let competiton):
      allParams += params(with: competiton)
    case .liveMatch(let id):
      allParams += params(withMatchId: id)
    case .matchCommentary(let id):
      allParams += params(withMatchId: id)
      allParams += params(withLanguage: "en")
    case .matchStatistics(let id):
      allParams += params(withMatchId: id)
    case .teamStatistics(let competiton, let team):
      allParams += params(with: competiton)
      allParams += params(withTeamId: team)
    case .f15(let competiton):
      allParams += params(with: competiton)
    case .detailedPrematchStatistics(let match):
      allParams += params(withMatchId: match)
    case .liveMatchStatistics(let id):
      allParams += params(withMatchId: id)
    }

    return allParams
  }
}

extension OptaAPIManager {

  fileprivate static func params(with competition: Competition) -> [String: String] {
    return [
      "competition": competition.id,
      "season_id": competition.season
    ]
  }

  fileprivate static func params(withMatchId: String) -> [String: String] {
    return ["game_id": withMatchId]
  }

  fileprivate static func params(withTeamId: String) -> [String: String] {
    return ["team_id": withTeamId]
  }

  fileprivate static func params(withLanguage: String) -> [String: String] {
    return ["language": withLanguage]
  }
}
