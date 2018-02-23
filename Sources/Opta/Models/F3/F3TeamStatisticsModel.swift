//
//  Created by Eugen Filipkov on 2/23/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

public struct F3TeamStatisticsModel: XMLFuziModel {
  public let home: F3TeamStatisticModel
  public let away: F3TeamStatisticModel
  public let total: F3TeamStatisticModel
  public let startDayPosition: Int
  private(set) var relegationAverage: Int?

  public init(_ xml: XMLElement) throws {
    home = F3TeamStatisticModel.statistics(xml: xml,
                                           prefix: "Home")
    away = F3TeamStatisticModel.statistics(xml: xml,
                                           prefix: "Away")
    total = F3TeamStatisticModel.statistics(xml: xml)
    startDayPosition = Int(xml.firstChild(staticTag: "StartDayPosition")?.stringValue ?? "0") ?? 0
    if let value = xml.firstChild(staticTag: "RelegationAverage")?.stringValue {
      relegationAverage = Int(value)
    }
  }
}

public struct F3TeamStatisticModel {
  public static let keys = ["Against", "Drawn", "For", "Lost", "Played", "Points", "Position", "Won"]
  public let goalsConceded: Int
  public let drawn: Int
  public let goalsScored: Int
  public let lost: Int
  public let played: Int
  public let points: Int
  public let position: Int
  public let won: Int

  fileprivate static func statistics(xml: XMLElement,
                                     prefix: String = "",
                                     keys: [String] = F3TeamStatisticModel.keys) -> F3TeamStatisticModel {
    guard keys.count >= 8 else {
      return F3TeamStatisticModel(goalsConceded: 0,
                                  drawn: 0,
                                  goalsScored: 0,
                                  lost: 0,
                                  played: 0,
                                  points: 0,
                                  position: 0,
                                  won: 0)
    }
    func value(index: Int) -> Int {
      let key = keys[index]
      let value = Int(xml.firstChild(xpath: prefix + key)?.stringValue ?? "0") ?? 0
      return value
    }
    let standing = F3TeamStatisticModel(goalsConceded: value(index: 0),
                                        drawn: value(index: 1),
                                        goalsScored: value(index: 2),
                                        lost: value(index: 3),
                                        played: value(index: 4),
                                        points: value(index: 5),
                                        position: value(index: 6),
                                        won: value(index: 7))
    return standing
  }
}
