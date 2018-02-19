//
//  Created by Eugen Filipkov on 2/12/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

// swiftlint:disable variable_name
public struct F9TeamModel {
  public let id: String
  public let name: String?
  public let country: String?
  public let firstColorHex: String?
  public let secondColorHex: String?
  public let score: Int
  private(set) var penaltyScore: Int?
  private(set) var isFirstShootOut: Bool?
  private(set) var stats: [F9TeamStatModel]?
  private(set) var formation: F9TeamFormationModel?
  private(set) var goals: [F9PlayerGoalModel]?
  private(set) var cards: [F9PlayerCardModel]?
  private(set) var substitutions: [F9PlayerSubstitutionModel]?
  private(set) var shootOuts: [F9PlayerShootOutModel]?
  private(set) var players: [F9PlayerModel]?
  private(set) var official: F9OfficialModel?

  public init(_ teamData: XMLElement?,
              team: XMLElement?) throws {
    let teamDataAttributes = teamData?.attributes
    id = String(teamDataAttributes?["TeamRef"]?.dropFirst() ?? "")
    name = team?.firstChild(staticTag: "Name")?.stringValue
    country = team?.firstChild(staticTag: "Country")?.stringValue
    firstColorHex = team?.firstChild(staticTag: "Kit")?.attr("colour1")
    secondColorHex = team?.firstChild(staticTag: "Kit")?.attr("colour2")
    score = Int(teamDataAttributes?["Score"] ?? "0") ?? 0
    if let score = teamDataAttributes?["ShootOutScore"] {
      penaltyScore = Int(score)
    }
    let allStats = teamData?.children(staticTag: "Stat")
    stats = try allStats?.filter { $0.attributes.contains(where: { $0.key == "FH" }) }
      .flatMap { try F9TeamStatModel($0) }
    goals = try teamData?.children(staticTag: "Goal").flatMap { try F9PlayerGoalModel($0) }
    cards = try teamData?.children(staticTag: "Booking").flatMap { try F9PlayerCardModel($0) }
    substitutions = try teamData?.children(staticTag: "Substitution").flatMap { try F9PlayerSubstitutionModel($0) }
    let shootOut = teamData?.firstChild(staticTag: "ShootOut")
    isFirstShootOut = shootOut?.attr("FirstPenalty") == "1" ? true : false
    shootOuts = try shootOut?.children(staticTag: "PenaltyShot").flatMap { try F9PlayerShootOutModel($0) }
    if let usedFormation = allStats?.first(where: { $0.attr("Type") == "formation_used" }) {
      formation = F9TeamFormationModel(usedFormation.stringValue)
    }
    if let matchPlayers = teamData?.firstChild(staticTag: "PlayerLineUp")?.children(staticTag: "MatchPlayer"),
      matchPlayers.count > 0 {
      players = [F9PlayerModel]()
      for player in matchPlayers {
        players?.append(try F9PlayerModel(player,
                                          team: team,
                                          allGoals: goals,
                                          allCards: cards,
                                          allSubstitutions: substitutions,
                                          allShootOuts: shootOuts))
      }
    }
    if let teamOfficial = team?.firstChild(staticTag: "TeamOfficial") {
      official = try F9OfficialModel(teamOfficial)
    }
  }
}
