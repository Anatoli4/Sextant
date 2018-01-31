//
//  OptaPerfomanceSpec.swift
//  iOSTests
//
//  Created by Sergei Mikhan on 1/19/18.
//

import XCTest
import Sextant
import Gnomon
import Nimble
import RxBlocking

class OptaPerfomanceSpec: XCTestCase {

  override func setUp() {
    super.setUp()

    Nimble.AsyncDefaults.Timeout = 7
    URLCache.shared.removeAllCachedResponses()
    Gnomon.removeAllInterceptors()
  }

  func testParsingSwiftyJSON() {
    do {
      let model: F15CompetitionStatsSwiftyJSONModel = try parsedModel(from: "json")
    } catch {
      fail("\(error)")
      return
    }
  }

  func testParsingMarshalJSON() {
    do {
      let model: F15CompetitionStatsMarshalModel = try parsedModel(from: "json")
    } catch {
      fail("\(error)")
      return
    }
  }

  func testParsingXMLParser() {
    do {
      let model: F15CompetitionStatsXMLParserModel = try parsedModel(from: "xml")
    } catch {
      fail("\(error)")
      return
    }
  }

  func testParsingFuziXML() {
    do {
      let model: F15CompetitionStatsFuziModel = try parsedModel(from: "xml")
    } catch {
      fail("\(error)")
      return
    }
  }

  func testSwiftyJSON() {
    do {
      let requestObject: Request<SingleResult<F15CompetitionStatsSwiftyJSONModel>> = try requestJSON()
      let model = try Gnomon.models(for: requestObject).toBlocking().first()
    } catch {
      fail("\(error)")
      return
    }
  }

  func testMarshalJSON() {
    do {
      let requestObject: Request<SingleResult<F15CompetitionStatsMarshalModel>> = try requestJSON()
      let model = try Gnomon.models(for: requestObject).toBlocking().first()
    } catch {
      fail("\(error)")
      return
    }
  }

  func testXMLParser() {
    do {
      let requestObject: Request<SingleResult<F15CompetitionStatsXMLParserModel>> = try requestXML()
      let model = try Gnomon.models(for: requestObject).toBlocking().first()
    } catch {
      fail("\(error)")
      return
    }
  }

  func testFuziXML() {
    do {
      let requestObject: Request<SingleResult<F15CompetitionStatsFuziModel>> = try requestXML()
      let model = try Gnomon.models(for: requestObject).toBlocking().first()
    } catch {
      fail("\(error)")
      return
    }
  }

  fileprivate func requestXML<T: BaseModel>() throws -> Request<SingleResult<T>> {
    let headers = [
    "X-Api-Sig": "90ac3f2b62d18fe2927eb2d43bfb5f6060bcd560",
    "X-Api-Client-Id": "6c0281ef-3827-400b-a474-34a46cf61921"
    ]

    return try RequestBuilder<SingleResult<T>>()
      .setHeaders(headers)
      .setXPath("SoccerFeed/SoccerDocument")
      .setURLString("http://pipeline-psgproduction.netcosports.com/psg_oneapp/1/competition.php?competition=24&feed_type=F15&psw=p@ssdT15&season_id=2017&user=netcopsg")
      .setMethod(.GET)
      .build()
  }

  fileprivate func requestJSON<T: BaseModel>() throws -> Request<SingleResult<T>> {
    let headers = [
      "X-Api-Sig": "f7e287b035b0b4375b1e645b49795ff1b4f07612",
      "X-Api-Client-Id": "6c0281ef-3827-400b-a474-34a46cf61921"
    ]

    return try RequestBuilder<SingleResult<T>>()
      .setHeaders(headers)
      .setXPath("SoccerFeed/SoccerDocument")
      .setURLString("http://pipeline-psgproduction.netcosports.com/psg_oneapp/1/competition.php?competition=24&feed_type=F15&json=1&psw=p@ssdT15&season_id=2017&user=netcopsg")
      .setMethod(.GET)
      .build()
  }

  fileprivate func parsedModel<T: BaseModel>(from fileExtension: String) throws -> T {
    guard let url = Bundle(for: type(of: self)).url(forResource: "f15", withExtension: fileExtension) else {
      throw "No path"
    }
    let data = try Data(contentsOf: url)
    return try T.model(with: data, atPath: "SoccerFeed/SoccerDocument")
  }

}
