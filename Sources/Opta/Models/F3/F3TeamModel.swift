//
//  Created by Eugen Filipkov on 2/22/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

// swiftlint:disable variable_name
public struct F3TeamModel {
  public let id: String
  public let name: String
  public private(set) var pointsDeduction: Int?
  public private(set) var points: Int?
  public private(set) var reason: String?
  public let statistics: F3TeamStatisticsModel

  public init(_ xml: XMLElement,
              allTeams: [XMLElement]) throws {
    guard let teamRef = xml.attr("TeamRef") else { throw "F3 miss team id" }
    guard let standing = xml.firstChild(staticTag: "Standing") else { throw "F3 miss Standing root" }
    id = String(teamRef.dropFirst())
    let team = allTeams.first(where: { $0.attr("uID") == teamRef })
    name = team?.firstChild(staticTag: "Name")?.stringValue ?? ""
    if let value = xml.firstChild(staticTag: "PointsDeduction")?.stringValue {
      pointsDeduction = Int(value)
    }
    if let value = xml.firstChild(staticTag: "Points")?.stringValue {
      points = Int(value)
    }
    reason = xml.firstChild(staticTag: "Reason")?.stringValue
    statistics = try F3TeamStatisticsModel(standing)
  }
}
