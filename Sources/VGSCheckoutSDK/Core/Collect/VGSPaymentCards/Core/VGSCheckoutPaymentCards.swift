//
//  VGSCheckoutSDKPaymentCards.swift
//  VGSCheckoutSDK
//
//  Created by Dima on 09.07.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation

/// Class responsible for storing and managing Payment Cards in SDK.
/// - Contains editable defined Payment Cards Models
/// - Allows to add Custom Payment Cards Models
/// - Allows to edit Unknown Payment Cards Models(brands not defined by SDK and Developer)
public class VGSCheckoutPaymentCards {
    
  private init() {}
    
  // MARK: - CardBrand Enum Cases

  /// Supported card brands
  public enum CardBrand: Equatable {
      /// ELO
      case elo
      /// Visa Electron
      case visaElectron
      /// Maestro
      case maestro
      /// Forbrugsforeningen
      case forbrugsforeningen
      /// Dankort
      case dankort
      /// Visa
      case visa
      /// Mastercard
      case mastercard
      /// American Express
      case amex
      /// Hipercard
      case hipercard
      /// Diners Club
      case dinersClub
      /// Discover
      case discover
      /// UnionPay
      case unionpay
      /// JCB
      case jcb
      /// Not supported card brand - "unknown"
      case unknown
      /// Custom Payment Card Brand. Should have unique `brandName`.
      case custom(brandName: String)
  }
  
    // MARK: - Payment Card Models
  
    ///  Elo Payment Card Model
    public static var elo = VGSCheckoutPaymentCardModel(brand: .elo)
    ///  Visa Electron Payment Card Model
    public static var visaElectron = VGSCheckoutPaymentCardModel(brand: .visaElectron)
    ///  Maestro Payment Card Model
    public static var maestro = VGSCheckoutPaymentCardModel(brand: .maestro)
    ///  Forbrugsforeningen Payment Card Model
    public static var forbrugsforeningen = VGSCheckoutPaymentCardModel(brand: .forbrugsforeningen)
    ///  Dankort Payment Card Model
    public static var dankort = VGSCheckoutPaymentCardModel(brand: .dankort)
    ///  Elo Payment Card Model
    public static var visa = VGSCheckoutPaymentCardModel(brand: .visa)
    ///  Master Card Payment Card Model
    public static var masterCard = VGSCheckoutPaymentCardModel(brand: .mastercard)
    ///  Amex Payment Card Model
    public static var amex = VGSCheckoutPaymentCardModel(brand: .amex)
    ///  Hipercard Payment Card Model
    public static var hipercard = VGSCheckoutPaymentCardModel(brand: .hipercard)
    ///  DinersClub Payment Card Model
    public static var dinersClub = VGSCheckoutPaymentCardModel(brand: .dinersClub)
    ///  Discover Payment Card Model
    public static var discover = VGSCheckoutPaymentCardModel(brand: .discover)
    ///  UnionPay Payment Card Model
    public static var unionpay = VGSCheckoutPaymentCardModel(brand: .unionpay)
    ///  JCB Payment Card Model
    public static var jcb = VGSCheckoutPaymentCardModel(brand: .jcb)
  
    // MARK: - Unknown Payment Card Model
  
    ///  Unknown Brand Payment Card Model.  Can be used for specifing cards details when `VGSValidationRulePaymentCard` requires validating `CardBrand.unknown` cards.
    public static var unknown = VGSCheckoutUnknownPaymentCardModel()
  
    // MARK: - Custom Payment Card Models
  
    /// Array of Custom Payment Card Models.
    /// - Note: the order has impact on which card brand should be detected first by `VGSCheckoutPaymentCardModel.regex`.
    public static var cutomPaymentCardModels = [VGSCheckoutCustomPaymentCardModel]()

    /// An array of valid Card Brands, could include custom and default brands. If not set, will use `availableCardBrands` array instead.
    /// - Note: the order has impact on which card brand should be detected first by `VGSCheckoutPaymentCardModel.regex`.
    public static var validCardBrands: [VGSCheckoutPaymentCardModelProtocol]?

    /// Array of Available Cards.
    /// -  Note: the order has impact on which card brand should be detected first by `VGSCheckoutPaymentCardModel.regex`.
    internal static var defaultCardModels: [VGSCheckoutPaymentCardModelProtocol] {
                                            return  [ elo,
                                                      visaElectron,
                                                      maestro,
                                                      forbrugsforeningen,
                                                      dankort,
                                                      visa,
                                                      masterCard,
                                                      amex,
                                                      hipercard,
                                                      dinersClub,
                                                      discover,
                                                      unionpay,
                                                      jcb ] }
      
    /// Array of CardBrands that should be supported by SDK.
    ///  Will return an array of `validCardBrands` when it's not nil.
    ///  Will return All Card Models(Custom + Default) if specific `validCardBrands` is nil.
    /// - Note: the order has impact on which card brand should be detected first by  `VGSCheckoutPaymentCardModel.regex`
     internal static var availableCardBrands: [VGSCheckoutPaymentCardModelProtocol] {
      /// Check if uset setup an array of specific CardBrands that should be supported by SDK.
      if let userValidBrands = validCardBrands {
        return userValidBrands
      }
      /// If no specific valid brands, return All Card Models(Custom + Default)
      return Self.cutomPaymentCardModels + Self.defaultCardModels
    }
}

// MARK: - Attributes
public extension VGSCheckoutPaymentCards.CardBrand {
  
    /// String representation of `VGSCheckoutPaymentCards.CardBrand` enum values.
    var stringValue: String {
      return VGSCheckoutPaymentCards.getCardModelFromAvailableModels(brand: self)?.name ?? VGSCheckoutPaymentCards.unknown.name
    }

    /// Returns array with valid card number lengths for specific `VGSCheckoutPaymentCards.CardBrand`
    var cardLengths: [Int] {
      return VGSCheckoutPaymentCards.getCardModelFromAvailableModels(brand: self)?.cardNumberLengths ?? VGSCheckoutPaymentCards.unknown.cardNumberLengths
    }
  
    /// :nodoc:  Equatable protocol
    static func == (lhs: Self, rhs: Self) -> Bool {
      switch (lhs, rhs) {
      case (.visa, .visa),
           (.elo, .elo),
           (.visaElectron, .visaElectron),
           (.maestro, .maestro),
           (.forbrugsforeningen, .forbrugsforeningen),
           (.dankort, .dankort),
           (.mastercard, .mastercard),
           (.amex, .amex),
           (.hipercard, .hipercard),
           (.dinersClub, .dinersClub),
           (.discover, .discover),
           (.unionpay, .unionpay),
           (.jcb, .jcb),
           (.unknown, .unknown): return true
      case (.custom(let lhsString), .custom(let rhsString)):
        return lhsString == rhsString
      default:
        return false
      }
    }
}

public extension VGSCheckoutPaymentCards {

		///no:doc
    static func getCardModelFromAvailableModels(brand: VGSCheckoutPaymentCards.CardBrand) -> VGSCheckoutPaymentCardModelProtocol? {
      return Self.availableCardBrands.first(where: { $0.brand == brand})
    }

		///no:doc
    static func detectCardBrandFromAvailableCards(input: String) -> VGSCheckoutPaymentCards.CardBrand {
      for cardModel in Self.availableCardBrands {
          let predicate = NSPredicate(format: "SELF MATCHES %@", cardModel.regex)
          if predicate.evaluate(with: input) == true {
            return cardModel.brand
          }
        }
        return .unknown
    }
}
