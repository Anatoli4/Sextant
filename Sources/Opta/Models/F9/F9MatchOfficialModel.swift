//
//  Created by Eugen Filipkov on 2/12/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi

// swiftlint:disable variable_name
public struct F9MatchOfficialModel {
  public enum Kind: String {
    case undefined
    case referee = "main"
    case firstLinesman = "lineman 1"
    case secondLinesman = "lineman 2"
    case alternateReferee = "fourth official"
    case firstAdditionalReferee = "additional assistant referee 1"
    case secondAdditionalReferee = "additional assistant referee 2"
  }
  public let id: String
  public let firstName: String
  public let lastName: String
  public let kind: Kind

  public init(_ xml: XMLElement, kind: F9MatchOfficialModel.Kind = .undefined) throws {
    let matchOfficial = xml.firstChild(staticTag: "MatchOfficial")
    id = String(matchOfficial?.attr("uID")?.dropFirst() ?? "")
    let officialName = matchOfficial?.firstChild(staticTag: "OfficialName")
    firstName = officialName?.firstChild(staticTag: "First")?.stringValue ?? ""
    lastName = officialName?.firstChild(staticTag: "Last")?.stringValue ?? ""
    self.kind = kind
  }

  public init (_ xml: XMLElement) throws {
    let attributes = xml.attributes
    id = String(attributes["uID"]?.dropFirst() ?? "")
    firstName = attributes["FirstName"] ?? ""
    lastName = attributes["LastName"] ?? ""
    kind = Kind(rawValue: attributes["Type"]?.lowercased() ?? "") ?? .undefined
  }
}
