//
//  Created by Eugen Filipkov on 2/19/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

/*
 This class represents F26 live, past and next match. Sample request:
 "/competition.php?feed_type=F26&competition=24"
 Specification:
 http://praxis.optasports.com/documentation/football-feed-specifications/f26-live-scores.aspx
 */

public struct F26Model: XMLFuziModel {
  public let matchesSets: [F26MatchesSetModel]?
  public let allMatches: [F26MatchModel]?

  public init(_ xml: XMLElement) throws {
    matchesSets = try xml.children(staticTag: "results")
      .flatMap { try F26MatchesSetModel($0) }
    allMatches = matchesSets?.flatMap { $0.matches }.flatMap { $0 }
  }
}

// swiftlint:disable variable_name
public struct F26CompetitionInfoModel: XMLFuziModel {
  let id: String
  let name: String

  public init(_ xml: XMLElement) throws {
    let attributes = xml.attributes
    id = attributes["comp-id"] ?? ""
    name = attributes["comp-name"] ?? ""
  }
}

public struct F26MatchesSetModel: XMLFuziModel {
  public let competitionInfo: F26CompetitionInfoModel
  private(set) var date: Date?
  private(set) var matches: [F26MatchModel]?

  public init(_ xml: XMLElement) throws {
    let attributes = xml.attributes
    let dateString = (attributes["date"] ?? "") + (attributes["ko-time"] ?? "")
    let formatter = DateUtils.dateFormaterWith("yyyyMMddHH:mm")
    if let date = formatter.date(from: dateString) {
      self.date = date
    }
    competitionInfo = try F26CompetitionInfoModel(xml)
    let info = competitionInfo
    let date = self.date
    matches = try xml.children(staticTag: "result").flatMap { try F26MatchModel($0,
                                                                                competitionInfo: info,
                                                                                date: date)}
  }
}
