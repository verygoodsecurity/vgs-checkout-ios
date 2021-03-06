//
//  VGSValidationRule.swift
//  VGSCheckoutSDK
//
//  Created by Dima on 23.06.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation

/// :nodoc: Protocol describing validation rule object
internal protocol VGSValidationRuleProtocol {
  
    /// Validation Error
    var error: VGSValidationError { get }
}

/// Set of validation rules
internal struct VGSValidationRuleSet {
    
    internal var rules = [AnyValidationRule]()
    
    /// Initialzation
    init() { }
    
    /// Initialzation
    ///
    /// - Parameters:
    ///   - rules: array of validation rules
    init(rules: [VGSValidationRuleProtocol]) {
        
        self.rules = rules.map(AnyValidationRule.init)
    }
    
    /// Add validation rule
    mutating func add(rule: VGSValidationRuleProtocol) {
     
        let anyRule = AnyValidationRule(base: rule)
        rules.append(anyRule)
    }
}

internal struct AnyValidationRule: VGSValidationRuleProtocol {
    
    let error: VGSValidationError
    
    private let baseValidateInput: ((String?) -> Bool)?

    init(base: VGSValidationRuleProtocol) {
        
      baseValidateInput = (base as? VGSRuleValidator)?.validate ?? nil
      error = base.error
    }
    
    func validate(input: String?) -> Bool {
        
      return baseValidateInput?(input) ?? true
    }
}
