//
//  Created by Eugen Filipkov on 2/22/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

// swiftlint:disable variable_name
public struct F3GroupModel {
  public let id: String?
  public let name: String?
  public let matchday: Int
  public let teams: [F3TeamModel]

  public init(_ xml: XMLElement,
              allTeams: [XMLElement]) throws {
    let nameRoot = xml.firstChild(staticTag: "Round")?.firstChild(staticTag: "Name")
    id = nameRoot?.attr("id")
    name = nameRoot?.stringValue
    matchday = Int(xml.attr("Matchday") ?? "0") ?? 0
    let allTeams = allTeams
    teams = try xml.children(staticTag: "TeamRecord")
      .flatMap { try F3TeamModel($0,
                                 allTeams: allTeams) }
  }
}
