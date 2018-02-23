//
//  F15Spec.swift
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

class F15Spec: BaseSpec {

  func testRequest() {
    do {      
      let requestObject = try OptaAPIManager.f15Request(competition: OptaAPIManager.Competition(id: "24", season: "2017"))
      let model = try Gnomon.models(for: requestObject).toBlocking().first()
      XCTAssertNotNil(model?.result.model)
    } catch {
      fail("\(error)")
      return
    }
  }

  func testParsingModel() {
    do {
      let _: F15Model = try parsedModel(with: "f15",
                                        from: "xml")
    } catch {
      fail("\(error)")
      return
    }
  }
}
