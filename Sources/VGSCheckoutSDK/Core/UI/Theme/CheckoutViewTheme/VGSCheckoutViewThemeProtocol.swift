//
//  VGSCheckoutViewThemeProtocol.swift
//  VGSCheckoutSDK
//


import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Defines Checkout main view UI Theme.
public protocol VGSCheckoutViewThemeProtocol {

  /// The view's background color.
  var checkoutViewBackgroundColor: UIColor { get set }

  /// The section view's background color.
  var checkoutSectionViewBackgroundColor: UIColor { get set }
  
  /// The font of the section title.
  var checkoutFormSectionTitleFont: UIFont {get set}

  /// The color of the section title.
  var checkoutFormSectionTitleColor: UIColor {get set}
}
