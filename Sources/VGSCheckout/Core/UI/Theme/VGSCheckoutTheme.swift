//
//  VGSCheckoutTheme.swift
//  VGSCheckout

import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Defines basic UI Theme.
public protocol VGSCheckoutThemeProtocol: VGSCheckoutTextFieldThemeProtocol, VGSCheckoutViewThemeProtocol, VGSCheckoutErrorLabelThemeProtocol, VGSCheckoutSubmitButtonThemeProtocol {
  
}

/// Defines UI Theme for text field.
public protocol VGSCheckoutTextFieldThemeProtocol {

	/// Colors.

	/// The textfield’s background color. NOT USED!!!
  var textFieldBackgroundColor: UIColor { get set }

	/// The textfield’s border background color.
  var textFieldBorderColor: UIColor { get set }

	/// The textfield’s error border color.
  var textFieldBorderErrorColor: UIColor { get set }

	/// The text color of the textfield.
  var textFieldTextColor: UIColor { get set }

	/// The text color of the textfield placeholder. NOT USED!!!
  var textFieldPlaceholderColor: UIColor { get set }
  
  /// Fonts.

	/// The font of the textfield.
  var textFieldTextFont: UIFont { get set }

	/// The font of the textfield placeholder. NOT USED!!!
  var textFieldPlaceholderFont: UIFont { get set }
}

/// Defines Checkout main view UI Theme.
public protocol VGSCheckoutViewThemeProtocol {

	/// The view's background color. NOT USED!!!
  var checkoutViewBackgroundColor: UIColor { get set }

	/// The font of the section title.
	var checkoutFormSectionTitleFont: UIFont {get set}
}

/// Defines Checkout error label UI Theme.
public protocol VGSCheckoutErrorLabelThemeProtocol {

	/// The font of the error label.
  var checkoutErrorLabelFont: UIFont { get set }

	/// The text color of the error label.
  var checkoutErrorLabelTextColor: UIColor { get set }
}

/// Defines Checkout submit button UI Theme.
public protocol VGSCheckoutSubmitButtonThemeProtocol {

	/// The background color of the submit button.
  var checkoutSubmitButtonBackgroundColor: UIColor { get set }

	/// The background color of the submit button on success.
  var checkoutSubmitButtonSuccessBackgroundColor: UIColor { get set }

	/// The text color of the submit button title.
  var checkoutSubmitButtonTitleColor: UIColor { get set }

	/// The font of the submit button title.
  var checkoutSubmitButtonTitleFont: UIFont { get set }
}
