//
//  VGSExpDateFieldValidator.swift
//  VGSCheckout

import Foundation

internal class VGSExpDateFieldValidator: VGSFormTextFieldValidationProtocol {

	// MARK: - VGSFormTextFieldValidationProtocol

	internal func isTextFieldInputComplete(_ textField: VGSTextField) -> Bool {

		let inputLength = textField.state.inputLength

		guard let configurationFormatPattern = textField.configuration?.formatPattern else {
			assertionFailure("Configuration is not set for exp date field.")
			return false
		}

		/// TODO: use format pattern instead?
		return inputLength >= configurationFormatPattern.count
	}
}
