//
//  Created by Eugen Filipkov on 2/20/18.
//  Copyright © 2018 NetcoSports. All rights reserved.
//

import XCTest
import Sextant
import Gnomon
import Nimble
import RxBlocking
import SignatureInterceptor

class F26Spec: BaseSpec {
  func testRequest() {
    do {
      let requestObject = try OptaAPIManager.f26Request(competition: OptaAPIManager.Competition(id: "24", season: "2017"))
      let model = try Gnomon.models(for: requestObject).toBlocking().first()
      XCTAssertNotNil(model?.result.model)
    } catch {
      fail("\(error)")
      return
    }
  }
  
  func testParsingModel() {
    do {
      let _: F26Model = try parsedModel(with: "f26_live_extratime",
                                        from: "xml",
                                        from: "feed/content.item/content.body")
    } catch {
      fail("\(error)")
      return
    }
  }
}

