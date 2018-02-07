//
//  Created by Eugen Filipkov on 2/7/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Foundation

// swiftlint:disable variable_name
public struct F1TeamMatchesModel: Hashable {
  public var id: String
  public var name: String
  public var matches: [F1MatchModel]

  public init(matchTeam: F1TeamModel) {
    id = matchTeam.id
    name = matchTeam.name
    matches = []
  }

  public var hashValue: Int {
    return String(id).hash
  }
}

public func == (left: F1TeamMatchesModel, right: F1TeamMatchesModel) -> Bool {
  return left.id == right.id
}
