//
//  VGSCheckoutSDKDefaultUITheme.swift
//  VGSCheckoutSDK
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Default Checkout UI Theme settings.
public struct VGSCheckoutDefaultTheme: VGSCheckoutThemeProtocol {

  /// Initializer.
  public init() {}
  
  /// The textfield’s background color. Default is `.clear`.
  public var textFieldBackgroundColor: UIColor = .clear

	/// The textfield’s border background color. Default is `.systemGray`.
  public var textFieldBorderColor: UIColor = .systemGray

	/// The text color of the textfield. Default is `.vgsInputBlackTextColor` (black).
  public var textFieldTextColor: UIColor = .vgsInputBlackTextColor

	/// The textfield’s error color. Default is `.systemRed`.
  public var textFieldErrorColor: UIColor = .systemRed

  /// The textfield’s focus color. Default is `.systemBlue`.
  public var textFieldFocusedColor: UIColor = .systemBlue

	/// The font of the textfield. Default is `.body` with `.medium` weight.
	public var textFieldTextFont: UIFont = .vgsPreferredFont(forTextStyle: .body, weight: .medium, maximumPointSize: 22)

	/// The text color of the textfield hint (above the text field). Default is `.vgsSystemGray2Color` (black).
	public var textFieldHintTextColor: UIColor = .vgsSystemGray2Color

	/// The font of the textfield hint (above the text field). Default is `.caption1`.
	public var textFieldHintTextFont: UIFont = .vgsPreferredFont(forTextStyle: .caption1, maximumPointSize: 24)

	/// The view's background color. Default is `.vgsSystemBackground` (white).
  public var checkoutViewBackgroundColor: UIColor = .vgsSystemBackground
  
  /// The section view's background color. Default is `.vgsSystemBackground` (white).
  public var checkoutSectionViewBackgroundColor: UIColor = .vgsSectionBackgroundColor

	/// The font of the section title. Default is `.title3` with `.bold` weight.
	public var checkoutFormSectionTitleFont: UIFont = .vgsPreferredFont(forTextStyle: .title3, weight: .bold, maximumPointSize: 26)

	/// The text color of the section title. Default is `.vgsSectionTitleColor`.
	public var checkoutFormSectionTitleColor: UIColor = .vgsSectionTitleColor

	/// The font of the error label. Default is `.caption2`.
  public var textFieldErrorLabelFont: UIFont = .vgsPreferredFont(forTextStyle: .caption2, maximumPointSize: 16)
  
  /// Submit button attributes

	/// The background color of the submit button. Default is `.systemBlue`.
  public var checkoutSubmitButtonBackgroundColor: UIColor = UIColor.systemBlue

	/// The background color of the submit button on success. Default is `.systemGreen`.
  public var checkoutSubmitButtonSuccessBackgroundColor: UIColor = .systemGreen

	/// The text color of the submit button title. Default is `.lightText`.
	public var checkoutSubmitButtonTitleColor: UIColor = .white

	/// The font of the submit button title. Default is `.callout` with `.regular` weight.
	public var checkoutSubmitButtonTitleFont: UIFont = .vgsPreferredFont(forTextStyle: .callout, weight: .semibold, maximumPointSize: 25)

	/// The background color of the checkbox for unselected state. Default is `.vgsSystemGray2Color`.
	public var checkoutCheckboxUnselectedColor: UIColor = UIColor.systemBlue

	/// The background color of the checkbox for selected state. Default is `.systemBlue`.
	public var checkoutCheckboxSelectedColor: UIColor = UIColor.systemBlue

	/// The checkmark tint color in checkbox. Default is `.white`.
	public var checkoutCheckmarkTintColor: UIColor = .white

	/// The text color of the hint in checkbox. Default is `.vgsInputBlackTextColor`.
	public var checkoutCheckboxHintColor: UIColor = .vgsInputBlackTextColor

	/// The font of the hint in checkbox. Default is `.callout`.
	public var checkoutCheckboxHintFont: UIFont = .preferredFont(forTextStyle: .callout)

		/// The background color of the payment option item.
	public	var checkoutPaymentOptionBackgroundColor: UIColor = .vgsPaymentOptionBackgroundColor

		/// The text color of the card holder title in saved card item.
	public var checkoutSavedCardCardholderTitleColor: UIColor = .vgsInputBlackTextColor

		/// The text color of the card holder title in saved card item in selected state.
	public var checkoutSavedCardCardholderSelectedTitleColor: UIColor = .systemBlue

		/// The text font of the card holder title in saved card item. Default is `.caption1` with `.semibold` weight.
	public var checkoutSavedCardCardholderTitleFont: UIFont = .vgsPreferredFont(forTextStyle: .caption1, weight: .semibold, maximumPointSize: 18)

		/// The text color of the last 4 and exp date in saved card item.
	public	var checkoutSavedCardDetailsTitleColor: UIColor = .vgsSystemGrayColor

		/// The text color of the last 4 and exp date in saved card item in selected state.
	public	var checkoutSavedCardDetailsSelectedTitleColor: UIColor = .vgsSystemGrayColor

		/// The text font of the of the last 4 and exp date in saved card item. Default is `.callout` with `.semibold` weight.
	public	var checkoutSavedCardDetailsTitleFont: UIFont = .vgsPreferredFont(forTextStyle: .callout, weight: .medium, maximumPointSize: 16)

		/// The border color of the saved card item when selected.
	public	var checkoutSavedCardSelectedBorderColor: UIColor = .systemBlue

		/// The text color for new card payment option title.
	public	var checkoutPaymentOptionNewCardTitleColor: UIColor = .systemBlue

		/// The font for new card payment option title. Default is `.callout` with `.semibold` weight.
	public	var checkoutPaymentOptionNewCardTitleFont: UIFont = .vgsPreferredFont(forTextStyle: .callout, weight: .semibold, maximumPointSize: 18)

		/// The background color of the payment option checkbox for unselected state.
	public	var checkoutPaymentOptionCheckboxUnselectedColor: UIColor = UIColor.vgsSystemGrayColor

		/// The background color of the payment option checkbox for selected state.
	public	var checkoutPaymentOptionCheckboxSelectedColor: UIColor = UIColor.systemBlue

		/// The checkmark tint color in the payment option checkbox.
	public	var checkoutPaymentOptionCheckmarkTintColor: UIColor = .white
}
