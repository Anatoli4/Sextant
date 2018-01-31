//
//  Created by Sergei Mikhan on 01/31/18.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import UIKit

public class F15Stats {

  public enum TeamKind: String {

    static func kind(for type: String, ranking: Bool = false) -> TeamKind {
      var typeString = type
      if ranking {
        typeString = typeString.replacingOccurrences(of: " ranking", with: "")
      }
      return TeamKind(rawValue: typeString) ?? .unknown
    }

    case unknown = "unknown"

    case games = "total games"
    case goals = "total goals"
    case cards = "total card"
    case yellowCards = "total yellow card"
    case redCards = "total red card"

    case passes = "total pass"
    case passPercent = "total pass pct"
    case accuratePass = "total accurate pass"

    case fouls = "total fouls"
    case wasFouled = "total was fouled"
    case blocked = "total blocked scoring att"
    case onTarget = "total ontarget scoring att"
    case takeOn = "total takeon"
    case offside = "total offside"

    case duelsWon = "total duels won"
    case duelsLost = "total duels lost"

    case wonCorners = "total won corners"
    case lostCorners = "total lost corners"

    case goalsConceded = "total goals conceded"
    case goalsConcededObox = "total goals conceded obox"
    case goalsConcededIbox = "total goals conceded ibox"

    case attempsConceded = "total attempts conceded"
    case attemptsConcededObox = "total attempts conceded obox"
    case attemptsConcededIbox = "total attempts conceded ibox"

    case cross = "total cross"
    case crossPercent = "total cross pct"
    case accurateCross = "total accurate cross"

    case tackle = "total tackle"
    case tacklePercent = "total tackle pct"
    case wonTackle = "total won tackle"

    case scoring = "total scoring att"
    case scoringAccuracy = "total scoring accuracy"

    case claim = "total claim"
    case cleanSheet = "total clean sheet"
    case contest = "total contest"
    case clearance = "total clearance"
    case goalConversion = "total goal conversion"
    case touchesInOpposition = "total touches in opposition box"
  }

  public enum PlayerKind: String {

    static func kind(for type: String, ranking: Bool = false) -> PlayerKind {
      var typeString = type
      if ranking {
        typeString = typeString.replacingOccurrences(of: " ranking", with: "")
      }
      return PlayerKind(rawValue: typeString) ?? .unknown
    }

    case unknown = "unknown"

    case lastName = "last name"
    case firstName = "first name"

    case totalGames = "total games"
    case minsPlayed = "total mins played"

    case goals = "total goals"

    case attAssist = "total att assist"
    case assist = "total assists"

    case cards = "total card"
    case yellowCards = "total yellow card"
    case totalRedCards = "total red card"

    case passes = "total pass"
    case accuratePass = "total accurate pass"
    case fwdZonePass = "total fwd zone pass"
    case accurateFwdZonePass = "total accurate fwd zone pass"
    case accurateBackZonePass = "total accurate back zone pass"

    case handBalls = "total hand ball"
    case longBalls = "total long balls"
    case accurateLongBalls = "total accurate long balls"

    case fouls = "total fouls"
    case wasFouled = "total was fouled"

    case aerialWon = "total aerial won"
    case aerialLost = "total aerial lost"

    case clearance = "total clearance"
    case effectiveClearance = "total effective clearance"

    case tackle = "total tackle"
    case wonTackle = "total won tackle"

    case attempts = "total attempt"
    case attemptsConcededIbox = "total attempts conceded ibox"
    case attemptsConcededObox = "total attempts conceded obox"
    case onTargetAttempts = "total ontarget attempt"

    case duelsWon = "total duels won"
    case duelsLost = "total duels lost"

    case contest = "total contest"
    case wonContest = "total won contest"

    case scoring = "total scoring att"
    case blockedScoring = "total blocked scoring att"

    case crosses = "total crosses"
    case accurateCross = "total accurate cross"

    case subOn = "total sub on"
    case subOff = "total sub off"

    case interception = "total interception"
    case goalsConceded = "total goals conceded"
    case challengeLost = "total challenge lost"
    case cleanSheet = "total clean sheet"
    case touchesInOpposition = "total touches in opposition box"
  }

}
