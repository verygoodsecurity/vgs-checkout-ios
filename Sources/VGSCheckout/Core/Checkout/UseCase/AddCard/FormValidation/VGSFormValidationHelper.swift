//
//  VGSFormValidationHelper.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Utility class that encapsulates fields validation logic.
internal class VGSFormValidationHelper {
	internal let formItems: [VGSTextFieldFormItemProtocol]
	internal let validationBehaviour: VGSFormValidationBehaviour

	internal init(formItems: [VGSTextFieldFormItemProtocol], validationBehaviour: VGSFormValidationBehaviour) {
		self.formItems = formItems
		self.validationBehaviour = validationBehaviour
	}

	internal func updateFieldUIOnEndEditing(for textField: VGSTextField) {
		switch validationBehaviour {
		case .onFocus:
			guard let formItem = fieldFormItem(for: textField) else {return}
			let state = textField.state
			// Don't update UI for non-edited field.
			if !state.isDirty {
				formItem.formItemView.updateUI(for: .inactive)
				return
			}

			let isValid = state.isValid

			if isValid {
				formItem.formItemView.updateUI(for: .focused)
			} else {
				print(state.validationErrors)
				formItem.formItemView.updateUI(for: .invalid)
			}
		default:
			break
		}
	}

	internal func updateFieldUIOnTextChange(for textField: VGSTextField) {
		switch validationBehaviour {
		case .onFocus:
			if let formItem = fieldFormItem(for: textField) {
				if textField.state.isValid {
					formItem.formItemView.updateUI(for: .focused)
				} else {
					switch textField.fieldType {
					case .cardNumber:
						handleCardNumberFieldState(textField, formItem: formItem)
					default:
						handleAnyFieldState(textField, formItem: formItem)
					}
					return
				}
			}
		case .onTextChange:
			break
		}
	}

	internal func handleCardNumberFieldState(_ field: VGSTextField, formItem: VGSTextFieldFormItemProtocol) {
		if let cardState = field.state as? CardState {
			/// TODO: can use 16(15 for amex) as default digits
			if cardState.cardBrand.cardLengths.max() ?? 16 <= cardState.inputLength {
				print(cardState.validationErrors)
				formItem.formItemView.updateUI(for: .invalid)
			} else {
				formItem.formItemView.updateUI(for: .focused)
			}
		} else {
			print(field.state.validationErrors)
			formItem.formItemView.updateUI(for: .invalid)
		}
	}

	internal func handleAnyFieldState(_ field: VGSTextField, formItem: VGSTextFieldFormItemProtocol) {
		if field.state.isValid {
			formItem.formItemView.updateUI(for: .focused)
		} else {
			print(field.state.validationErrors)
			formItem.formItemView.updateUI(for: .invalid)
		}
	}

	internal func isFormValid() -> Bool {
		let invalidFields = formItems.filter { textField in
			return !textField.textField.state.isValid
		}
		let isValid = invalidFields.isEmpty

		return isValid
	}

	internal func getFormValidationError() -> String? {
		let invalidFields = self.formItems.filter{ !$0.textField.state.isValid && $0.textField.state.isDirty}

		guard invalidFields.count > 0, let firstErrorField = invalidFields.first else {
			return nil
		}

		/// Check if first field with error is focused
		if firstErrorField.textField.isFocused  {
			/// Check if field input is full required length
			let isFullLength = isInputRequiredLengthInFormItem(firstErrorField)
			if isFullLength {
				/// If true - show field error
				let errorText = self.getErrorMessageForFieldType(firstErrorField.fieldType)
				return errorText
			} else {
				/// If false - show next field error
				guard invalidFields.count > 1 else {
					return nil
				}
				let secondErrorField = invalidFields[1]
				let errorText = self.getErrorMessageForFieldType(secondErrorField.fieldType)
				return errorText
			}
		} else {
			/// Show error from first not valid field
			let errorMessage = getErrorMessageForFieldType(firstErrorField.fieldType)
			return errorMessage
		}
	}

	internal func getErrorMessageForFieldType(_ fieldType: VGSAddCardFormFieldType) -> String {
		switch fieldType {
		case .cardholderName, .firstName, .lastName:
			return fieldType.emptyFieldNameError
		case .cardNumber:
			return "Enter a valid card number"
		case .expirationDate:
			return "Expiration date is not valid"
		case .cvc:
			return "Security code is not valid"
		default:
			return "Card details should be valid"
		}
	}

	internal func isInputRequiredLengthInFormItem(_ formItem: VGSTextFieldFormItemProtocol) -> Bool {

		let fieldValidator = VGSFormFieldsValidatorFactory.provideFieldValidator(for: formItem.fieldType)
		return fieldValidator.isTextFieldInputComplete(formItem.textField)
	}

	internal func isStateValid(for formItems: [VGSTextFieldFormItemProtocol]) -> Bool {
		var isValid = true
		formItems.forEach { formItem in
			let state = formItem.textField.state

			// Don't mark fields as invalid without input.
			if state.isDirty && state.isValid == false {
				isValid = false
			}
		}

		return isValid
	}

	/// Form item containing current textField.
	/// - Parameter textField: `VGSTextField` object,
	/// - Returns: `VGSTextFieldFormItemProtocol?` object.
	internal func fieldFormItem(for textField: VGSTextField) -> VGSTextFieldFormItemProtocol? {
		return formItems.first(where: {$0.textField === textField})
	}

	/// All text fields.
	internal var vgsTextFields: [VGSTextField] {
		return formItems.map({return $0.textField})
	}

	/// All invalid text fields.
	internal var invalidFields: [VGSTextField] {
		return formItems.filter{ !$0.textField.state.isValid && $0.textField.state.isDirty}.map({return $0.textField})
	}

	// MARK: - Form blocks

	/// Check whether form block contains valid fields.
	/// - Parameter formBlock: `VGSAddCardFormBlock` object, form block type.
	/// - Returns: `Bool` object, `true` if valid.
	internal func isCardFormBlockValid(_ formBlock: VGSAddCardFormBlock) -> Bool {
		let cardHolderFormItems = formItems.filter({$0.fieldType.formBlock == formBlock})

		return isStateValid(for: cardHolderFormItems)
	}

	/// All form blocks.
	internal var formBlocks: [VGSAddCardFormBlock] {
		return Array(Set(formItems.map({return $0.fieldType.formBlock})))
	}

	// MARK: - Fields navigation.

	/// Navigate to next TextField from TextFields
	internal func navigateToNextTextField(from textField: VGSTextField) {
		guard let fieldIndex = vgsTextFields.firstIndex(where: { $0 == textField }), fieldIndex < (vgsTextFields.count - 1) else {
			return
		}
		vgsTextFields[fieldIndex + 1].becomeFirstResponder()
	}

	internal func focusToNextFieldIfNeeded(for textField: VGSTextField) {
		// Do not switch from last field.
		if let last = formItems.last?.textField {
			// Do not focus from card holder fields since its length does not have specific validation rule.
			if textField.configuration?.type != .cardHolderName {
				// Change focus only from valid field.
				if textField !== last && textField.state.isValid {
					// The entire form is filled in and valid? Do not focus to the next field.
					if isFormValid() {return}
					navigateToNextTextField(from: textField)
				}
			}
		}
	}

	internal func focusOnEndEditingOnReturn(for textField: VGSTextField) {
		guard let formItem = fieldFormItem(for: textField) else {return}
		switch formItem.fieldType {
		case .cardholderName, .firstName, .lastName:
			navigateToNextTextField(from: textField)
		default:
			break
		}
	}

	// MARK: - CVC Helpers

	internal func updateSecurityCodeFieldIfNeeded(for editingTextField: VGSTextField) {
		if editingTextField.configuration?.type == .cardNumber, let cardState = editingTextField.state as? CardState {
			updateCVCPlaceholder(for: cardState.cardBrand)
		}
	}

	private func updateCVCPlaceholder(for cardBrand: VGSCheckoutPaymentCards.CardBrand) {
		 guard let cvcField = vgsTextFields.first(where: { $0.configuration?.type == .cvc}) else {
			 return
		 }
		 switch cardBrand {
		 case .amex:
			 cvcField.placeholder = "CVV"
		 default:
			 cvcField.placeholder = "CVC"
		 }
	 }
}
