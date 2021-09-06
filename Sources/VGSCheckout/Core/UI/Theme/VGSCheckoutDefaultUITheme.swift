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

  /// The textfield’s background color. Default is `.systemGray`.
  public var textFieldBackgroundColor: UIColor = .vgsSystemBackground

	/// The textfield’s border background color. Default is `.systemGray`.
  public var textFieldBorderColor: UIColor = .systemGray

	/// The text color of the textfield. Default is `.vgsInputBlackTextColor` (black).
  public var textFieldTextColor: UIColor = .vgsInputBlackTextColor

	/// The textfield’s error color. Default is `.systemRed`.
  public var textFieldErrorColor: UIColor = .systemRed

    /// The textfield’s focus color. Default is `.systemBlue`.
    public var textFieldFocusColor: UIColor = .systemBlue

	/// The font of the textfield. Default is `.body`.
  public var textFieldTextFont: UIFont = UIFont.preferredFont(forTextStyle: .callout)

	/// The text color of the textfield hint (above the text field). Default is `.vgsInputBlackTextColor` (black).
	public var textFieldHintTextColor: UIColor = .vgsInputBlackTextColor

	/// The font of the textfield hint (above the text field). Default is `.body`.
	public var textFieldHintTextFont: UIFont = UIFont.preferredFont(forTextStyle: .caption1)

	/// The view's background color. Default is `.vgsSystemBackground` (white).
  public var checkoutViewBackgroundColor: UIColor = .vgsSystemBackground

	/// The font of the section title. Default is `.headline`.
	public var checkoutFormSectionTitleFont: UIFont = .preferredFont(forTextStyle: .body)

	/// The font of the error label. Default is `.footnote`.
  public var textFieldErrorLabelFont: UIFont = .preferredFont(forTextStyle: .caption2)

	/// The text color of the error label. Default is `.systemRed`.
  public var textFieldErrorLabelTextColor: UIColor = .systemRed
  
  /// Submit button attributes

	/// The background color of the submit button. Default is `.purple` with alpha.
  public var checkoutSubmitButtonBackgroundColor: UIColor = UIColor.systemBlue

	/// The background color of the submit button on success. Default is `.systemGreen`.
  public var checkoutSubmitButtonSuccessBackgroundColor: UIColor = .systemGreen

	/// The text color of the submit button title. Default is `.light` with alpha.
  public var checkoutSubmitButtonTitleColor: UIColor = UIColor.lightText.withAlphaComponent(0.6)

	/// The font of the submit button title. Default is `.callout`.
  public var checkoutSubmitButtonTitleFont: UIFont = .preferredFont(forTextStyle: .callout)
}
