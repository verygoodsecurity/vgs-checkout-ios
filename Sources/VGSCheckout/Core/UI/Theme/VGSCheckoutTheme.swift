//
//  VGSCheckoutTheme.swift
//  VGSCheckout

import Foundation

#if canImport(UIKit)
import UIKit
#endif

public protocol VGSCheckoutThemeProtocol: VGSCheckoutTextFieldThemeProtocol, VGSCheckoutViewThemeProtocol, VGSCheckoutErrorLabelThemeProtocol, VGSCheckoutSubmitButtonThemeProtocol {
  
}

/// TextField Theme protocol
public protocol VGSCheckoutTextFieldThemeProtocol {
  /// Colors.
  var textFieldBackgroundColor: UIColor { get set }
  var textFieldBorderColor: UIColor { get set }
  var textFieldBorderErrorColor: UIColor { get set }

  var textFieldTextColor: UIColor { get set }
  var textFieldPlaceholderColor: UIColor { get set }
  
  /// Fonts.
  var textFieldTextFont: UIFont { get set }
  var textFieldPlaceholderFont: UIFont { get set }
}


/// Checkout main view Theme protocol
public protocol VGSCheckoutViewThemeProtocol {
  var checkoutViewBackgroundColor: UIColor { get set }
	var checkoutFormSectionTitle: UIFont {get set}
}

/// Checkout errorLabel Theme protocol
public protocol VGSCheckoutErrorLabelThemeProtocol {
  var checkoutErrorLabelFont: UIFont { get set }
  var checkoutErrorLabelTextColor: UIColor { get set }
}

/// Checkout Submit Button Theme protocol
public protocol VGSCheckoutSubmitButtonThemeProtocol {
  var checkoutSubmitButtonBackgroundColor: UIColor { get set }
  var checkoutSubmitButtonSuccessBackgroundColor: UIColor { get set }
  var checkoutSubmitButtonTitleColor: UIColor { get set }
  var checkoutSubmitButtonTitleFont: UIFont { get set }
}
