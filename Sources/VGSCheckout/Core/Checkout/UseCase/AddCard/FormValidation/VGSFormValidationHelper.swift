//
//  VGSFormValidationHelper.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Utility class that encapsulates fields validation logic.
internal class VGSFormValidationHelper {

	internal struct FormError {
		let formViewSection: VGSFormSection
		let errorMessage: String?
	}
  
	/// Validation behavior block.
	internal let validationBehaviour: VGSFormValidationBehaviour

	/// `VGSFieldViewsManager` class.
	internal let fieldViewsManager: VGSFieldViewsManager

	/// Validation manger for form item views (textField + placeholder + error checkmark).
	internal let fieldViewsValidationManager: VGSFieldViewValidationManager = VGSFieldViewValidationManager()

	/// Initializer.
	/// - Parameters:
	///   - fieldViews: `[VGSTextFieldViewProtocol]` object, an array of `VGSTextFieldViewProtocol` items.
	///   - validationBehaviour: `VGSFormValidationBehaviour` object, validation flow.
	internal init(fieldViews: [VGSTextFieldViewProtocol], validationBehaviour: VGSFormValidationBehaviour) {
		self.validationBehaviour = validationBehaviour
		self.fieldViewsManager = VGSFieldViewsManager(fieldViews: fieldViews)
	}

  // MARK: - Handle Form State
    /// Update Form View UI elements on editing.
    internal func updateFieldViewOnBeginEditingTextField(_ fieldView: VGSTextFieldViewProtocol) {
      switch validationBehaviour {
      case .onEdit:
        return
      case .onSubmit:
				fieldView.validationErrorView.viewUIState = .valid
				fieldView.updateUI(for: .focused)
        return
      }
    }

  /// Update Form View UI elements on end editing.
  internal func updateFieldViewOnEndEditing(_ fieldView: VGSTextFieldViewProtocol) {
    switch validationBehaviour {
    case .onEdit:
        return
    case .onSubmit:
				fieldView.validationErrorView.viewUIState = .valid
        fieldView.updateUI(for: .valid)
      return
    }
  }

	/// Update form section on submit.
	internal func updateFormSectionViewOnSubmit() {
		let invalidTextViews = fieldViewsWithValidationErrors

		for textView in invalidTextViews {
			let validator = VGSFormFieldsValidatorFactory.provideFieldValidator(for: textView.fieldType)
			let errorMessage = validator.errorMessage(for: textView.textField, fieldType: textView.fieldType)
			if let message = errorMessage {
				textView.validationErrorView.viewUIState = .error(message)
			}
			textView.updateUI(for: .invalid)
		}
	}
  
  // MARK: - Handle TextField State

	/// Update textfield and corresponding form item on end editing event.
	/// - Parameter textField: `VGSTextField` object, textfield.
  private func updateFieldViewUIOnEndEditing(with textField: VGSTextField) {
    switch validationBehaviour {
    case .onEdit:
			guard let fieldView = fieldViewsManager.fieldView(with: textField) else {return}
			fieldViewsValidationManager.updateAnyFieldViewOnEndEditTextField(textField, fieldView: fieldView)
    default:
      break
    }
  }

  // MARK: - Helpers

	/// Check if form is valid.
	/// - Returns: `Bool` object, true if form is valid.
	internal func isFormValid() -> Bool {
    let invalidFields = fieldViewsManager.fieldViews.filter { fieldView in
			return !fieldView.textField.state.isValid
		}
		let isValid = invalidFields.isEmpty

		return isValid
	}
  
  /// Array of `VGSTextFieldViewProtocol` items with validation error.
	internal var fieldViewsWithValidationErrors: [VGSTextFieldViewProtocol] {
        let invalidFields = fieldViewsManager.fieldViews.filter { fieldView in
          return !fieldView.textField.state.isValid
        }
    return invalidFields
  }

	/// Return boolean flag if field is empty and dirty.
	/// - Parameter textField: `VGSTextField` object, text field.
	/// - Returns: `Bool` object, `true` if field is empty and dirty.
	internal func isEmptyAndDirtyTextField(_ textField: VGSTextField) -> Bool {
		let state = textField.state
		return state.isEmpty && state.isDirty
	}

	/// Check if input has required length.
	/// - Parameter fieldView: `VGSTextFieldViewProtocol` object, form item.
	/// - Returns: `Bool` object, `true` if item has valid length.
	internal func isInputRequiredLengthInFieldView(_ fieldView: VGSTextFieldViewProtocol) -> Bool {

		let fieldValidator = VGSFormFieldsValidatorFactory.provideFieldValidator(for: fieldView.fieldType)
		return fieldValidator.isTextFieldInputComplete(fieldView.textField)
	}

	/// Get state from form items array.
	/// - Parameter fieldViews: `[VGSTextFieldViewProtocol]` object, `VGSTextFieldViewProtocol` items.
	/// - Returns: `Bool` object, `true` if form is valid.
	internal func isStateValid(for fieldViews: [VGSTextFieldViewProtocol]) -> Bool {
		var isValid = true
		fieldViews.forEach { fieldView in
			let state = fieldView.textField.state

			// Don't mark fields as invalid without input.
			if state.isDirty && state.isValid == false {
				isValid = false
			}
		}

		return isValid
	}
}
