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
  internal func updateFormSectionViewOnEditingTextField(textField: VGSTextField) {
    switch validationBehaviour {
    case .onFocus:
      /// Update form error message and ui state
      let formErrors = formValidationErrors()

			for formError in formErrors {
				let formViewSection = formError.formViewSection
				if let view = formSectionView(for: formViewSection) {
					print("view: \(view) errorMessage: \(formError.errorMessage ?? "No error!!!")")
					updateFormSectionViewWithError(view, with: formError.errorMessage)
				}
			}

			/// Reset all errors.
			if formErrors.isEmpty {
				fieldViewsManager.formSectionViews.forEach { formView in
					updateFormSectionViewWithError(formView, with: nil)
				}
			}

      /// Update textfield UI state
      updateFieldViewUIOnEditing(with: textField)
    case .onTextChange:
      return
    }
  }
  
  /// Update Form View UI elements on end editing.
  internal func updateFormSectionViewOnEndEditingTextField(textField: VGSTextField) {
    switch validationBehaviour {
    case .onFocus:
      /// Update form error message and grid state
			/// Update form error message and ui state
			let formErrors = formValidationErrors()

			for formError in formErrors {
				let formViewSection = formError.formViewSection
				if let view = formSectionView(for: formViewSection) {
					print("view: \(view) errorMessage: \(formError.errorMessage ?? "No error!!!")")
					updateFormSectionViewWithError(view, with: formError.errorMessage)
				}
			}

			/// Reset all errors.
			if formErrors.isEmpty {
				fieldViewsManager.formSectionViews.forEach { formView in
					updateFormSectionViewWithError(formView, with: nil)
				}
			}
			
      /// Update textfield UI state
      updateFieldViewUIOnEndEditing(with: textField)
    case .onTextChange:
      return
    }
  }

	/// Update form view UI with error.
	/// - Parameters:
	///   - view: `VGSFormGroupViewProtocol` object, form view.
	///   - formError: `String?` object, form error.
  private func updateFormSectionViewWithError(_ view: VGSFormSectionViewProtocol, with formError: String?) {
    /// Update Form with Error Message
    if let error = formError {
      view.errorLabel.text = error
      view.errorLabel.isHiddenInCheckoutStackView = false
			view.updateSectionBlocks(fieldViewsManager.sectionBlocks, isValid: false)
    } else {
      view.errorLabel.text = ""
			view.errorLabel.isHiddenInCheckoutStackView = true
			view.updateSectionBlocks(fieldViewsManager.sectionBlocks, isValid: true)
    }
  }
  
  // MARK: - Handle TextField State
  
  /// Update Form Item UI on Editing Event.
	private func updateFieldViewUIOnEditing(with textField: VGSTextField) {
		switch validationBehaviour {
		case .onFocus:
			if let fieldView = fieldViewsManager.fieldView(with: textField) {
					switch textField.fieldType {
					case .cardNumber:
						fieldViewsValidationManager.updateCardNumberFieldViewOnEditingTextField(textField, fieldView: fieldView)
					default:
						fieldViewsValidationManager.updateAnyFieldViewOnEditingTextField(textField, fieldView: fieldView)
					}
					return
			}
		case .onTextChange:
			break
		}
	}

	/// Update textfield and corresponding form item on end editing event.
	/// - Parameter textField: `VGSTextField` object, textfield.
  private func updateFieldViewUIOnEndEditing(with textField: VGSTextField) {
    switch validationBehaviour {
    case .onFocus:
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
      return !fieldView.textField.state.isValid && fieldView.textField.state.isDirty
    }
    return invalidFields
  }

	/// Array of `VGSTextFieldViewProtocol` items with validation error.
	internal func fieldViewsWithValidationErrors(in formSection: VGSFormSection) -> [VGSTextFieldViewProtocol] {
		let formSectionItems = fieldViewsManager.fieldViews.filter { fieldView in
			return fieldView.fieldType.formSection == formSection
		}

		let invalidFields = formSectionItems.filter { fieldView in
			return !fieldView.textField.state.isValid && fieldView.textField.state.isDirty
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
	internal func formValidationErrors() -> [FormError] {
		let invalidFields = fieldViewsWithValidationErrors

		guard !invalidFields.isEmpty else {
			return []
		}

		var formErrors = [FormError]()
		let currentFormSections = formSections

		for section in currentFormSections {
			let invalidFields = fieldViewsWithValidationErrors(in: section)

			guard !invalidFields.isEmpty, let firstErrorField = invalidFields.first else {
				continue
			}

			let firstField = firstErrorField.textField
			let firstFieldType = firstErrorField.fieldType

			let firstFieldValidator = VGSFormFieldsValidatorFactory.provideFieldValidator(for: firstFieldType)

			/// Check if first field with error is focused.
			if firstErrorField.textField.isFirstResponder {

				/// Check if field input is full required length
				let isFullLength = isInputRequiredLengthInFieldView(firstErrorField)
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

	// MARK: - Form blocks

	/// Check whether form block contains valid fields.
	/// - Parameter sectionBlock: `VGSAddCardSectionBlock` object, form block type.
	/// - Returns: `Bool` object, `true` if valid.
	internal func isCardSectionBlockValid(_ sectionBlock: VGSAddCardSectionBlock) -> Bool {
    let cardHolderFieldViews = fieldViewsManager.fieldViews.filter({$0.fieldType.sectionBlock == sectionBlock})

		return isStateValid(for: cardHolderFieldViews)
	}

	/// Current form sections.
	internal var formSections: Set<VGSFormSection> {
		return Set(fieldViewsManager.fieldViews.map({$0.fieldType.formSection}))
	}

	/// Form view for form section.
	/// - Parameter formSection: `VGSFormSection` object, form section type.
	/// - Returns: `VGSFormGroupViewProtocol?` object, form view.
	internal func formSectionView(for formSection: VGSFormSection) -> VGSFormSectionViewProtocol? {
		for view in fieldViewsManager.formSectionViews {
			switch formSection {
			case .card:
				if view is VGSCardDetailsSectionView {
					return view
				}
			case .billingAddress:
				if view is VGSBillingAddressDetailsSectionView {
					return view
				}
			}
		}

		return nil
	}
}
