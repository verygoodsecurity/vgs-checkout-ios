//
//  VGSCardholderFieldValidator.swift
//  VGSCheckout

import Foundation

internal class VGSCardholderFieldValidator: VGSFormTextFieldValidationProtocol {

	// MARK: - VGSFormTextFieldValidationProtocol

	internal func isTextFieldInputComplete(_ textField: VGSTextField) -> Bool {

		let inputLength = textField.state.inputLength

		return inputLength == 1
	}
}
