//
//  Created by Eugen Filipkov on 2/14/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi
import Sextant

/*
 This class represents F9 formation
 Specification:
 http://www.optasports.com/en/praxis/documentation/football-feed-appendices/formations-explained.aspx
 */

public struct F9TeamFormationModel {
  public enum Row {
    case one
    case two(flanged: Bool)
    case three
    case four
    case five

    public var count: Int {
      switch self {
      case .one: return 1
      case .two(flanged: _): return 2
      case .three: return 3
      case .four: return 4
      case .five: return 5
      }
    }
  }

  public var withGoalkeeper: F9TeamFormationModel {
    var formation = self
    formation.rows.insert(.one, at: 0)
    formation.order.insert(1, at: 0)
    return formation
  }

  private(set) var formation: String
  private(set) var rows: [Row]
  private(set) var order: [Int]

  // swiftlint:disable function_body_length
  // swiftlint:disable:next cyclomatic_complexity
  public init(_ formation: String) {
    // swiftlint:enable function_body_length
    self.formation = formation
    switch formation {
    case "442":
      rows = [.four, .four, .two(flanged: false)]
      order = [2, 5, 6, 3, 7, 4, 8, 11, 10, 9]
    case "41212":
      rows = [.four, .one, .two(flanged: true), .one, .two(flanged: false)]
      order = [2, 5, 6, 3, 4, 7, 11, 8, 10, 9]
    case "433":
      rows = [.four, .three, .three]
      order = [2, 5, 6, 3, 7, 4, 8, 10, 9, 11]
    case "451":
      rows = [.four, .three, .two(flanged: true), .one]
      order = [2, 5, 6, 3, 4, 10, 8, 7, 11, 9]
    case "4411":
      rows = [.four, .four, .one, .one]
      order = [2, 5, 6, 3, 7, 4, 8, 11, 10, 9]
    case "4141":
      rows = [.four, .one, .four, .one]
      order = [2, 5, 6, 3, 4, 7, 8, 10, 11, 9]
    case "4231":
      rows = [.four, .two(flanged: false), .three, .one]
      order = [2, 5, 6, 3, 8, 4, 7, 10, 11, 9]
    case "4321":
      rows = [.four, .three, .two(flanged: false), .one]
      order = [2, 5, 6, 3, 8, 4, 7, 10, 11, 9]
    case "532":
      rows = [.five, .three, .two(flanged: false)]
      order = [2, 6, 5, 4, 3, 7, 8, 11, 10, 9]
    case "541":
      rows = [.five, .four, .one]
      order = [2, 6, 5, 4, 3, 7, 8, 10, 11, 9]
    case "352":
      rows = [.three, .three, .two(flanged: true), .two(flanged: false)]
      order = [6, 5, 4, 7, 11, 8, 2, 3, 10, 9]
    case "343":
      rows = [.three, .four, .three]
      order = [6, 5, 4, 2, 7, 8, 3, 10, 9, 11]
    case "4222":
      rows = [.four, .two(flanged: false), .two(flanged: false), .two(flanged: false)]
      order = [2, 5, 6, 3, 4, 8, 7, 11, 10, 9]
    case "3511":
      rows = [.three, .five, .one, .one]
      order = [6, 5, 4, 2, 7, 11, 8, 3, 10, 9]
    case "3421":
      rows = [.three, .four, .two(flanged: false), .one]
      order = [6, 5, 4, 2, 7, 8, 3, 10, 11, 9]
    case "3412":
      rows = [.three, .four, .one, .two(flanged: false)]
      order = [6, 5, 4, 2, 7, 8, 3, 9, 10, 11]
    case "3142":
      rows = [.three, .one, .four, .two(flanged: false)]
      order = [5, 4, 6, 8, 2, 7, 11, 3, 9, 10]
    case "343d":
      rows = [.three, .one, .two(flanged: true), .one, .two(flanged: false)]
      order = [6, 5, 4, 8, 2, 3, 7, 10, 9, 11]
    case "4132":
      rows = [.four, .one, .three, .two(flanged: false)]
      order = [2, 5, 6, 3, 4, 7, 8, 11, 9, 10]
    case "4240":
      rows = [.four, .two(flanged: false), .four]
      order = [2, 5, 6, 3, 4, 8, 7, 9, 10, 11]
    case "4312":
      rows = [.four, .three, .one, .two(flanged: false)]
      order = [2, 5, 6, 3, 7, 4, 11, 8, 9, 10]
    case "3241":
      rows = [.three, .two(flanged: false), .four, .one]
      order = [6, 5, 4, 2, 3, 10, 7, 8, 11, 9]
    case "3331":
      rows = [.three, .three, .three, .one]
      order = [6, 5, 4, 2, 8, 3, 10, 7, 11, 9]
    default:
      rows = [.four, .four, .two(flanged: false)]
      order = [2, 5, 6, 3, 7, 4, 8, 11, 10, 9]
    }
  }
}
