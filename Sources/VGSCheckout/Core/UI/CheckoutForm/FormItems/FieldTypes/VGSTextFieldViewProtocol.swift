//
//  VGSTextFieldViewProtocol.swift
//  VGSCheckout

import Foundation

internal protocol VGSTextFieldViewProtocol: AnyObject {
	var placeholderView: VGSPlaceholderFieldView {get}
	var textField: VGSTextField {get}
    var errorLabel: UILabel {get}
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
			placeholderView.hintComponentView.accessory = .none
		case .invalid:
			placeholderView.hintComponentView.accessory = .invalid
		case .disabled:
			placeholderView.hintComponentView.accessory = .none
		}
	}

	/// Update styles with ui theme.
	/// - Parameter uiTheme: `VGSCheckoutThemeProtocol` object, ui theme.
	func updateStyle(with uiTheme: VGSCheckoutThemeProtocol) {
		textField.textColor = uiTheme.textFieldTextColor
		textField.font = uiTheme.textFieldTextFont
		print("textField.fieldType: \(textField)")
		textField.adjustsFontForContentSizeCategory = true
		placeholderView.hintLabel.textColor = uiTheme.textFieldHintTextColor
		placeholderView.hintLabel.font = uiTheme.textFieldHintTextFont
	}
}

internal enum VGSCheckoutFormValidationState {
	case inactive
	case focused
	case valid
	case invalid
	case disabled
}
