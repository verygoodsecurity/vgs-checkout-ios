//
//  VGSCardNumberFieldValidator.swift
//  VGSCheckout

import Foundation

internal class VGSCardNumberFieldValidator: VGSFormTextFieldValidationProtocol {

	/// Default card number length.
  internal let defaultAnyCardLength = 16
    
	internal func isTextFieldInputComplete(_ textField: VGSTextField) -> Bool {

		let inputLength = textField.state.inputLength
    
		if let cardState = textField.state as? CardState {
			let maxCardBrandLength = getMaxValidLength(for: cardState.cardBrand)
      return inputLength == maxCardBrandLength
		} else {
			return inputLength == defaultAnyCardLength
		}
	}
  
  internal func getMaxValidLength(for cardBrand: VGSCheckoutPaymentCards.CardBrand) -> Int {
    return cardBrand.cardLengths.max() ?? defaultAnyCardLength
  }
}
