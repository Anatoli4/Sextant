//
//  Created by Sergei Mikhan on 01/31/18.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Fuzi

public struct F15PlayerModel: XMLFuziModel {

  // swiftlint:disable:next identifier_name
  public let id: String
  public let name: String
  public let stats: [Stat]
  public var teamId: String

  public init(xml: XMLElement, teamId: String) throws {
    try self.init(xml)
    self.teamId = teamId
  }

  public init(_ xml: XMLElement) throws {
    id = xml.attributes["uID"] ?? ""
    name = xml.firstChild(tag: "Name")?.stringValue ?? ""
    stats = xml.children(tag: "Stat").flatMap { try? Stat($0) }
    teamId = ""
  }

  public struct Stat: XMLFuziModel {

    public let kind: F15Stats.PlayerKind
    public let value: String
    public let ranking: Bool

    public init(_ xml: XMLElement) throws {
      let type = xml.attributes["Type"] ?? ""
      self.ranking = type.hasSuffix("ranking")
      self.kind = F15Stats.PlayerKind.kind(for: type, ranking: self.ranking)
      self.value = xml.stringValue
    }
  }
}
