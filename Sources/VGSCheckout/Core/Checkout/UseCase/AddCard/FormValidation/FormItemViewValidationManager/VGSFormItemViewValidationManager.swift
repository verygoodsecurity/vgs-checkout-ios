//
//  VGSFormItemViewValidationManager.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds logic for updating form item views.
internal final class VGSFormItemViewValidationManager {

	/// Handle CardNumber field state during editing.
	internal func updateCardNumberFormItemOnEditingTextField(_ field: VGSTextField, formItem: VGSTextFieldViewProtocol) {

		let isValidLength = self.isInputRequiredLengthInFormItem(formItem)
		// NOTE: same first digits in card number can be valid for 13, 16 and 19 digits
		let isValidState = field.state.isValid

		switch (isValidLength, isValidState) {
		case (false, _):
			formItem.updateUI(for: .focused)
		case (true, true):
			formItem.updateUI(for: .valid)
		case (true, false):
			formItem.updateUI(for: .invalid)
		}
	}

	/// Handle Any field state during editing.
	internal func updateAnyFormItemOnEditingTextField(_ field: VGSTextField, formItem: VGSTextFieldViewProtocol) {
		let isValidLength = self.isInputRequiredLengthInFormItem(formItem)
		let isValidState = field.state.isValid

		switch (isValidLength, isValidState) {
		case (false, _):
			formItem.updateUI(for: .focused)
		case (true, true):
			formItem.updateUI(for: .valid)
		case (true, false):
			formItem.updateUI(for: .invalid)
		}
	}

	/// Handle Any field state after it finish editing.
	internal func updateAnyFormItemOnEndEditTextField(_ field: VGSTextField, formItem: VGSTextFieldViewProtocol) {
		let state = field.state

		switch (state.isDirty, state.isValid) {
		case (false, _):
			formItem.updateUI(for: .inactive)
		case (true, false):
			formItem.updateUI(for: .invalid)
			return
		case (true, true):
			formItem.updateUI(for: .focused)
		}
	}

	/// Check if input has required length.
	/// - Parameter formItem: `VGSTextFieldFormItemProtocol` object, form item.
	/// - Returns: `Bool` object, `true` if item has valid length.
	internal func isInputRequiredLengthInFormItem(_ formItem: VGSTextFieldViewProtocol) -> Bool {

		let fieldValidator = VGSFormFieldsValidatorFactory.provideFieldValidator(for: formItem.fieldType)
		return fieldValidator.isTextFieldInputComplete(formItem.textField)
	}
}
