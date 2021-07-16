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

	/// `VGSFormItemsManager` class.
	internal let formItemsManager: VGSFormItemsManager

	/// Validation manger for form item views (textField + placeholder + error checkmark).
	internal let formItemViewsValidationManager: VGSFormItemViewValidationManager = VGSFormItemViewValidationManager()

	/// Initializer.
	/// - Parameters:
	///   - formItems: `[VGSTextFieldFormItemProtocol]` object, an array of `VGSTextFieldFormItemProtocol` items.
	///   - validationBehaviour: `VGSFormValidationBehaviour` object, validation flow.
	internal init(formItems: [VGSTextFieldFormItemProtocol], validationBehaviour: VGSFormValidationBehaviour) {
		self.validationBehaviour = validationBehaviour
		self.formItemsManager = VGSFormItemsManager(formItems: formItems)
	}

  // MARK: - Handle Form State

  /// Update Form View UI elements on editing.
  internal func updateFormViewOnEditingTextField(textField: VGSTextField) {
    switch validationBehaviour {
    case .onFocus:
      /// Update form error message and ui state
      let formErrors = formValidationErrors()

			for formError in formErrors {
				let formViewSection = formError.formViewSection
				if let view = formSectionView(for: formViewSection) {
					updateFormViewWithError(view, with: formError.errorMessage)
				}
			}

      /// Update textfield UI state
      updateFieldUIOnEditing(for: textField)
    case .onTextChange:
      return
    }
  }
  
  /// Update Form View UI elements on end editing.
  internal func updateFormViewOnEndEditingTextField(textField: VGSTextField) {
    switch validationBehaviour {
    case .onFocus:
      /// Update form error message and grid state
			/// Update form error message and ui state
			let formErrors = formValidationErrors()

			for formError in formErrors {
				let formViewSection = formError.formViewSection
				if let view = formSectionView(for: formViewSection) {
					updateFormViewWithError(view, with: formError.errorMessage)
				}
			}
			
      /// Update textfield UI state
      updateFieldUIOnEndEditing(for: textField)
    case .onTextChange:
      return
    }
  }

	/// Update form view UI with error.
	/// - Parameters:
	///   - view: `VGSFormGroupViewProtocol` object, form view.
	///   - formError: `String?` object, form error.
  private func updateFormViewWithError(_ view: VGSFormGroupViewProtocol, with formError: String?) {
    /// Update Form with Error Message
    if let error = formError {
      view.errorLabel.text = error
      view.errorLabel.isHiddenInCheckoutStackView = false
			view.updateFormBlocks(formItemsManager.formBlocks, isValid: false)
    } else {
      view.errorLabel.text = ""
			view.errorLabel.isHiddenInCheckoutStackView = true
			view.updateFormBlocks(formItemsManager.formBlocks, isValid: true)
    }
  }
  
  // MARK: - Handle TextField State
  
  /// Update Form Item UI on Editing Event.
	private func updateFieldUIOnEditing(for textField: VGSTextField) {
		switch validationBehaviour {
		case .onFocus:
			if let formItem = formItemsManager.fieldFormItem(for: textField) {
					switch textField.fieldType {
					case .cardNumber:
						formItemViewsValidationManager.updateCardNumberFormItemOnEditingTextField(textField, formItem: formItem)
					default:
						formItemViewsValidationManager.updateAnyFormItemOnEditingTextField(textField, formItem: formItem)
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
			guard let formItem = formItemsManager.fieldFormItem(for: textField) else {return}
			formItemViewsValidationManager.updateAnyFormItemOnEndEditTextField(textField, formItem: formItem)
    default:
      break
    }
  }

  // MARK: - Helpers

	/// Check if form is valid.
	/// - Returns: `Bool` object, true if form is valid.
	internal func isFormValid() -> Bool {
    let invalidFields = formItemsManager.formItems.filter { formItem in
			return !formItem.textField.state.isValid
		}
		let isValid = invalidFields.isEmpty

		return isValid
	}
  
  /// Array of `VGSTextFieldFormItemProtocol` items with validation error.
	internal var fieldsWithvalidationErrors: [VGSTextFieldFormItemProtocol] {
    let invalidFields = formItemsManager.formItems.filter { formItem in
      return !formItem.textField.state.isValid && formItem.textField.state.isDirty
    }
    return invalidFields
  }

	/// Array of `VGSTextFieldFormItemProtocol` items with validation error.
	internal func fieldsWithvalidationErrors(for formSection: VGSFormSection) -> [VGSTextFieldFormItemProtocol] {
		let formSectionItems = formItemsManager.formItems.filter { formItem in
			return formItem.fieldType.formSection == formSection
		}

		let invalidFields = formSectionItems.filter { formItem in
			return !formItem.textField.state.isValid && formItem.textField.state.isDirty
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

  /// Returns first error from  not valid, not active, dirty field.
	internal func firstFormValidationError(for formSection: VGSFormSection) -> String? {
		let invalidFields = fieldsWithvalidationErrors

		guard !invalidFields.isEmpty, let firstErrorField = invalidFields.first else {
			return nil
		}

		let firstField = firstErrorField.textField
		let firstFieldType = firstErrorField.fieldType

		let firstFieldValidator = VGSFormFieldsValidatorFactory.provideFieldValidator(for: firstFieldType)

		/// Check if first field with error is focused.
		if firstErrorField.textField.isFirstResponder {

			/// Check if field input is full required length
			let isFullLength = isInputRequiredLengthInFormItem(firstErrorField)
			if isFullLength {
				/// If true - show field error1
				let errorText = firstFieldValidator.errorMessage(for: firstField, fieldType: firstFieldType)
				return errorText
			} else {
				/// If false - show next field error
				guard invalidFields.count > 1 else {
					return nil
				}

				let secondErrorField = invalidFields[1]

				let secondField = secondErrorField.textField
				let secondFieldType = secondErrorField.fieldType

				let secondFieldValidator = VGSFormFieldsValidatorFactory.provideFieldValidator(for: secondFieldType)

				var errorText = secondFieldValidator.errorMessage(for: secondField, fieldType: secondFieldType)

				// Show empty error error if field is empty and dirty.
				if isEmptyAndDirtyTextField(secondField) {
					errorText = secondFieldValidator.emptyErrorMessage(for: secondField, fieldType: secondFieldType)
				}

				return errorText
			}
		} else {
			// Show error from first not valid field
			var errorMessage = firstFieldValidator.errorMessage(for: firstField, fieldType: firstFieldType)

			if isEmptyAndDirtyTextField(firstField) {
				errorMessage = firstFieldValidator.emptyErrorMessage(for: firstField, fieldType: firstFieldType)
			}

			return errorMessage
		}
	}

	/// Returns first error from  not valid, not active, dirty field.
	internal func formValidationErrors() -> [FormError] {
		let invalidFields = fieldsWithvalidationErrors

		guard !invalidFields.isEmpty, let firstErrorField = invalidFields.first else {
			return []
		}

		var formErrors = [FormError]()
		let currentFormSections = formSections

		for section in currentFormSections {
			let invalidFields = fieldsWithvalidationErrors(for: section)

			guard !invalidFields.isEmpty, let firstErrorField = invalidFields.first else {
				continue
			}

			let firstField = firstErrorField.textField
			let firstFieldType = firstErrorField.fieldType

			let firstFieldValidator = VGSFormFieldsValidatorFactory.provideFieldValidator(for: firstFieldType)

			/// Check if first field with error is focused.
			if firstErrorField.textField.isFirstResponder {

				/// Check if field input is full required length
				let isFullLength = isInputRequiredLengthInFormItem(firstErrorField)
				if isFullLength {
					/// If true - show field error1
					let errorText = firstFieldValidator.errorMessage(for: firstField, fieldType: firstFieldType)

					let formError = FormError(formViewSection: section, errorMessage: errorText)
					formErrors.append(formError)
				} else {
					/// If false - show next field error
					guard invalidFields.count > 1 else {
						continue
					}

					let secondErrorField = invalidFields[1]

					let secondField = secondErrorField.textField
					let secondFieldType = secondErrorField.fieldType

					let secondFieldValidator = VGSFormFieldsValidatorFactory.provideFieldValidator(for: secondFieldType)

					var errorText = secondFieldValidator.errorMessage(for: secondField, fieldType: secondFieldType)

					// Show empty error error if field is empty and dirty.
					if isEmptyAndDirtyTextField(secondField) {
						errorText = secondFieldValidator.emptyErrorMessage(for: secondField, fieldType: secondFieldType)
					}

					let formError = FormError(formViewSection: section, errorMessage: errorText)
					formErrors.append(formError)
				}
			} else {
				// Show error from first not valid field
				var errorMessage = firstFieldValidator.errorMessage(for: firstField, fieldType: firstFieldType)

				if isEmptyAndDirtyTextField(firstField) {
					errorMessage = firstFieldValidator.emptyErrorMessage(for: firstField, fieldType: firstFieldType)
				}

				let formError = FormError(formViewSection: section, errorMessage: errorMessage)
				formErrors.append(formError)
			}
		}

		return formErrors
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

	// MARK: - Form blocks

	/// Check whether form block contains valid fields.
	/// - Parameter formBlock: `VGSAddCardFormBlock` object, form block type.
	/// - Returns: `Bool` object, `true` if valid.
	internal func isCardFormBlockValid(_ formBlock: VGSAddCardFormBlock) -> Bool {
    let cardHolderFormItems = formItemsManager.formItems.filter({$0.fieldType.formBlock == formBlock})

		return isStateValid(for: cardHolderFormItems)
	}

	internal var formSections: Set<VGSFormSection> {
		return Set(formItemsManager.formItems.map({$0.fieldType.formSection}))
	}

	internal func formSectionView(for formSection: VGSFormSection) -> VGSFormGroupViewProtocol? {
		for view in formItemsManager.formViews {
			switch formSection {
			case .card:
				if view is VGSCardDetailsFormView {
					return view
				}
			case .billingAddress:
				if view is VGSBillingAddressDetailsView {
					return view
				}
			}
		}

		return nil
	}
}
