//
//  VGSFieldViewValidationManager.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds logic for updating form item views.
internal final class VGSFieldViewValidationManager {

	/// Handle CardNumber field state during editing.
	internal func updateCardNumberFieldViewOnEditingTextField(_ field: VGSTextField, fieldView: VGSTextFieldViewProtocol) {

		let isValidLength = self.isInputRequiredLengthInFieldView(fieldView)
		// NOTE: same first digits in card number can be valid for 13, 16 and 19 digits
		let isValidState = field.state.isValid

		switch (isValidLength, isValidState) {
		case (false, _):
            fieldView.updateUI(for: .focused)
		case (true, true):
            fieldView.updateUI(for: .valid)
		case (true, false):
            fieldView.updateUI(for: .invalid)
		}
	}

	/// Handle Any field state during editing.
	internal func updateAnyFieldViewOnEditingTextField(_ field: VGSTextField, fieldView: VGSTextFieldViewProtocol) {
		let isValidLength = self.isInputRequiredLengthInFieldView(fieldView)
		let isValidState = field.state.isValid

		switch (isValidLength, isValidState) {
		case (false, _):
            fieldView.updateUI(for: .focused)
		case (true, true):
            fieldView.updateUI(for:  .valid)
		case (true, false):
            fieldView.updateUI(for: .invalid)
		}
	}

	/// Handle Any field state after it finish editing.
	internal func updateAnyFieldViewOnEndEditTextField(_ field: VGSTextField, fieldView: VGSTextFieldViewProtocol) {
		let state = field.state

		switch (state.isDirty, state.isValid) {
		case (false, _):
			fieldView.updateUI(for: .initial)
            return
		case (true, false):
			fieldView.updateUI(for: .invalid)
			return
		case (true, true):
			fieldView.updateUI(for: .focused)
		}
	}

	/// Check if input has required length.
	/// - Parameter fieldView: `VGSTextFieldViewProtocol` object, form item.
	/// - Returns: `Bool` object, `true` if item has valid length.
	internal func isInputRequiredLengthInFieldView(_ fieldView: VGSTextFieldViewProtocol) -> Bool {

		let fieldValidator = VGSFormFieldsValidatorFactory.provideFieldValidator(for: fieldView.fieldType)
		return fieldValidator.isTextFieldInputComplete(fieldView.textField)
	}
}
