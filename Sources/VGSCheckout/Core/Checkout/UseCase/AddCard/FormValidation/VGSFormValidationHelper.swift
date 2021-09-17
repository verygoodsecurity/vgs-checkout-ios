//
//  VGSFormValidationHelper.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Utility class that encapsulates fields validation logic.
internal class VGSFormValidationHelper {

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
        switch fieldView.validationErrorView.viewUIState {
        case .error(_):
          return
        default:
          fieldView.validationErrorView.viewUIState = .valid
          fieldView.updateUI(for: .focused)
        }
        return
      }
    }

  /// Update Form View UI elements on editing.
  internal func updateFieldViewOnTextChangeInTextField(_ fieldView: VGSTextFieldViewProtocol) {
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
      /// Set `inital`(empty) UI state for fields without content. Set `filled` UI state for fileds with content.
      let fieldUIState: VGSCheckoutFieldUIState = fieldView.textField.state.isEmpty ? .initial : .filled
      fieldView.updateUI(for: fieldUIState)
      fieldView.validationErrorView.viewUIState = .valid
      return
    }
  }

	/// Update form section on submit.
	internal func updateFormSectionViewOnSubmit() {
		let invalidTextViews = fieldViewsWithValidationErrors

		updateAllSectionOnErrorIfNeeded()

		for textView in invalidTextViews {
			let validator = VGSFormFieldsValidatorFactory.provideFieldValidator(for: textView.fieldType)
			let errorMessage = validator.errorMessage(for: textView.textField, fieldType: textView.fieldType)
			if let message = errorMessage {
				textView.validationErrorView.viewUIState = .error(message)
			}
			textView.updateUI(for: .invalid)
		}
	}

	/// Update all section fields UI to scale all views in section if at least one is invalid.
	internal func updateAllSectionOnErrorIfNeeded() {
		for section in invalidSections {
			let fieldsInInitialState = fieldsWithoutErrorState(for: section)
			fieldsInInitialState.forEach { field in
				field.validationErrorView.isDirty = true
				field.validationErrorView.viewUIState = .valid
			}
		}
	}

	internal func fieldsWithoutErrorState(for section: VGSAddCardSection) -> [VGSTextFieldViewProtocol] {
		let allSectionFieldsInItialState = fieldViewsManager.fieldViews.filter({$0.fieldType.formSection == section}).filter({!$0.validationErrorView.isDirty})

		return allSectionFieldsInItialState
	}

	internal var invalidSections: [VGSAddCardSection] {
		let allInvalidSections = fieldViewsWithValidationErrors.map({$0.fieldType.formSection})

		let invalidSections = Array(Set(allInvalidSections))
		return invalidSections
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

	/// An array with invalid fieldType names.
	internal var analyticsInvalidFieldNames: [String] {
		return fieldViewsWithValidationErrors.map({$0.fieldType.analyticsFieldName})
	}
  
  /// Array of `VGSTextFieldViewProtocol` items with validation error.
	internal var fieldViewsWithValidationErrors: [VGSTextFieldViewProtocol] {
        let invalidFields = fieldViewsManager.fieldViews.filter { fieldView in
          return !fieldView.textField.state.isValid
        }
    return invalidFields
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
