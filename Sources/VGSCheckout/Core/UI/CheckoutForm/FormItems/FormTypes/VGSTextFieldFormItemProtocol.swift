//
//  VGSTextFieldFormItemProtocol.swift
//  VGSCheckout

import Foundation

internal protocol VGSTextFieldFormItemProtocol: AnyObject {
	var formItemView: VGSPlaceholderFormItemView {get}
	var textField: VGSTextField {get}
	var fieldType: VGSAddCardFormFieldType {get}

	func updateUI(for validationState: VGSCheckoutFormValidationState)
}

/// TODO: Move to base class?
extension VGSTextFieldFormItemProtocol {

	// MARK: - Interface

	/// Update UI.
	/// - Parameter validationState: `VGSCheckoutFormValidationState` object, form validation state.
	func updateUI(for validationState: VGSCheckoutFormValidationState) {
		switch validationState {
		case .focused, .inactive, .valid:
			formItemView.hintComponentView.accessory = .none
		case .invalid:
			formItemView.hintComponentView.accessory = .invalid
		case .disabled:
			formItemView.hintComponentView.accessory = .none
		}
	}

	/// Update styles with ui theme.
	/// - Parameter uiTheme: `VGSCheckoutThemeProtocol` object, ui theme.
	func updateStyle(with uiTheme: VGSCheckoutThemeProtocol) {
		textField.textColor = uiTheme.textFieldTextColor
		textField.font = uiTheme.textFieldTextFont
		textField.adjustsFontForContentSizeCategory = true
		formItemView.hintLabel.textColor = uiTheme.textFieldHintTextColor
		formItemView.hintLabel.font = uiTheme.textFieldHintTextFont
	}
}

internal enum VGSCheckoutFormValidationState {
	case inactive
	case focused
	case valid
	case invalid
	case disabled
}
