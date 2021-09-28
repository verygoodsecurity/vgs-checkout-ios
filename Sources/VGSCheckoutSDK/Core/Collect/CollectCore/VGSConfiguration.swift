//
//  VGSModel.swift
//  VGSCheckoutSDK
//
//  Created by Vitalii Obertynskyi on 8/21/19.
//  Copyright © 2019 Vitalii Obertynskyi. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#endif

internal protocol VGSBaseConfigurationProtocol {
    
    var vgsCollector: VGSCollect? { get }
    
    var fieldName: String { get }
}

internal protocol VGSTextFieldConfigurationProtocol: VGSBaseConfigurationProtocol {
    
    var validationRules: VGSValidationRuleSet? { get }
  
    var isRequired: Bool { get }
    
    var isRequiredValidOnly: Bool { get }
    
    var type: FieldType { get }
    
    var formatPattern: String? { get set }
    
    var keyboardType: UIKeyboardType? { get set }
    
    var returnKeyType: UIReturnKeyType? { get set }
    
    var keyboardAppearance: UIKeyboardAppearance? { get set }
}

/// A class responsible for configuration VGSTextField.
internal class VGSConfiguration: VGSTextFieldConfigurationProtocol {
    
    // MARK: - Attributes
    
    /// Collect form that will be assiciated with VGSTextField.
	internal private(set) weak var vgsCollector: VGSCollect?
  
    /// Type of field congfiguration. Default is `FieldType.none`.
	internal var type: FieldType = .none
    
    /// Name that will be associated with `VGSTextField` and used as a JSON key on send request with textfield data to your organozation vault.
	internal let fieldName: String
    
    /// Set if `VGSTextField` is required to be non-empty and non-nil on send request. Default is `false`.
	internal var isRequired: Bool = false
    
    /// Set if `VGSTextField` is required to be valid only on send request. Default is `false`.
	internal var isRequiredValidOnly: Bool = false
    
    /// Input data visual format pattern. If not applied, will be  set by default depending on field `type`.
	internal var formatPattern: String?
    
    /// String, used to replace not default `VGSConfiguration.formatPattern` characters in input text on send request.
	internal var divider: String?

    /// Preferred UIKeyboardType for `VGSTextField`.  If not applied, will be set by default depending on field `type` parameter.
	internal var keyboardType: UIKeyboardType?
    
    ///Preferred UIReturnKeyType for `VGSTextField`.
	internal var returnKeyType: UIReturnKeyType?
    
    /// Preferred UIKeyboardAppearance for textfield. By default is `UIKeyboardAppearance.default`.
	internal var keyboardAppearance: UIKeyboardAppearance?
  
    /// Validation rules for field input. Defines `State.isValide` result.
	internal var validationRules: VGSValidationRuleSet?
           
    // MARK: - Initialization
    
    /// Initialization
    ///
    /// - Parameters:
    ///   - vgs: `VGSCollect` instance.
    ///   - fieldName: associated `fieldName`.
    internal init(collector vgs: VGSCollect, fieldName: String) {
        self.vgsCollector = vgs
        self.fieldName = fieldName
    }
}
