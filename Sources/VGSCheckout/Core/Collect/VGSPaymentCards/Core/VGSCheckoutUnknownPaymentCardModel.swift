//
//  VGSUnknownPaymentCardModel.swift
//  VGSCheckout
//
//  Created by Dima on 09.07.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// An object representing Unknown Payment Cards - cards not defined in the SDK. Object is used when validation for`CardBrand.unknown` is set as `true`. Check `VGSValidationRulePaymentCard` for more details. Validation attributes can be edited through ``VGSPaymentCards.unknown` model.
public struct VGSCheckoutUnknownPaymentCardModel {
  
  internal let name = VGSCheckoutPaymentCards.CardBrand.unknown.defaultName
  
  /// Regex validating that input contains digits only.
  public let regex: String = VGSCheckoutPaymentCards.CardBrand.unknown.defaultRegex

  /// Valid Unknown Card Numbers Lengths
  public var cardNumberLengths: [Int] = VGSCheckoutPaymentCards.CardBrand.unknown.defaultCardLengths
  
   /// Valid Unknown Card CVC/CVV Lengths. For most brands valid cvc lengths is [3], while for Amex is [4].  For unknown brands can be set as [3, 4]
  public var cvcLengths: [Int] = VGSCheckoutPaymentCards.CardBrand.unknown.defaultCVCLengths
  
  /// Check sum validation algorithm. For most brands  card number can be validated by `CheckSumAlgorithmType.luhn` algorithm. If `none` - result of Checksum Algorithm validation will be `true`.
  public var checkSumAlgorithm: VGSCheckoutCheckSumAlgorithmType? = VGSCheckoutPaymentCards.CardBrand.unknown.defaultCheckSumAlgorithm
  
  /// Unknown Payment Card Numbers visual format pattern. NOTE: format pattern length limits input length.
  public var formatPattern: String = VGSCheckoutPaymentCards.CardBrand.unknown.defaultFormatPattern

   /// Image, associated with Unknown Payment Card Brands.
  public var brandIcon: UIImage? = VGSCheckoutPaymentCards.CardBrand.unknown.defaultBrandIcon
  
  /// Image, associated with CVC for Unknown Payment Card Brands.
  public var cvcIcon: UIImage? = VGSCheckoutPaymentCards.CardBrand.unknown.defaultCVCIcon
}
