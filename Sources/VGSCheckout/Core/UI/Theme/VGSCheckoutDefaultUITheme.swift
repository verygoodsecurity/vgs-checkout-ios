//
//  VGSCheckoutDefaultUITheme.swift
//  VGSCheckout
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Default Checkout UI Theme settings.
public struct VGSCheckoutDefaultTheme: VGSCheckoutThemeProtocol {

  /// The textfield’s background color. Default is `.vgsSystemBackground`.
  public var textFieldBackgroundColor: UIColor = .vgsSystemBackground

	/// The textfield’s border background color. Default is `.systemGray`.
  public var textFieldBorderColor: UIColor = .systemGray

	/// The text color of the textfield. Default is `.vgsInputBlackTextColor` (black).
  public var textFieldTextColor: UIColor = .vgsInputBlackTextColor

	/// The textfield’s error color. Default is `.systemRed`.
  public var textFieldErrorLabelColor: UIColor = .systemRed

    /// The textfield’s focus color. Default is `.systemBlue`.
    public var textFieldFocusedColor: UIColor = .systemBlue

	/// The font of the textfield. Default is `.body` with `.medium` weight.
	public var textFieldTextFont: UIFont = .vgsPreferredFont(forTextStyle: .body, weight: .medium)

	/// The text color of the textfield hint (above the text field). Default is `.vgsTextFieldHintTextColor` (black).
	public var textFieldHintTextColor: UIColor = .vgsTextFieldHintTextColor

	/// The font of the textfield hint (above the text field). Default is `.caption1` with `.semibold` weight.
	public var textFieldHintTextFont: UIFont = .vgsPreferredFont(forTextStyle: .caption1, weight: .semibold)

	/// The view's background color. Default is `.vgsSystemBackground` (white).
  public var checkoutViewBackgroundColor: UIColor = .vgsSystemBackground

	/// The font of the section title. Default is `.title3` with `.bold` weight.
	public var checkoutFormSectionTitleFont: UIFont = .vgsPreferredFont(forTextStyle: .title3, weight: .bold)

	/// The text color of the section title. Default is `.vgsSectionTitleColor`.
	public var checkoutFormSectionTitleColor: UIColor = .vgsSectionTitleColor

	/// The font of the error label. Default is `.caption2`.
  public var textFieldErrorLabelFont: UIFont = .preferredFont(forTextStyle: .caption2)

	/// The text color of the error label. Default is `.systemRed`.
  public var textFieldErrorLabelTextColor: UIColor = .systemRed
  
  /// Submit button attributes

	/// The background color of the submit button. Default is `.systemBlue`.
  public var checkoutSubmitButtonBackgroundColor: UIColor = UIColor.systemBlue

	/// The background color of the submit button on success. Default is `.systemGreen`.
  public var checkoutSubmitButtonSuccessBackgroundColor: UIColor = .systemGreen

	/// The text color of the submit button title. Default is `.lightText`.
	public var checkoutSubmitButtonTitleColor: UIColor = .white

	/// The font of the submit button title. Default is `.title3` with `.bold` weight.
	public var checkoutSubmitButtonTitleFont: UIFont = .vgsPreferredFont(forTextStyle: .title3, weight: .bold)
}
