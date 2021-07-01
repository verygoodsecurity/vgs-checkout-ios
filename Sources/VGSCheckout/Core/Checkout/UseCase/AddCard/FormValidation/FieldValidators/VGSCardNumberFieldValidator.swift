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

	internal func isTextFieldInputValid(_ textField: VGSTextField) -> Bool {
//		if let cardState = textField.state as? CardState {
//			/// TODO: can use 16(15 for amex) as default digits
//			if cardState.cardBrand.cardLengths.max() ?? 16 <= cardState.inputLength {
//				print(cardState.validationErrors)
//				formItem.formItemView.updateUI(for: .invalid)
//			} else {
//				formItem.formItemView.updateUI(for: .focused)
//			}
//		} else {
//			print(field.state.validationErrors)
//			formItem.formItemView.updateUI(for: .invalid)
//		}

		return false
	}
}
