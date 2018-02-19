//
//  Created by Sergei Mikhan on 01/31/18.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import Foundation

func += <K, V> ( left: inout [K: V], right: [K: V]) {
  for (k, v) in right {
    left[k] = v
  }
}

func + <K, V> (left: [K: V], right: [K: V]) -> [K: V] {
  var mut = left
  mut += right
  return mut
}

public class DateUtils {
  public static let defaultDateFormat = "yyyyMMdd'T'HHmmssZZZ"
  public static let defaultTimeZoneAbbreviation = "BST"
  public static func dateFormaterWith(_ dateFormat: String = DateUtils.defaultDateFormat,
                                      locale: Locale = Locale.current,
                                      timeZoneAbbreviation: String = DateUtils.defaultTimeZoneAbbreviation)
    -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    dateFormatter.locale = locale
    dateFormatter.timeZone = TimeZone(abbreviation: timeZoneAbbreviation)
    return dateFormatter
  }
}
