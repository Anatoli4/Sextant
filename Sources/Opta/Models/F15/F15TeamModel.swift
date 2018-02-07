//
//  Created by Sergei Mikhan on 01/31/18.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Fuzi

public struct F15TeamModel: XMLFuziModel {

  // swiftlint:disable:next identifier_name
  public let id: String
  public let name: String
  public let stats: [Stat]

  public var players: [F15PlayerModel]

  public init(_ xml: XMLElement) throws {
    guard let teamUId = xml.attributes["uID"] else { throw "no team" }
    let teamId = teamUId.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)
    id = teamId
    name = xml.firstChild(tag: "Name")?.stringValue ?? ""
    stats = xml.children(tag: "Stat").flatMap { try? Stat($0) }
    players = try xml.children(tag: "Player").map { try F15PlayerModel(xml: $0, teamId: teamId) }
  }

  public struct Stat: XMLFuziModel {

    public let kind: F15Stats.TeamKind
    public let value: String
    public let ranking: Bool

    public init(_ xml: XMLElement) throws {
      let type = xml.attributes["Type"] ?? ""
      self.ranking = type.hasSuffix("ranking")
      self.kind = F15Stats.TeamKind.kind(for: type, ranking: self.ranking)
      self.value = xml.stringValue
    }
  }
}
