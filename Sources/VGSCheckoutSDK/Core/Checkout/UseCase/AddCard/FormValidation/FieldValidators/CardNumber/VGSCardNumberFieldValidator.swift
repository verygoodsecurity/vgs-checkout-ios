//
//  VGSCardNumberFieldValidator.swift
//  VGSCheckoutSDK

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

	internal func errorMessage(for textField: VGSTextField, fieldType: VGSAddCardFormFieldType) -> String? {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_number_invalid_error")
	}

	internal func emptyErrorMessage(for textField: VGSTextField, fieldType: VGSAddCardFormFieldType) -> String? {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_number_empty_error")
	}
}
