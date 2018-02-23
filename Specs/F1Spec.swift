//
//  Created by Eugen Filipkov on 2/2/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import XCTest
import Sextant
import Gnomon
import Nimble
import RxBlocking
import SignatureInterceptor

class F1Spec: BaseSpec {
  func testRequest() {
    do {
      let requestObject = try OptaAPIManager.f1Request(competition: OptaAPIManager.Competition(id: "24", season: "2017"))
      let model = try Gnomon.models(for: requestObject).toBlocking().first()
      XCTAssertNotNil(model?.result.model)
    } catch {
      fail("\(error)")
      return
    }
  }

  func testParsingModel() {
    do {
      let _: F1Model = try parsedModel(with: "f1",
                                       from: "xml")
    } catch {
      fail("\(error)")
      return
    }
  }
  
}
