//
//  VGSZipCodeFieldValidator.swift
//  VGSCheckout

import Foundation

/// Postal Code/Zip field validator.
internal class VGSPostalCodeFieldValidator: VGSFormTextFieldValidationProtocol {

	// MARK: - VGSFormTextFieldValidationProtocol

	internal func isTextFieldInputComplete(_ textField: VGSTextField) -> Bool {

		let inputLength = textField.state.inputLength

		return inputLength == 1
	}

	internal func errorMessage(for textField: VGSTextField, fieldType: VGSAddCardFormFieldType) -> String? {
		return fieldType.emptyFieldNameError
	}

	internal func emptyErrorMessage(for textField: VGSTextField, fieldType: VGSAddCardFormFieldType) -> String? {
		return fieldType.emptyFieldNameError
	}
}

internal class VGSPostalCodeValidationRulesFactory {
    
    internal static func validationRules(for countryISO: VGSCountriesISO) -> [VGSValidationRuleProtocol] {
        
        let rules: [VGSValidationRuleProtocol]
        switch countryISO {
        case .us:
            rules = [VGSValidationRulePattern(pattern: "^([0-9]{5})(?:-([0-9]{4}))?$", error: "postal code error")]
        case .ca:
            rules = [VGSValidationRulePattern(pattern: "^([ABCEGHJKLMNPRSTVXY][0-9][ABCEGHJKLMNPRSTVWXYZ])\\s*([0-9][ABCEGHJKLMNPRSTVWXYZ][0-9])$", error: "postal code error")]
        case .au:
            rules = [VGSValidationRulePattern(pattern: "^\\d{4}$", error: "postal code error")]
        case .nz:
            rules = [VGSValidationRulePattern(pattern: "^\\d{4}$", error: "postal code error")]
        case .gb:
            rules = [VGSValidationRuleLength(min: 1, max: 64, error: "length error")]
        default:
            rules = [VGSValidationRuleLength(min: 1, max: 64, error: "length error")]
        }
        return rules
    }
    
    
}

