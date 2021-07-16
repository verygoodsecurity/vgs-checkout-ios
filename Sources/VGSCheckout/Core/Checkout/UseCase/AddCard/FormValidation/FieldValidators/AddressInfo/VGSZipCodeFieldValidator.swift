//
//  VGSZipCodeFieldValidator.swift
//  VGSCheckout

import Foundation

/// Zip code field validator.
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
		return fieldType.emptyFieldNameError
	}
}
