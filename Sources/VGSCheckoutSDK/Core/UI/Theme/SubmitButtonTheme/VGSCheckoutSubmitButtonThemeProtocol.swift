//
//  VGSCheckoutSubmitButtonThemeProtocol.swift
//  VGSCheckoutSDK
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

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

/// Defines Checkout checkbox UI Theme.
public protocol VGSCheckoutCheckboxThemeProtocol {

	/// The background color of the checkbox for unselected state.
	var checkoutCheckboxUnselectedColor: UIColor { get set }

	/// The background color of the checkbox for selected state.
	var checkoutCheckboxSelectedColor: UIColor { get set }

	/// The checkmark tint color in checkbox.
	var checkoutCheckmarkTintColor: UIColor { get set }

	/// The text color of the hint in checkbox.
	var checkoutCheckboxHintColor: UIColor { get set }

	/// The font of the hint in checkbox.
	var checkoutCheckboxHintFont: UIFont { get set }
}
