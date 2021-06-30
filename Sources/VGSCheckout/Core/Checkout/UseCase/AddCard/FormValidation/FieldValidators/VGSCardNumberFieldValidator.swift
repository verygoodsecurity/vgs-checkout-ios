//
//  VGSCardNumberFieldValidator.swift
//  VGSCheckout

import Foundation

internal class VGSCardNumberFieldValidator: VGSFormTextFieldValidationProtocol {

	internal func isTextFieldInputComplete(_ textField: VGSTextField) -> Bool {

		let inputLength = textField.state.inputLength

		if let cardState = textField.state as? CardState {
			switch cardState.cardBrand {
			case .amex:
				return inputLength >= 15
			default:
				return inputLength >= 16
			}
		} else {
			/// TODO: check required min length
			return inputLength == 16
		}
	}
}
