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

/// Defines Payment options UI Theme.
internal protocol VGSCheckoutPaymentOptionsThemeProtocol {

	/// The background color of the saved card item.
	var checkoutPaymentOptionBackgroundColor: UIColor {get set}

	/// The text color of the card holder title in saved card item.
	var checkoutSavedCardCardholderTitleColor: UIColor {get set}

	/// The text color of the card holder title in saved card item in selected state.
	var checkoutSavedCardCardholderSelectedTitleColor: UIColor {get set}

	/// The text font of the card holder title in saved card item.
	var checkoutSavedCardCardholderTitleFont: UIFont {get set}

	/// The text color of the last 4 and exp date in saved card item.
	var checkoutSavedCardDetailsTitleColor: UIColor {get set}

	/// The text color of the last 4 and exp date in saved card item in selected state.
	var checkoutSavedCardDetailsSelectedTitleColor: UIColor {get set}

	/// The text font of the of the last 4 and exp date in saved card item.
	var checkoutSavedCardDetailsTitleFont: UIFont {get set}

	/// The border color of the saved card item when selected.
	var checkoutSavedCardSelectedBorderColor: UIColor {get set}

	/// The text color for new card payment option title.
	var checkoutPaymentOptionNewCardTitleColor: UIColor {get set}

	/// The font for new card payment option title.
	var checkoutPaymentOptionNewCardTitleFont: UIFont {get set}

	/// The background color of the payment option checkbox for unselected state.
	var checkoutPaymentOptionCheckboxUnselectedColor: UIColor { get set }

	/// The background color of the payment option checkbox for selected state.
	var checkoutPaymentOptionCheckboxSelectedColor: UIColor { get set }

	/// The checkmark tint color in the payment option checkbox.
	var checkoutPaymentOptionCheckmarkTintColor: UIColor { get set }
}

//
//public extension VGSCheckoutDefaultTheme {
//	/// The background color of the payment option item.
//	var checkoutPaymentOptionBackgroundColor: UIColor = .vgsPaymentOptionBackgroundColor
//
//	/// The text color of the card holder title in saved card item.
//	var checkoutSavedCardCardholderTitleColor: UIColor = .vgsInputBlackTextColor
//
//	/// The text color of the card holder title in saved card item in selected state.
//	var checkoutSavedCardCardholderSelectedTitleColor: UIColor = .systemBlue
//
//	/// The text font of the card holder title in saved card item. Default is `.caption1` with `.semibold` weight.
//	var checkoutSavedCardCardholderTitleFont: UIFont = .vgsPreferredFont(forTextStyle: .caption1, weight: .semibold, maximumPointSize: 18)
//
//	/// The text color of the last 4 and exp date in saved card item.
//	var checkoutSavedCardDetailsTitleColor: UIColor = .vgsSystemGrayColor
//
//	/// The text color of the last 4 and exp date in saved card item in selected state.
//	var checkoutSavedCardDetailsSelectedTitleColor: UIColor = .vgsSystemGrayColor
//
//	/// The text font of the of the last 4 and exp date in saved card item. Default is `.callout` with `.semibold` weight.
//	var checkoutSavedCardDetailsTitleFont: UIFont = .vgsPreferredFont(forTextStyle: .callout, weight: .medium, maximumPointSize: 16)
//
//	/// The border color of the saved card item when selected.
//	var checkoutSavedCardSelectedBorderColor: UIColor = .systemBlue
//
//	/// The text color for new card payment option title.
//	var checkoutPaymentOptionNewCardTitleColor: UIColor = .systemBlue
//
//	/// The font for new card payment option title. Default is `.callout` with `.semibold` weight.
//	var checkoutPaymentOptionNewCardTitleFont: UIFont = .vgsPreferredFont(forTextStyle: .callout, weight: .semibold, maximumPointSize: 18)
//
//	/// The background color of the payment option checkbox for unselected state.
//	var checkoutPaymentOptionCheckboxUnselectedColor: UIColor = UIColor.vgsSystemGrayColor
//
//	/// The background color of the payment option checkbox for selected state.
//	var checkoutPaymentOptionCheckboxSelectedColor: UIColor = UIColor.systemBlue
//
//	/// The checkmark tint color in the payment option checkbox.
//	var checkoutPaymentOptionCheckmarkTintColor: UIColor = .white
//}
