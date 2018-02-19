//
//  Created by Eugen Filipkov on 2/9/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi
import Sextant

// swiftlint:disable variable_name
public struct F9CompetitionInfoModel: XMLFuziModel {
  public struct Round: XMLFuziModel {
    public let name: String
    public let number: Int
    //Group name/number that the specified game is from
    public let pool: String

    public init(_ xml: XMLElement) throws {
      let round = xml.firstChild(staticTag: "Round")
      name = round?.firstChild(staticTag: "Name")?.stringValue ?? ""
      number = Int(round?.firstChild(staticTag: "RoundNumber")?.stringValue ?? "0") ?? 0
      pool = round?.firstChild(staticTag: "Pool")?.stringValue ?? ""
    }
  }

  public let id: String
  public let country: String
  public let name: String
  public let round: Round
  public let seasonId: String
  public let seasonName: String
  public let matchDay: Int

  public init(_ xml: XMLElement) throws {
    guard let uId = xml.attr("uID") else { throw "miss F9 competition id" }
    id = String(uId.dropFirst())
    country = xml.firstChild(staticTag: "Country")?.stringValue ?? ""
    name = xml.firstChild(staticTag: "Name")?.stringValue ?? ""
    round = try Round(xml)
    let stat = xml.children(staticTag: "Stat")
    seasonId = stat.first { $0.attr("Type") == "season_id" }?.stringValue ?? ""
    seasonName = stat.first { $0.attr("Type") == "season_name" }?.stringValue ?? ""
    matchDay = Int(stat.first { $0.attr("Type") == "matchday" }?.stringValue ?? "0") ?? 0
  }
}
