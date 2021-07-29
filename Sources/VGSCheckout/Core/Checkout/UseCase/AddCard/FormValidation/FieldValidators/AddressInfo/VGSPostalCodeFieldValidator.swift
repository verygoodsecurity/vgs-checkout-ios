//
//  VGSPostalCodeFieldValidator.swift
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
        guard let errorMessage = textField.state.validationErrors.first else {
            return nil
        }
        return errorMessage
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
            rules = [VGSValidationRulePattern(pattern: countryISO.postalCodePattern,
                                              error: VGSAddressPostalCode.zip.invalidErrorText)]
        case .ca:
            rules = [VGSValidationRulePattern(pattern: countryISO.postalCodePattern,
                                              error: VGSAddressPostalCode.postalCode.invalidErrorText)]
        case .au:
            rules = [VGSValidationRulePattern(pattern: countryISO.postalCodePattern,
                                              error: VGSAddressPostalCode.postalCode.invalidErrorText)]
        case .nz:
            rules = [VGSValidationRulePattern(pattern: countryISO.postalCodePattern,
                                              error: VGSAddressPostalCode.postalCode.invalidErrorText)]
        case .gb:
            rules = [VGSValidationRuleLength(min: 1, max: 32,
                                             error: VGSAddressPostalCode.postalCode.invalidErrorText)]
        default:
            rules = [VGSValidationRuleLength(min: 1, max: 32,
                                             error: VGSAddressPostalCode.postalCode.invalidErrorText)]
        }
        return rules
    }
}

