//
//  Created by Eugen Filipkov on 2/6/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

public struct F1TeamGoalModel: XMLFuziModel {
  let period: MatchPeriod
  let playerId: String
  let type: GoalType

  public init(_ xml: XMLElement) throws {
    let attributes = xml.attributes
    guard let playerRef = attributes["PlayerRef"],
      playerRef.isEmpty == false else { throw "miss F1 team player goal id" }
    playerId = String(playerRef.dropFirst())
    period = MatchPeriod(periodString: attributes["Period"]?.lowercased() ?? "")
    type = GoalType(goalString: attributes["Type"] ?? "")
  }
}

// swiftlint:disable variable_name
public struct F1TeamModel {
  public let id: String
  public let name: String
  public let score: Int
  public let halfScore: Int
  public let side: TeamSide
  public private(set) var ninetyScore: Int?
  public private(set) var extraScore: Int?
  public private(set) var penaltyScore: Int?
  public let goals: [F1TeamGoalModel]

  public init(_ xml: XMLElement,
              teamsInfo: [XMLElement]) throws {
    let attributes = xml.attributes
    guard let teamRef = attributes["TeamRef"], teamRef.isEmpty == false else { throw "miss F1 team id" }
    guard let teamName = teamsInfo
      .first(where: { $0.attr("uID") == teamRef })
      .flatMap({ $0.firstChild(staticTag: "Name")?.stringValue }) else { throw "miss F1 team name" }
    id = String(teamRef.dropFirst())
    name = teamName
    score = Int(attributes["Score"] ?? "0") ?? 0
    halfScore = Int(attributes["HalfScore"] ?? "0") ?? 0
    side = TeamSide(rawValue: attributes["Side"]?.lowercased() ?? "") ?? .undefined
    if let score = attributes["NinetyScore"] {
      ninetyScore = Int(score)
    }
    if let score = attributes["ExtraScore"] {
      extraScore = Int(score)
    }
    if let score = attributes["PenaltyScore"] {
      penaltyScore = Int(score)
    }
    goals = try xml.children(staticTag: "Goal").map { try F1TeamGoalModel($0) }
  }
}
