//
//  Created by Sergei Mikhan on 01/31/18.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Gnomon

public class OptaAPIManager {

  public static var settings = Settings()

  public typealias F15Result = SingleOptionalResult<F15Model>
  public typealias F15Request = Request<F15Result>

  public static func f15Request(for competitionId: String, season: String) throws -> F15Request {
    return try buider(for: .f15(competitionId: competitionId, seasonId: season))
      .setXPath("SoccerFeed/SoccerDocument")
      .build()
  }

  fileprivate static func buider<ResultType: Result>(for feedType: FeedType) -> RequestBuilder<ResultType> {
    let feedParams = params(forFeedType: feedType)
    return RequestBuilder()
      .setURLString(URLStringForFeedType(type: feedType))
      .setParams(feedParams)
  }
}

extension OptaAPIManager {

  enum FeedType {
    case fixturesAndResults(competitionId: String, seasonId: String)
    case standings(competitionId: String, seasonId: String)
    case liveScores(competitionId: String, seasonId: String)
    case liveMatch(id: String)
    case matchCommentary(id: String)
    case matchStatistics(id: String)
    case teamStatistics(competitionId: String, seasonId: String, teamId: String)
    case f15(competitionId: String, seasonId: String)
    case detailedPrematchStatistics(matchId: String)
    case liveMatchStatistics(id: String)

    var key: String {
      switch self {
      case .fixturesAndResults:
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
      case .fixturesAndResults, .standings, .liveScores, .f15:
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
    case .fixturesAndResults(let id, let season):
      allParams += params(with: id, seasonId: season)
    case .standings(let id, let season):
      allParams += params(with: id, seasonId: season)
    case .liveScores(let id, let season):
      allParams += params(with: id, seasonId: season)
    case .liveMatch(let id):
      allParams += params(withMatchId: id)
    case .matchCommentary(let id):
      allParams += params(withMatchId: id)
      allParams += params(withLanguage: "en")
    case .matchStatistics(let id):
      allParams += params(withMatchId: id)
    case .teamStatistics(let id, let season, let team):
      allParams += params(with: id, seasonId: season)
      allParams += params(withTeamId: team)
    case .f15(let id, let season):
      allParams += params(with: id, seasonId: season)
    case .detailedPrematchStatistics(let match):
      allParams += params(withMatchId: match)
    case .liveMatchStatistics(let id):
      allParams += params(withMatchId: id)
    }

    return allParams
  }
}

extension OptaAPIManager {

  fileprivate static func params(with competitionId: String, seasonId: String) -> [String: String] {
    return [
      "competition": competitionId,
      "season_id": seasonId
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
