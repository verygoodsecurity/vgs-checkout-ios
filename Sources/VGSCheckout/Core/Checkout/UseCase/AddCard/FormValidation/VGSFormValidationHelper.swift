//
//  VGSFormValidationHelper.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Utility class that encapsulates fields validation logic.
internal class VGSFormValidationHelper {

	/// Form items.
	internal let formItems: [VGSTextFieldFormItemProtocol]

	/// Validation behavior block.
	internal let validationBehaviour: VGSFormValidationBehaviour

	/// Initializer.
	/// - Parameters:
	///   - formItems: `[VGSTextFieldFormItemProtocol]` object, an array of `VGSTextFieldFormItemProtocol` items.
	///   - validationBehaviour: `VGSFormValidationBehaviour` object, validation flow.
	internal init(formItems: [VGSTextFieldFormItemProtocol], validationBehaviour: VGSFormValidationBehaviour) {
		self.formItems = formItems
		self.validationBehaviour = validationBehaviour
	}

  // MARK: - Handle Form State
  
  // TODO: Change `VGSCardDetailsFormView` to protocol
  /// Update Form View UI elements on editing.
  internal func updateFormViewOnEditingTextField(_ view: VGSCardDetailsFormView, textField: VGSTextField) {
    switch validationBehaviour {
    case .onFocus:
      /// Update form error message and ui state
      let formError = getFirstFormValidationError()
      updateFormViewWithError(view, formError: formError)
      /// Update textfield UI state
      updateFieldUIOnEditing(for: textField)
    case .onTextChange:
      return
    }
  }
  
  /// Update Form View UI elements on end editing.
  internal func updateFormViewOnEndEditingTextField(_ view: VGSCardDetailsFormView, textField: VGSTextField) {
    switch validationBehaviour {
    case .onFocus:
      /// Update form error message and grid state
      let formError = getFirstFormValidationError()
      updateFormViewWithError(view, formError: formError)
      /// Update textfield UI state
      updateFieldUIOnEndEditing(for: textField)
    case .onTextChange:
      return
    }
  }

	/// Update form view UI with error.
	/// - Parameters:
	///   - view: `VGSCardDetailsFormView` object, form view.
	///   - formError: `String?` object, form error.
  private func updateFormViewWithError(_ view: VGSCardDetailsFormView, formError: String?) {
    /// Update Form with Error Message
    if let error = formError {
      view.cardDetailsErrorLabel.text = error
      view.cardDetailsErrorLabel.isHiddenInCheckoutStackView = false
      view.updateFormBlocks(formBlocks, isValid: false)
    } else {
      view.cardDetailsErrorLabel.text = ""
      view.updateFormBlocks(formBlocks, isValid: true)
    }
  }
  
  // MARK: - Handle TextField State
  
  /// Update Form Item UI on Editing Event.
	private func updateFieldUIOnEditing(for textField: VGSTextField) {
		switch validationBehaviour {
		case .onFocus:
			if let formItem = fieldFormItem(for: textField) {
					switch textField.fieldType {
					case .cardNumber:
            updateCardNumberFormItemOnEditingTextField(textField, formItem: formItem)
					default:
            updateAnyFormItemOnEditingTextField(textField, formItem: formItem)
					}
					return
			}
		case .onTextChange:
			break
		}
	}

	/// Update textfield and corresponding form item on end editing event.
	/// - Parameter textField: `VGSTextField` object, textfield.
  private func updateFieldUIOnEndEditing(for textField: VGSTextField) {
    switch validationBehaviour {
    case .onFocus:
      guard let formItem = fieldFormItem(for: textField) else {return}
      self.updateAnyFormItemOnEndEditTextField(textField, formItem: formItem)
    default:
      break
    }
  }
  
  /// Handle CardNumber field state during editing.
	private func updateCardNumberFormItemOnEditingTextField(_ field: VGSTextField, formItem: VGSTextFieldFormItemProtocol) {
    
    let isValidLength = self.isInputRequiredLengthInFormItem(formItem)
    // NOTE: same first digits in card number can be valid for 13, 16 and 19 digits
    let isValidState = field.state.isValid
    
    switch (isValidLength ,isValidState) {
    case (false, _):
      formItem.updateUI(for: .focused)
    case (true, true):
      formItem.updateUI(for: .valid)
    case (true, false):
      formItem.updateUI(for: .invalid)
    }
	}

  /// Handle Any field state during editing.
  private func updateAnyFormItemOnEditingTextField(_ field: VGSTextField, formItem: VGSTextFieldFormItemProtocol) {
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
  private func updateAnyFormItemOnEndEditTextField(_ field: VGSTextField, formItem: VGSTextFieldFormItemProtocol) {
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

  // MARK: - Helpers

	/// Check if form is valid.
	/// - Returns: `Bool` object, true if form is valid.
	internal func isFormValid() -> Bool {
		let invalidFields = formItems.filter { formItem in
			return !formItem.textField.state.isValid
		}
		let isValid = invalidFields.isEmpty

		return isValid
	}
  
  /// Returns array of `VGSTextFieldFormItemProtocol` items with validation error.
  internal func getFieldsWithValidationErros() -> [VGSTextFieldFormItemProtocol] {
    let invalidFields = formItems.filter { formItem in
      return !formItem.textField.state.isValid && formItem.textField.state.isDirty
    }
    return invalidFields
  }

  /// Returns first error from  not valid, not active, dirty field.
	internal func getFirstFormValidationError() -> String? {
		let invalidFields = getFieldsWithValidationErros()

		guard invalidFields.count > 0, let firstErrorField = invalidFields.first else {
			return nil
		}

		/// Check if first field with error is focused.
		if firstErrorField.textField.isFirstResponder  {
			/// Check if field input is full required length
			let isFullLength = isInputRequiredLengthInFormItem(firstErrorField)
			if isFullLength {
				/// If true - show field error1
				let errorText = self.getErrorMessage(for: firstErrorField.fieldType)
				return errorText
			} else {
				/// If false - show next field error
				guard invalidFields.count > 1 else {
					return nil
				}
				let secondErrorField = invalidFields[1]
				let errorText = self.getErrorMessage(for: secondErrorField.fieldType)
				return errorText
			}
		} else {
			/// Show error from first not valid field
			let errorMessage = getErrorMessage(for: firstErrorField.fieldType)
			return errorMessage
		}
	}

	/// Get error message for field type.
	/// - Parameter fieldType: `VGSAddCardFormFieldType` object, field type.
	/// - Returns: `String` object, contains with error message.
	internal func getErrorMessage(for fieldType: VGSAddCardFormFieldType) -> String {
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

	/// Check if input has required length.
	/// - Parameter formItem: `VGSTextFieldFormItemProtocol` object, form item.
	/// - Returns: `Bool` object, `true` if item has valid length.
	internal func isInputRequiredLengthInFormItem(_ formItem: VGSTextFieldFormItemProtocol) -> Bool {

		let fieldValidator = VGSFormFieldsValidatorFactory.provideFieldValidator(for: formItem.fieldType)
		return fieldValidator.isTextFieldInputComplete(formItem.textField)
	}

	/// Get state from form items array.
	/// - Parameter formItems: `[VGSTextFieldFormItemProtocol]` object, `VGSTextFieldFormItemProtocol` items.
	/// - Returns: `Bool` object, `true` if form is valid.
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

	/// Focus to next field if needed. Will be implemented soon.
	/// - Parameter textField: `VGSTextField` object, field from what to switch.
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

	/// Switch to the next field on next button. Next button is avaliable only for `cardholder` type.
	/// - Parameter textField: `VGSTextField` object. Current text field.
	internal func focusOnEndEditingOnReturn(for textField: VGSTextField) {
		guard let formItem = fieldFormItem(for: textField) else {return}
		switch formItem.fieldType {
		case .cardholderName, .firstName, .lastName:
			navigateToNextTextField(from: textField)
		default:
			break
		}
	}
}
