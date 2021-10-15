//
//  VGSPostalCodeFieldValidator.swift
//  VGSCheckoutSDK

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
		guard let errorMessage = textField.state.validationErrors.first else {
				return nil
		}
		return errorMessage
	}
}

internal class VGSPostalCodeValidationRulesFactory {

	internal static let emptyPostalCodeRule = VGSValidationRuleLength(min: 1,
																	 error: VGSAddressPostalCode.postalCode.emptyErrorText)

	internal static let emptyZipCodeRule = VGSValidationRuleLength(min: 1,
																 error: VGSAddressPostalCode.zip.emptyErrorText)
    
    internal static func validationRules(for countryISO: VGSCountriesISO) -> [VGSValidationRuleProtocol] {
        
        let rules: [VGSValidationRuleProtocol]
        switch countryISO {
        case .us:
            rules = [emptyZipCodeRule, VGSValidationRulePattern(pattern: countryISO.postalCodePattern,
                                              error: VGSAddressPostalCode.zip.invalidErrorText)]
        case .ca, .au, .nz:
            rules = [emptyPostalCodeRule, VGSValidationRulePattern(pattern: countryISO.postalCodePattern,
                                              error: VGSAddressPostalCode.postalCode.invalidErrorText)]
        case .gb:
            rules = [emptyPostalCodeRule, VGSValidationRuleLength(min: 1, max: 32,
                                             error: VGSAddressPostalCode.postalCode.invalidErrorText)]
        default:
            rules = [emptyPostalCodeRule, VGSValidationRuleLength(min: 1, max: 32,
                                             error: VGSAddressPostalCode.postalCode.invalidErrorText)]
        }
        return rules
    }
}
