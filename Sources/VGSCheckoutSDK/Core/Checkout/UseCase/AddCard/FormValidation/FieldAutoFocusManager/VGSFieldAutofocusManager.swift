//
//  VGSFormAutofocusManager.swift
//  VGSCheckoutSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Encapsulates logic for autofocus feature.
internal class VGSFieldAutofocusManager {

	/// `VGSFieldViewsManager` object.
	internal let fieldViewsManager: VGSFieldViewsManager

	/// Initializer.
	/// - Parameter fieldViewsManager: `VGSFieldViewsManager` object.
	internal init(fieldViewsManager: VGSFieldViewsManager) {
		self.fieldViewsManager = fieldViewsManager
	}

	/// Navigate to next TextField from TextFields
	internal func navigateToNextTextField(from textField: VGSTextField) {
		guard let fieldIndex = fieldViewsManager.vgsTextFields.firstIndex(where: { $0 == textField }), fieldIndex < (fieldViewsManager.vgsTextFields.count - 1) else {
			return
		}
		fieldViewsManager.vgsTextFields[fieldIndex + 1].becomeFirstResponder()
	}

	/// Focus to next field if needed. Will be implemented soon.
	/// - Parameter textField: `VGSTextField` object, field from what to switch.
	/// - Parameter isFormValid: `Bool` object, indicates if form is valid.
	internal func focusToNextFieldIfNeeded(for textField: VGSTextField, isFormValid: Bool) {
		// Do not switch from last field.
		if let last = fieldViewsManager.fieldViews.last?.textField {
			// Do not focus from card holder fields since its length does not have specific validation rule.
			if textField.configuration?.type != .cardHolderName {
				// Change focus only from valid field.
				if textField !== last && textField.state.isValid {
					// The entire form is filled in and valid? Do not focus to the next field.
					if isFormValid {return}
					navigateToNextTextField(from: textField)
				}
			}
		}
	}

	/// Switch to the next field on next button. Next button is avaliable only for `cardholder` type.
	/// - Parameter textField: `VGSTextField` object. Current text field.
	internal func focusOnEndEditingOnReturn(for textField: VGSTextField) {
		guard let fieldView = fieldViewsManager.fieldView(with: textField) else {return}
		switch fieldView.fieldType {
		case .cardholderName, .firstName, .lastName:
			navigateToNextTextField(from: textField)
		default:
			break
		}
	}
}
