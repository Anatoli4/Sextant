//
//  Created by Eugen Filipkov on 2/21/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

// swiftlint:disable variable_name
public struct F26MatchModel {
  public let id: String
  public let competitionInfo: F26CompetitionInfoModel
  public private(set) var date: Date?
  public private(set) var timestamp: Date?
  public let status: MatchStatus
  public let period: MatchPeriod
  public let homeTeam: F26TeamModel
  public let awayTeam: F26TeamModel

  public init(_ xml: XMLElement,
              competitionInfo: F26CompetitionInfoModel,
              date: Date?) throws {
    guard let home = xml.firstChild(staticTag: "home-team") else { throw "F26 miss home team root" }
    guard let away = xml.firstChild(staticTag: "away-team") else { throw "F26 miss away team root" }
    self.competitionInfo = competitionInfo
    self.date = date
    let attributes = xml.attributes
    id = attributes["game-id"] ?? ""
    status = MatchStatus(statusString: attributes["match-status"] ?? "")
    period = MatchPeriod(periodString: attributes["period"] ?? "")
    let dateString = attributes["timestamp"] ?? ""
    let formatter = DateUtils.dateFormaterWith("yyyy-MM-dd HH:mm:ss")
    if let date = formatter.date(from: dateString) {
      timestamp = date
    }
    homeTeam = try F26TeamModel(home)
    awayTeam = try F26TeamModel(away)
  }
}
