//
//  VGSTextFieldFormItemProtocol.swift
//  VGSCheckout

import Foundation

internal protocol VGSTextFieldViewProtocol: AnyObject {
	var fieldView: VGSPlaceholderFormItemView {get}
	var textField: VGSTextField {get}
	var fieldType: VGSAddCardFormFieldType {get}

	func updateUI(for validationState: VGSCheckoutFormValidationState)
}

/// TODO: Move to base class?
extension VGSTextFieldViewProtocol {

	// MARK: - Interface

	/// Update UI.
	/// - Parameter validationState: `VGSCheckoutFormValidationState` object, form validation state.
	func updateUI(for validationState: VGSCheckoutFormValidationState) {
		switch validationState {
		case .focused, .inactive, .valid:
			fieldView.hintComponentView.accessory = .none
		case .invalid:
			fieldView.hintComponentView.accessory = .invalid
		case .disabled:
			fieldView.hintComponentView.accessory = .none
		}
	}

	/// Update styles with ui theme.
	/// - Parameter uiTheme: `VGSCheckoutThemeProtocol` object, ui theme.
	func updateStyle(with uiTheme: VGSCheckoutThemeProtocol) {
		textField.textColor = uiTheme.textFieldTextColor
		textField.font = uiTheme.textFieldTextFont
		textField.adjustsFontForContentSizeCategory = true
		fieldView.hintLabel.textColor = uiTheme.textFieldHintTextColor
		fieldView.hintLabel.font = uiTheme.textFieldHintTextFont
	}
}

internal enum VGSCheckoutFormValidationState {
	case inactive
	case focused
	case valid
	case invalid
	case disabled
}
