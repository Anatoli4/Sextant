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
import SignatureInterceptor

class F15Spec: XCTestCase {

  override func setUp() {
    super.setUp()

    Nimble.AsyncDefaults.Timeout = 7
    URLCache.shared.removeAllCachedResponses()
    Gnomon.removeAllInterceptors()

    let interceptor = signatureInterceptor(clientId: "6c0281ef-3827-400b-a474-34a46cf61921",
                                           clientSecret: "64d554e2f154c4bf13667ec2b16bebaeea83f001")
    Gnomon.addRequestInterceptor(interceptor)
    Gnomon.logging = true
    OptaAPIManager.settings = Settings(baseUrl: "http://pipeline-psgproduction.netcosports.com/psg_oneapp/1/",
                                       username: "netcopsg", password: "p@ssdT15")
  }

  func testRequest() {
    do {
      let requestObject = try OptaAPIManager.f15Request(for: "24", season: "2017")
      let model = try Gnomon.models(for: requestObject).toBlocking().first()
      XCTAssertNotNil(model?.result.model)
    } catch {
      fail("\(error)")
      return
    }
  }

  func testParsingModel() {
    do {
      let _: F15Model = try parsedModel(from: "xml")
    } catch {
      fail("\(error)")
      return
    }
  }

  fileprivate func parsedModel<T: BaseModel>(from fileExtension: String) throws -> T {
    guard let url = Bundle(for: type(of: self)).url(forResource: "f15", withExtension: fileExtension) else {
      throw "No path"
    }
    let data = try Data(contentsOf: url)
    return try T.model(with: data, atPath: "SoccerFeed/SoccerDocument")
  }

}
