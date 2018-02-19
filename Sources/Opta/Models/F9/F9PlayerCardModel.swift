//
//  Created by Eugen Filipkov on 2/15/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import Fuzi
import Sextant

// swiftlint:disable variable_name
public struct F9PlayerCardModel: XMLFuziModel {
  public enum Name: String {
    case undefined
    case yellow
    case red
  }
  public enum Kind: String {
    case undefined
    case yellow = "yellow"
    case secondYellow = "secondyellow"
    case red = "straightred"
  }
  public enum Reason: String {
    case undefined
    case handball = "handball"
    case rescindedCard = "rescinded card"
    case notRetreating = "not retreating"
    case foul = "foul"
    case excessiveCelebration = "excessive celebration"
    case violentConduct = "violent conduct"
    case otherReason = "other reason"
    case refereeAbuse = "referee abuse"
    case argument = "argument"
    case simulation = "simulation"
    case noImpactOnTiming = "no impact on timing"
    case crowdInteraction = "crowd interaction"
    case foulAbusiveLanguage = "foul and abusive language"
    case encroachment = "encroachment"
    case persistentInfringement = "persistent infringement"
    case dangerousPlay = "dangerous play"
    case professionalFoul = "professional foul last man"
    case dissent = "dissent"
    case notVisible = "not visible"
    case offBallFoul = "off the ball foul"
    case enteringField = "entering field"
    case professionalFoulHandball = "professional foul handball"
    case spitting = "spitting"
    case deniedGoalScoringOpportunity = "denied goal-scoring opportunity"
  }

  public let id: String
  public let name: Name
  public let kind: Kind
  public let period: MatchPeriod
  public let reason: Reason
  public let playerId: String
  public let minute: Int
  /*
   Unique within the game. The first digit indicates the half/period.
   The middle digits indicate the event minute. the last indicates the event number
   (from cards, goals and subs) which are processed in blocks indepedently of chronological order;
   cards first, then goals, then substitutes
   */
  public let eventNumber: Int
  public let eventId: String
  private(set) var timeStamp: Date?

  public init(_ xml: XMLElement) throws {
    let attributes = xml.attributes
    id = String(attributes["uID"]?.dropFirst() ?? "")
    name = Name(rawValue: attributes["Card"]?.lowercased() ?? "") ?? .undefined
    kind = Kind(rawValue: attributes["CardType"]?.lowercased() ?? "") ?? .undefined
    period = MatchPeriod(periodString: attributes["Period"]?.lowercased() ?? "")
    reason = Reason(rawValue: attributes["Reason"]?.lowercased() ?? "") ?? .undefined
    playerId = String(attributes["PlayerRef"]?.dropFirst() ?? "")
    minute = Int(attributes["Time"] ?? "0") ?? 0
    eventNumber = Int(attributes["EventNumber"] ?? "0") ?? 0
    eventId = attributes["EventID"] ?? ""
    if let timestamp = attributes["TimeStamp"] {
      timeStamp = DateUtils.dateFormaterWith().date(from: timestamp)
    }
  }
}
