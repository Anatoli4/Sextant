//
//  Created by Eugen Filipkov on 2/2/18.
//

import XCTest
import Sextant
import Gnomon
import Nimble
import RxBlocking
import SignatureInterceptor

class F9Spec: BaseSpec {
  
  func testRequest() {
    do {
      let requestObject = try OptaAPIManager.f9Request(for: "974762")
      let model = try Gnomon.models(for: requestObject).toBlocking().first()
      XCTAssertNotNil(model?.result.model)
    } catch {
      fail("\(error)")
      return
    }
  }
  
  func testParsingModel() {
    do {
      let _: F9Model = try parsedModel(with: "f9_post",
                                       from: "xml")
    } catch {
      fail("\(error)")
      return
    }
  }
  
}
