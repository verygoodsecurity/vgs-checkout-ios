//
//  VGSExpDateFieldValidator.swift
//  VGSCheckout

import Foundation

internal class VGSExpDateFieldValidator: VGSFormTextFieldValidationProtocol {

	// MARK: - VGSFormTextFieldValidationProtocol

	internal func isTextFieldInputComplete(_ textField: VGSTextField) -> Bool {

		let inputLength = textField.state.inputLength

    guard let configuration = textField.configuration as? VGSExpDateConfiguration, let dateFormat = configuration.inputDateFormat else {
			assertionFailure("Configuration is not set for exp date field.")
			return false
		}
    return inputLength == dateFormat.monthCharacters + dateFormat.yearCharacters
	}

	internal func errorMessage(for textField: VGSTextField, fieldType: VGSAddCardFormFieldType) -> String? {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_expiration_date_invalid_error")
	}

	internal func emptyErrorMessage(for textField: VGSTextField, fieldType: VGSAddCardFormFieldType) -> String? {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_expiration_date_empty_error")
	}
}
