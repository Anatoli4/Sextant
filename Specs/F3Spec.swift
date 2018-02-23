//
//  Created by Eugen Filipkov on 2/22/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import XCTest
import Sextant
import Gnomon
import Nimble
import RxBlocking
import SignatureInterceptor

class F3Spec: BaseSpec {
  func testRequest() {
    do {
      let requestObject = try OptaAPIManager.f3Request(competition: OptaAPIManager.Competition(id: "24", season: "2017"))
      let model = try Gnomon.models(for: requestObject).toBlocking().first()
      XCTAssertNotNil(model?.result.model)
    } catch {
      fail("\(error)")
      return
    }
  }
  
  func testParsingModel() {
    do {
      let _: F3Model = try parsedModel(with: "f3_cl",
                                       from: "xml")
    } catch {
      fail("\(error)")
      return
    }
  }
  
}
