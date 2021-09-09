//
//  VGSCheckoutTheme.swift
//  VGSCheckout

import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Defines basic UI Theme.
public protocol VGSCheckoutThemeProtocol: VGSCheckoutTextFieldThemeProtocol, VGSCheckoutViewThemeProtocol, VGSCheckoutSubmitButtonThemeProtocol {
}

public protocol VGSCheckoutTextFieldThemeAdapterProtocol {

	func adapt(theme: VGSCheckoutTextFieldThemeProtocol, for state: VGSCheckoutFieldUIState) -> VGSCheckoutTextFieldViewUIAttributesProtocol
}

extension VGSCheckoutTextFieldThemeAdapterProtocol {
	public func adapt(theme: VGSCheckoutTextFieldThemeProtocol, for state: VGSCheckoutFieldUIState) -> VGSCheckoutTextFieldViewUIAttributesProtocol {
		switch state {
		case .initial, .valid:
			return VGSCheckoutTextFieldUIAttributes(textFieldBackgroundColor: theme.textFieldBackgroundColor,
																							textFieldBorderColor: theme.textFieldBorderColor,
																							textFieldHintTextColor: theme.textFieldHintTextColor,
																							textFieldTextColor: theme.textFieldTextColor,
																							textFieldTextFont: theme.textFieldTextFont,
																							textFieldHintTextFont: theme.textFieldHintTextFont,
																							textFieldErrorLabelTextColor: theme.textFieldErrorLabelColor,
																							textFieldErrorLabelFont: theme.textFieldErrorLabelFont)
		case .focused:
			return VGSCheckoutTextFieldUIAttributes(textFieldBackgroundColor: theme.textFieldBackgroundColor,
																							textFieldBorderColor: theme.textFieldBorderColor,
																							textFieldHintTextColor: theme.textFieldFocusedColor,
																							textFieldTextColor: theme.textFieldTextColor,
																							textFieldTextFont: theme.textFieldTextFont,
																							textFieldHintTextFont: theme.textFieldHintTextFont,
																							textFieldErrorLabelTextColor: theme.textFieldErrorLabelColor,
																							textFieldErrorLabelFont: theme.textFieldErrorLabelFont)

		default:
			return VGSCheckoutTextFieldUIAttributes(textFieldBackgroundColor: theme.textFieldBackgroundColor,
																							textFieldBorderColor: theme.textFieldBorderColor,
																							textFieldHintTextColor: theme.textFieldErrorLabelColor,
																							textFieldTextColor: theme.textFieldTextColor,
																							textFieldTextFont: theme.textFieldTextFont,
																							textFieldHintTextFont: theme.textFieldHintTextFont,
																							textFieldErrorLabelTextColor: theme.textFieldErrorLabelColor,
																							textFieldErrorLabelFont: theme.textFieldErrorLabelFont)
		}
	}
}

public protocol VGSCheckoutTextFieldViewUIAttributesProtocol {
	/// The textfield’s background color. NOT USED!!!
	var textFieldBackgroundColor: UIColor { get set }

	/// The textfield’s border background color.
	var textFieldBorderColor: UIColor { get set }


	/// The text color of the textfield hint (above the text field).
	var textFieldHintTextColor: UIColor { get set }

	/// The text color of the textfield.
	var textFieldTextColor: UIColor { get set }

	/// The text color of the error label.
	var textFieldErrorLabelTextColor: UIColor { get set }

	/// Fonts.

	/// The font of the textfield.
	var textFieldTextFont: UIFont { get set }

	/// The font of the textfield hint (above the text field).
	var textFieldHintTextFont: UIFont { get set }

	/// The font of the error label.
	var textFieldErrorLabelFont: UIFont { get set }
}

internal struct VGSCheckoutTextFieldUIAttributes: VGSCheckoutTextFieldViewUIAttributesProtocol {

	internal var textFieldBackgroundColor: UIColor

	internal var textFieldBorderColor: UIColor

	internal var textFieldHintTextColor: UIColor

	internal var textFieldTextColor: UIColor

	internal var textFieldTextFont: UIFont

	internal var textFieldHintTextFont: UIFont

	internal var textFieldErrorLabelTextColor: UIColor

	internal var textFieldErrorLabelFont: UIFont
}

/// Defines UI Theme for text field.
public protocol VGSCheckoutTextFieldThemeProtocol: VGSCheckoutTextFieldThemeAdapterProtocol {

	/// Colors.

	/// The textfield’s background color.
	var textFieldBackgroundColor: UIColor { get set }

	/// The textfield’s border background color.
	var textFieldBorderColor: UIColor { get set }

	/// The textfield’s focus state color.
	var textFieldFocusedColor: UIColor { get set }

	/// The text color of the textfield hint (above the text field).
	var textFieldHintTextColor: UIColor { get set }

	/// The text color of the textfield.
	var textFieldTextColor: UIColor { get set }

	/// The textfield’s error label color.
	var textFieldErrorLabelColor: UIColor { get set }

	/// Fonts.

	/// The font of the textfield.
	var textFieldTextFont: UIFont { get set }

	/// The font of the textfield hint (above the text field).
	var textFieldHintTextFont: UIFont { get set }

	/// The font of the error label.
	var textFieldErrorLabelFont: UIFont { get set }
}

/// Defines Checkout main view UI Theme.
public protocol VGSCheckoutViewThemeProtocol {

	/// The view's background color.
	var checkoutViewBackgroundColor: UIColor { get set }

	/// The font of the section title.
	var checkoutFormSectionTitleFont: UIFont {get set}

	/// The color of the section title.
	var checkoutFormSectionTitleColor: UIColor {get set}
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
