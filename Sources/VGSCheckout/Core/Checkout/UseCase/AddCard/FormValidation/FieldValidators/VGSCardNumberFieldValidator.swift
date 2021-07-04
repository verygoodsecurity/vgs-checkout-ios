//
//  VGSCardNumberFieldValidator.swift
//  VGSCheckout

import Foundation

internal class VGSCardNumberFieldValidator: VGSFormTextFieldValidationProtocol {

  internal let DEFAULT_ANY_CARD_LENGHT = 16
  internal let DEFAULT_AMEX_CARD_LENGHT = 15
    
	internal func isTextFieldInputComplete(_ textField: VGSTextField) -> Bool {

		let inputLength = textField.state.inputLength
    
		if let cardState = textField.state as? CardState {
      let maxCardBrandLength = getMaxValidLengthForCardBrand(cardState.cardBrand)
      return inputLength == maxCardBrandLength
		} else {
			return inputLength == DEFAULT_ANY_CARD_LENGHT
		}
	}
  
  internal func getMaxValidLengthForCardBrand(_ cardBrand: VGSCheckoutPaymentCards.CardBrand) -> Int {
    return cardBrand.cardLengths.max() ?? DEFAULT_ANY_CARD_LENGHT
  }


}
