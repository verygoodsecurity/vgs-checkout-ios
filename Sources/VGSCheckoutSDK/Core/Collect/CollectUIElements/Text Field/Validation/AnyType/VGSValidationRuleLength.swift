//
//  VGSValidationRuleLength.swift
//  VGSCheckoutSDK
//
//  Created by Dima on 23.06.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation

/**
Validate input in scope of length.
*/
internal struct VGSValidationRuleLength: VGSValidationRuleProtocol {
    
    /// Min input  length required
    let min: Int
  
    /// Max input  length required
    let max: Int
  
    /// Validation Error
    let error: VGSValidationError

    /// Initialzation
    ///
    /// - Parameters:
    ///   - error:`VGSValidationError` - error on failed validation relust.
    ///   - min: min input  length required
    ///   - max: max input  length required
    init(min: Int = 0, max: Int = Int.max, error: VGSValidationError) {
        self.min = min
        self.max = max
        self.error = error
    }
}

extension VGSValidationRuleLength: VGSRuleValidator {
  internal func validate(input: String?) -> Bool {

      guard let input = input else {
          return false
      }
      return input.count >= min && input.count <= max
  }
}
