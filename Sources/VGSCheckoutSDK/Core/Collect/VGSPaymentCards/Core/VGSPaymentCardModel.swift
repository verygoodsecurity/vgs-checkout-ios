//
//  VGSCheckoutSDKCardModel.swift
//  VGSCheckoutSDK
//
//  Created by Dima on 09.07.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// :nodoc: Payment Card Model Protocol
internal protocol VGSCheckoutPaymentCardModelProtocol {
  var brand: VGSCheckoutPaymentCards.CardBrand { get }
  var name: String { get set }
  var regex: String { get set }
  var formatPattern: String { get set }
  var cardNumberLengths: [Int] { get set }
  var cvcLengths: [Int] { get set }
  var checkSumAlgorithm: VGSCheckoutCheckSumAlgorithmType? { get set }
  var brandIcon: UIImage? { get set }
  var cvcIcon: UIImage? { get set }
}

/// An object representing Payment Card
internal struct VGSCheckoutPaymentCardModel: VGSCheckoutPaymentCardModelProtocol {
  
  /// Payment Card Brand
	internal let brand: VGSCheckoutPaymentCards.CardBrand
  
  /// Payment Card Name
	internal var name: String
  
  /// Regex Pattern required to detect Payment Card Brand
	internal var regex: String
  
  /// Valid Card Number Lengths
	internal var cardNumberLengths: [Int]
  
  /// Valid Card CVC/CVV Lengths. For most brands valid cvc lengths is [3], while for Amex is [4].  For unknown brands can be set as [3, 4]
	internal var cvcLengths: [Int]
  
  /// Check sum validation algorithm. For most brands  card number can be validated by `VGSCheckoutCheckSumAlgorithmType.luhn` algorithm. If `none` - result of Checksum Algorithm validation will be `true`.
	internal var checkSumAlgorithm: VGSCheckoutCheckSumAlgorithmType?
  
  /// Payment Card Number visual format pattern.
  /// - Note: format pattern length limits input length.
	internal var formatPattern: String
  
  /// Image, associated with Payment Card Brand.
	internal var brandIcon: UIImage?
  
  /// Image, associated with CVC for Payment Card Brand.
	internal var cvcIcon: UIImage?
  
  init(brand: VGSCheckoutPaymentCards.CardBrand) {
    self.brand = brand
    self.name = brand.defaultName
    self.regex = brand.defaultRegex
    self.cardNumberLengths = brand.defaultCardLengths
    self.cvcLengths = brand.defaultCVCLengths
    self.checkSumAlgorithm = brand.defaultCheckSumAlgorithm
    self.brandIcon = brand.defaultBrandIcon
    self.formatPattern = brand.defaultFormatPattern
    self.cvcIcon = brand.defaultCVCIcon
  }
}
