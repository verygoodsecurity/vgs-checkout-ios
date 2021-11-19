//
//  VGSFormValidationHelper.swift
//  VGSCheckoutSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Utility class that encapsulates fields validation logic.
internal class VGSFormValidationHelper {

	/// Validation behavior.
	internal let validationBehaviour: VGSCheckoutFormValidationBehaviour

	/// `VGSFieldViewsManager` class.
	internal let fieldViewsManager: VGSFieldViewsManager

	/// Validation manger for form item views (textField + placeholder + error checkmark).
	internal let fieldViewsValidationManager: VGSFieldViewValidationManager = VGSFieldViewValidationManager()

	/// Initializer.
	/// - Parameters:
	///   - fieldViews: `[VGSTextFieldViewProtocol]` object, an array of `VGSTextFieldViewProtocol` items.
	///   - validationBehaviour: `VGSFormValidationBehaviour` object, validation flow.
	internal init(fieldViews: [VGSTextFieldViewProtocol], validationBehaviour: VGSCheckoutFormValidationBehaviour) {
		self.validationBehaviour = validationBehaviour
		self.fieldViewsManager = VGSFieldViewsManager(fieldViews: fieldViews)
	}

	// MARK: - Handle Form State

	/// Update Form View UI elements on editing.
	internal func updateFieldViewOnBeginEditingTextField(_ fieldView: VGSTextFieldViewProtocol) {
		// Keep error styles when field is just focused, remove styles only from valid field.
		switch validationBehaviour {
		case .onFocus:
			removeErrorStyleOnlyForValidFieldView(fieldView)
		case .onSubmit:
			removeErrorStyleOnlyForValidFieldView(fieldView)
		}
	}

	/// Update Form View UI elements on editing.
	internal func updateFieldViewOnTextChangeInTextField(_ fieldView: VGSTextFieldViewProtocol) {
		// Always remove error styles on textChange.
		switch validationBehaviour {
		case .onFocus:
			applyValidStyleAndFocus(for: fieldView)
		case .onSubmit:
			applyValidStyleAndFocus(for: fieldView)
		}
	}

	/// Update Form View UI elements on end editing.
	internal func updateFieldViewOnEndEditing(_ fieldView: VGSTextFieldViewProtocol) {
		switch validationBehaviour {
		case .onFocus:
			updateFieldStylesOnEditingForFocusValidation(in: fieldView)
			// Show error on end editing.
			if let errorText = errorMessage(for: fieldView) {
				// Expand all fields in section if at least one field in section is invalid.
				updateAllSectionOnErrorIfNeeded()
				applyErrorStyle(for: fieldView, errorText: errorText)
			} else {
				applyEndEditingStyle(for: fieldView)
			}

			// Validate cvc field view on card number update.
			guard let cvcFieldView = fieldViewsManager.fieldViews.filter({$0.fieldType == .cvc}).first else {return}
			if fieldView.fieldType == .cardNumber {
				updateFieldStylesOnEditingForFocusValidation(in: cvcFieldView)
			}
		case .onSubmit:
			applyEndEditingStyle(for: fieldView)
		}
	}

	/// Update styles for onFocus validation on end editing.
	/// - Parameter fieldView: `VGSTextFieldViewProtocol` object, field view.
	internal func updateFieldStylesOnEditingForFocusValidation(in fieldView: VGSTextFieldViewProtocol) {
		if let errorText = errorMessage(for: fieldView) {
			// Expand all fields in section if at least one field in section is invalid.
			updateAllSectionOnErrorIfNeeded()
			applyErrorStyle(for: fieldView, errorText: errorText)
		} else {
			applyEndEditingStyle(for: fieldView)
		}
	}

	/// Update form section on submit.
	internal func updateFormSectionViewOnSubmit() {
		let invalidFieldViews = fieldViewsWithValidationErrors

		updateAllSectionOnErrorIfNeeded()

		for fieldView in invalidFieldViews {
			let errorText = errorMessageOnSubmit(for: fieldView)
			applyErrorStyle(for: fieldView, errorText: errorText)
		}
	}

	/// Provides error message for field view.
	/// - Parameter fieldView: `VGSTextFieldViewProtocol` object, field view.
	/// - Returns: `String?` object, error message or nil.
	private func errorMessage(for fieldView: VGSTextFieldViewProtocol) -> String? {

		// Display errors only for invalid fields.
		guard !fieldView.textFieldState.isValid else {return nil}

		// On edit validation display errors for only dirty fields.
		if validationBehaviour == .onFocus && !fieldView.textFieldState.isDirty {
			return nil
		}

		return errorMessageText(for: fieldView)
	}

	/// Provides error message for fields on Submit.
	/// - Parameter fieldView: `VGSTextFieldViewProtocol` object, field view.
	/// - Returns: `String?` object, error message or nil.
	internal func errorMessageOnSubmit(for fieldView: VGSTextFieldViewProtocol) -> String? {
		// Display errors only for invalid fields.
		guard !fieldView.textFieldState.isValid else {return nil}

		return errorMessageText(for: fieldView)
	}

	internal func errorMessageText(for fieldView: VGSTextFieldViewProtocol) -> String? {
		let validator = VGSFormFieldsValidatorFactory.provideFieldValidator(for: fieldView.fieldType)

		let errorMessage: String?
		if fieldView.textFieldState.isEmpty {
			// Get specific error message for empty fields.
			errorMessage = validator.emptyErrorMessage(for: fieldView.textField, fieldType: fieldView.fieldType)
		} else {
			// Get specific error message for non-empty fields.
			errorMessage = validator.errorMessage(for: fieldView.textField, fieldType: fieldView.fieldType)
		}
		return errorMessage
	}

	/// Revalidates postal code field (required when user switch country and postal code can be invalid).
	internal func revalidatePostalCodeFieldIfNeeded() {
		guard let fieldView = fieldViewsManager.fieldViews.first(where: {$0.fieldType == .postalCode}) else {
			return
		}

		if let errorText = errorMessage(for: fieldView) {
			applyErrorStyle(for: fieldView, errorText: errorText)
			// Expand all fields in section if at least one field in section is invalid.
			updateAllSectionOnErrorIfNeeded()
		} else {
			applyEndEditingStyle(for: fieldView)
		}
	}

	/// Update all section fields UI to scale all views in section if at least one is invalid.
	private func updateAllSectionOnErrorIfNeeded() {
		for section in invalidSections {
			let fieldsInInitialState = fieldsWithoutErrorState(for: section)
			fieldsInInitialState.forEach { field in
				field.validationErrorView.isDirty = true
				field.validationErrorView.viewUIState = .valid
			}
		}
	}

	/// Provides field views without error state for section.
	/// - Parameter section: `VGSAddCardSection` object, section.
	/// - Returns: `[VGSTextFieldViewProtocol]`, array with valid fields in section.
	private func fieldsWithoutErrorState(for section: VGSAddCardSection) -> [VGSTextFieldViewProtocol] {
		let allSectionFieldsInItialState = fieldViewsManager.fieldViews.filter({$0.fieldType.formSection == section}).filter({!$0.validationErrorView.isDirty})

		return allSectionFieldsInItialState
	}

	/// Sections with invalid fields.
	private var invalidSections: [VGSAddCardSection] {
		let allInvalidSections = fieldViewsWithValidationErrors.map({$0.fieldType.formSection})

		let invalidSections = Array(Set(allInvalidSections))
		return invalidSections
	}

	// MARK: - Styling

	/// Applies valid and focused style.
	/// - Parameter fieldView: `VGSTextFieldViewProtocol` object, field view.
	private func applyValidStyleAndFocus(for fieldView: VGSTextFieldViewProtocol) {
		fieldView.validationErrorView.viewUIState = .valid
		fieldView.updateUI(for: .focused)
	}

	/// Removes error style only from valid field view.
	/// - Parameter fieldView: `VGSTextFieldViewProtocol` object, field view.
	private func removeErrorStyleOnlyForValidFieldView(_ fieldView: VGSTextFieldViewProtocol) {
		switch fieldView.validationErrorView.viewUIState {
		case .error(_):
			return
		default:
			applyValidStyleAndFocus(for: fieldView)
		}
	}

	/// Applies end editing style for fieldView. Applies filled or empty style.
	/// - Parameter fieldView: `VGSTextFieldViewProtocol` object, field view.
	private func applyEndEditingStyle(for fieldView: VGSTextFieldViewProtocol) {
		/// Set `inital`(empty) UI state for fields without content. Set `filled` UI state for fileds with content.
		let fieldUIState: VGSCheckoutFieldUIState = fieldView.textFieldState.isEmpty ? .initial : .filled
		fieldView.updateUI(for: fieldUIState)
		fieldView.validationErrorView.viewUIState = .valid
	}

	/// Applies error style for field view.
	/// - Parameters:
	///   - fieldView: `VGSTextFieldViewProtocol` object, field view.
	///   - errorText: `String?` object, error message text.
	private func applyErrorStyle(for fieldView: VGSTextFieldViewProtocol, errorText: String?) {
		if let text = errorText {
			fieldView.validationErrorView.viewUIState = .error(text)
		}
		fieldView.updateUI(for: .invalid)
	}

	// MARK: - Handle TextField State

	// MARK: - Helpers

	/// Check if form is valid.
	/// - Returns: `Bool` object, true if form is valid.
	internal func isFormValid() -> Bool {
		let invalidFields = fieldViewsManager.fieldViews.filter { fieldView in
			return !fieldView.textFieldState.isValid
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
			return !fieldView.textFieldState.isValid
		}
		return invalidFields
	}
}
