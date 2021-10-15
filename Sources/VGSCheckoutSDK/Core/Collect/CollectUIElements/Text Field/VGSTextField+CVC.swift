//
//  VGSTextField+patternFormat.swift
//  VGSCheckoutSDK
//

import Foundation

/// Handle cvc field type
internal extension VGSTextField {
    
  func getCVCValidationRules(cardBrand: VGSCheckoutPaymentCards.CardBrand) -> VGSValidationRuleSet {
      var cvcLengths = [Int]()
    if let cardModel = VGSCheckoutPaymentCards.getCardModelFromAvailableModels(brand: cardBrand) {
        cvcLengths = cardModel.cvcLengths
      } else {
        cvcLengths = VGSCheckoutPaymentCards.unknown.cvcLengths
      }
      return VGSValidationRuleSet(rules: [
        VGSValidationRulePattern(pattern: "\\d*$", error: VGSValidationErrorType.pattern.rawValue),
        VGSValidationRuleLengthMatch(lengths: cvcLengths, error: VGSValidationErrorType.lengthMathes.rawValue)
      ])
    }
}
