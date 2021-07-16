//
//  VGSZipCodeFieldValidator.swift
//  VGSCheckout

import Foundation

internal class VGSZipCodeFieldValidator: VGSFormTextFieldValidationProtocol {

	// MARK: - VGSFormTextFieldValidationProtocol

	internal func isTextFieldInputComplete(_ textField: VGSTextField) -> Bool {

		let inputLength = textField.state.inputLength

		return inputLength == 1
	}

	internal func errorMessage(for textField: VGSTextField, fieldType: VGSAddCardFormFieldType) -> String? {
		return fieldType.emptyFieldNameError
	}

	internal func emptyErrorMessage(for textField: VGSTextField, fieldType: VGSAddCardFormFieldType) -> String? {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_holder_empty_error")
	}
}
