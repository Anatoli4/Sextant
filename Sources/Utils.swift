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
