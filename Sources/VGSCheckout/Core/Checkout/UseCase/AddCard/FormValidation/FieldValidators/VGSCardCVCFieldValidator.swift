//
//  VGSCardCVCFieldValidator.swift
//  VGSCheckout

import Foundation

internal class VGSCardCVCFieldValidator: VGSFormTextFieldValidationProtocol {

	// MARK: - VGSFormTextFieldValidationProtocol

	internal func isTextFieldInputComplete(_ textField: VGSTextField) -> Bool {

		let inputLength = textField.state.inputLength

		// Find card number field first to check amex case.
		guard let cardNumberTextField = textField.vgsCollector?.textFields.first(where: {return $0.fieldType == .cardNumber}), let state = cardNumberTextField.state as? CardState else {
			assertionFailure("Cannot find card number field.")
			return false
		}

		let currentBrandFormatPattern = state.cardBrand.cvcFormatPattern

		return inputLength == currentBrandFormatPattern.count
	}

	internal func errorMessage(for textField: VGSTextField, fieldType: VGSAddCardFormFieldType) -> String? {
		return "Security code is not valid"
	}
}
