//
//  Created by Eugen Filipkov on 2/9/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi
import Sextant

public struct F9MatchInfoModel: XMLFuziModel {
  public let type: MatchType
  public let periodStatus: MatchPeriod
  private(set) var date: Date?
  public let official: F9MatchOfficialModel
  public let assistantOfficials: [F9MatchOfficialModel]
  private(set) var result: F9MatchResultModel?
  public let matchTime: Int
  private(set) var calculatedMatchTime: Int = 0
  private(set) var firstHalfTime: Int?
  private(set) var firstHalfStartDate: Date?
  private(set) var firstHalfStopDate: Date?
  private(set) var secondHalfTime: Int?
  private(set) var secondHalfStartDate: Date?
  private(set) var secondHalfStopDate: Date?
  private(set) var firstHalfExtraTime: Int?
  private(set) var firstHalfExtraStartDate: Date?
  private(set) var firstHalfExtraStopDate: Date?
  private(set) var secondHalfExtraTime: Int?
  private(set) var secondHalfExtraStartDate: Date?
  private(set) var secondHalfExtraStopDate: Date?

  // swiftlint:disable:next cyclomatic_complexity
  public init(_ xml: XMLElement) throws {
    guard let matchInfo = xml.firstChild(staticTag: "MatchInfo") else { throw "miss F9 MatchInfo root" }
    let matchInfoAttributes = matchInfo.attributes
    type = MatchType(rawValue: matchInfoAttributes["MatchType"]?.lowercased() ?? "") ?? .undefined
    periodStatus = MatchPeriod(periodString: matchInfoAttributes["Period"]?.lowercased() ?? "")
    let formatter = DateUtils.dateFormaterWith()
    if let mdate = matchInfo.firstChild(staticTag: "Date")?.stringValue {
      date = formatter.date(from: mdate)
    }
    official = try F9MatchOfficialModel(xml, kind: .referee)
    assistantOfficials = try xml.firstChild(staticTag: "AssistantOfficials")?
      .children(staticTag: "AssistantOfficial").map {try F9MatchOfficialModel($0)} ?? []
    if let res = xml.firstChild(staticTag: "MatchInfo")?.firstChild(staticTag: "Result") {
      result = try F9MatchResultModel(res)
    }
    let stats = xml.children(staticTag: "Stat")
    matchTime = Int(stats.first { $0.attr("Type") == "match_time" }?.stringValue ?? "0") ?? 0
    if let stat = stats.first(where: { $0.attr("Type") == "first_half_time" })?.stringValue {
      firstHalfTime = Int(stat)
    }
    if let stat = stats.first(where: { $0.attr("Type") == "first_half_start" })?.stringValue {
      firstHalfStartDate = formatter.date(from: stat)
    }
    if let stat = stats.first(where: { $0.attr("Type") == "first_half_stop" })?.stringValue {
      firstHalfStopDate = formatter.date(from: stat)
    }
    if let stat = stats.first(where: { $0.attr("Type") == "second_half_time" })?.stringValue {
      secondHalfTime = Int(stat)
    }
    if let stat = stats.first(where: { $0.attr("Type") == "second_half_start" })?.stringValue {
      secondHalfStartDate = formatter.date(from: stat)
    }
    if let stat = stats.first(where: { $0.attr("Type") == "second_half_stop" })?.stringValue {
      secondHalfStopDate = formatter.date(from: stat)
    }
    if let stat = stats.first(where: { $0.attr("Type") == "first_half_extra_time" })?.stringValue {
      firstHalfExtraTime = Int(stat)
    }
    if let stat = stats.first(where: { $0.attr("Type") == "first_half_extra_start" })?.stringValue {
      firstHalfExtraStartDate = formatter.date(from: stat)
    }
    if let stat = stats.first(where: { $0.attr("Type") == "first_half_extra_stop" })?.stringValue {
      firstHalfExtraStopDate = formatter.date(from: stat)
    }
    if let stat = stats.first(where: { $0.attr("Type") == "second_half_extra_time" })?.stringValue {
      secondHalfExtraTime = Int(stat)
    }
    if let stat = stats.first(where: { $0.attr("Type") == "second_half_extra_start" })?.stringValue {
      secondHalfExtraStartDate = formatter.date(from: stat)
    }
    if let stat = stats.first(where: { $0.attr("Type") == "second_half_extra_stop" })?.stringValue {
      secondHalfExtraStopDate = formatter.date(from: stat)
    }
    calculatedMatchTime = calculateMatchTime(stats)
  }

  private func calculateMatchTime(_ stats: [XMLElement]?) -> Int {
    let periods = ["first_half_start",
                   "first_half_stop",
                   "second_half_start",
                   "second_half_stop",
                   "first_half_extra_start",
                   "first_half_extra_stop",
                   "second_half_extra_start",
                   "second_half_extra_stop"]
    let periodMinutes = [1, 46, 91, 106, 121]
    var periodIndex = periods.count
    var startTime: String? = nil
    while startTime == nil && periodIndex > 0 {
      periodIndex -= 1
      startTime = stats?.first { $0.attr("Type") == periods[periodIndex] }?.stringValue
    }
    guard let time = startTime else {
      return -1
    }
    let formatter = DateFormatter()
    formatter.dateFormat = DateUtils.defaultDateFormat
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let startTimeDate = formatter.date(from: time)
    let activePeriod = periodIndex / 2
    let isPeriodFinished = periodIndex % 2 > 0
    guard let dateTime = startTimeDate else {
      return -1
    }
    var minutes = -1
    if isPeriodFinished {
      minutes = periodMinutes[activePeriod + 1]
    } else {
      let minute = Calendar.current.dateComponents([.minute], from: dateTime, to: Date()).minute ?? 0
      minutes = periodMinutes[activePeriod] + minute
    }
    if minutes < 0 || minutes > 150 {
      return -1
    }
    return minutes
  }
}
