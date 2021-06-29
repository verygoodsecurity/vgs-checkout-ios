//
//  VGSCardDataSectionManager.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Form section delegate protocol.
internal protocol VGSFormSectionPresenterDelegate: AnyObject {
	func stateDidChange(_ state: VGSFormSectionState)
}

/// Base protocol for form section.
internal protocol VGSBaseFormSectionProtocol {
	var vgsTextFields: [VGSTextField] {get}
}

/// Form section state.
internal enum VGSFormSectionState {
	case valid
	case invalid
}

/// Defines validation behavior.
internal enum VGSFormValidationBehaviour {
	case onFocus
	case onTextChange
}

/// Holds logic for card form setup and handling events.
final internal class VGSCardDataSectionManager: VGSBaseFormSectionProtocol, VGSPlaceholderFormItemViewDelegate {

	weak var delegate: VGSFormSectionPresenterDelegate?

	internal var state: VGSFormSectionState = .invalid {
		didSet {
			delegate?.stateDidChange(state)
		}
	}

	internal let validationBehavior: VGSFormValidationBehaviour

	/// Card form view.
	internal let cardFormView: VGSCardDetailsFormView

	/// Text field form items in add card section.
	var textFiedFormItems: [VGSTextFieldFormItemProtocol] {
		return cardFormView.formItems
	}

	var vgsTextFields: [VGSTextField] {
		return textFiedFormItems.map({return $0.textField})
	}

	/// Configuration type.
	internal let paymentInstrument: VGSPaymentInstrument

	/// VGSCollect instance.
	internal let vgsCollect: VGSCollect

	internal let formValidationHelper: VGSFormValidationHelper

	// MARK: - Initialization

	internal init(paymentInstrument: VGSPaymentInstrument, vgsCollect: VGSCollect, validationBehavior: VGSFormValidationBehaviour = .onFocus) {
		self.paymentInstrument = paymentInstrument
		self.vgsCollect = vgsCollect
		self.validationBehavior = validationBehavior
		self.cardFormView = VGSCardDetailsFormView(paymentInstrument: paymentInstrument)
		self.formValidationHelper = VGSFormValidationHelper(formItems: cardFormView.formItems, validationBehaviour: validationBehavior)

		buildForm()
	}

	// MARK: - Interface

	internal func buildForm() {
		cardFormView.translatesAutoresizingMaskIntoConstraints = false
		
		switch paymentInstrument {
		case .vault(let configuration):
			setupCardForm(withVault: configuration)
		case .multiplexing(let multiplexingConfig):
			setupCardForm(withMultiplexing: multiplexingConfig)
		}

		vgsCollect.textFields.forEach { textField in
			textField.textColor = UIColor.black
			textField.font = UIFont.preferredFont(forTextStyle: .body)
			textField.adjustsFontForContentSizeCategory = true
			textField.tintColor = .lightGray
			textField.delegate = self
		}

		for item in textFiedFormItems {
			item.formItemView.delegate = self
		}
	}

	// MARK: - Helpers

	private func setupCardForm(withVault vaultConfiguration: VGSCheckoutConfiguration) {
		let cardNumberFieldName = vaultConfiguration.formConfiguration.cardOptions.cardNumberOptions.fieldName
		let cvcFieldName = vaultConfiguration.formConfiguration.cardOptions.cvcOptions.fieldName
		let expDateFieldName = vaultConfiguration.formConfiguration.cardOptions.expirationDateOptions.fieldName

		let cardNumber = cardFormView.cardNumberFormItemView.cardTextField
		let expCardDate = cardFormView.expDateFormItemView.expDateTextField
		let cvcCardNum = cardFormView.cvcFormItemView.cvcTextField

		let cardConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: cardNumberFieldName)
		cardConfiguration.type = .cardNumber
		cardConfiguration.isRequiredValidOnly = true

		/// Enable validation of unknown card brand if needed
		cardConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRulePaymentCard(error: VGSValidationErrorType.cardNumber.rawValue, validateUnknownCardBrand: true)
		])
		cardNumber.configuration = cardConfiguration
		cardNumber.placeholder = "4111 1111 1111 1111"

		cardNumber.textAlignment = .natural
    cardNumber.cardIconLocation = .right

		let expDateConfiguration = VGSExpDateConfiguration(collector: vgsCollect, fieldName: expDateFieldName)
		expDateConfiguration.isRequiredValidOnly = true
		expDateConfiguration.type = .expDate

		/// Default .expDate format is "##/##"
		expDateConfiguration.formatPattern = "##/##"

		/// Update validation rules
		/// FIXME - hardcoded for now!
		expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleCardExpirationDate(dateFormat: .shortYear, error: VGSValidationErrorType.expDate.rawValue)
		])

		expDateConfiguration.inputSource = .keyboard
		expDateConfiguration.inputDateFormat = .shortYear
		expCardDate.configuration = expDateConfiguration
		expCardDate.placeholder = "MM/YY"
//        expCardDate.monthPickerFormat = .longSymbols

		let cvcConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: cvcFieldName)
		cvcConfiguration.isRequired = true
		cvcConfiguration.type = .cvc

		cvcCardNum.configuration = cvcConfiguration
		cvcCardNum.isSecureTextEntry = true
		cvcCardNum.placeholder = "CVC"
		cvcCardNum.tintColor = .lightGray

		let cardHolderOptions = vaultConfiguration.cardHolderFieldOptions
		if cardHolderOptions.fieldVisibility == .visible {
			switch cardHolderOptions.fieldNameType {
			case .single(let fieldName):
				let holderConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: fieldName)
				holderConfiguration.type = .cardHolderName
				holderConfiguration.returnKeyType = .next

				if let cardHolderName = textFiedFormItems.first(where: {$0.fieldType == .cardholderName}) {
					cardHolderName.textField.textAlignment = .natural
					cardHolderName.textField.configuration = holderConfiguration
				}
			case .splitted(let firstName, lastName: let lastName):
				if let firstNameFormItem = textFiedFormItems.first(where: {$0.fieldType == .firstName}), let lastNameFormItem = textFiedFormItems.first(where: {$0.fieldType == .lastName})  {

					let firstNameConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: firstName)
					firstNameConfiguration.type = .cardHolderName
					firstNameConfiguration.returnKeyType = .next

					firstNameFormItem.textField.textAlignment = .natural
					firstNameFormItem.textField.configuration = firstNameConfiguration

					let lastNameConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: lastName)
					lastNameConfiguration.type = .cardHolderName
					lastNameConfiguration.returnKeyType = .next

					lastNameFormItem.textField.textAlignment = .natural
					lastNameFormItem.textField.configuration = firstNameConfiguration
				}
			}
		}
	}

	private func setupCardForm(withMultiplexing multiplexingConfiguration: VGSCheckoutMultiplexingConfiguration) {

		let cardNumber = cardFormView.cardNumberFormItemView.cardTextField
		let expCardDate = cardFormView.expDateFormItemView.expDateTextField
		let cvcCardNum = cardFormView.cvcFormItemView.cvcTextField

		let cardConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "data.attributes.details.number")
		cardConfiguration.type = .cardNumber
		cardConfiguration.isRequiredValidOnly = true

		/// Enable validation of unknown card brand if needed
		cardConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRulePaymentCard(error: VGSValidationErrorType.cardNumber.rawValue, validateUnknownCardBrand: true)
		])
		cardNumber.configuration = cardConfiguration
		cardNumber.placeholder = "4111 1111 1111 1111"

		cardNumber.textAlignment = .natural
		cardNumber.cardIconLocation = .right

		let expDateConfiguration = VGSExpDateConfiguration(collector: vgsCollect, fieldName: "data.attributes.details")
		expDateConfiguration.type = .expDate
		expDateConfiguration.inputDateFormat = .shortYear
		expDateConfiguration.outputDateFormat = .longYear
		expDateConfiguration.serializers = [VGSCheckoutExpDateSeparateSerializer(monthFieldName: "data.attributes.details.month", yearFieldName: "data.attributes.details.year")]
		expDateConfiguration.formatPattern = "##/##"
		expDateConfiguration.inputSource = .keyboard

		/// Update validation rules
		expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleCardExpirationDate(dateFormat: .shortYear, error: VGSValidationErrorType.expDate.rawValue)
		])

		expDateConfiguration.inputDateFormat = .shortYear
		expCardDate.configuration = expDateConfiguration
		expCardDate.placeholder = "MM/YY"

		let cvcConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "data.attributes.details.verification_value")
		cvcConfiguration.type = .cvc

		cvcCardNum.configuration = cvcConfiguration
		cvcCardNum.isSecureTextEntry = true
		cvcCardNum.placeholder = "CVC"
		cvcCardNum.tintColor = .lightGray

		guard let cardHolderFirstName = textFiedFormItems.first(where: {$0.fieldType == .firstName})?.textField, let cardHolderLastName = textFiedFormItems.first(where: {$0.fieldType == .lastName})?.textField else {
			assertionFailure("Invalid multiplexing setup!")
			return
		}

		let firstNameConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "data.attributes.details.first_name")
		firstNameConfiguration.type = .cardHolderName
		firstNameConfiguration.keyboardType = .namePhonePad
		firstNameConfiguration.returnKeyType = .next
		/// Required to be not empty

		cardHolderFirstName.textAlignment = .natural
		cardHolderFirstName.configuration = firstNameConfiguration
		cardHolderFirstName.placeholder = "First Name"

		let lastNameConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "data.attributes.details.last_name")
		lastNameConfiguration.type = .cardHolderName
		lastNameConfiguration.keyboardType = .namePhonePad
		lastNameConfiguration.returnKeyType = .next
		/// Required to be not empty

		cardHolderLastName.textAlignment = .natural
		cardHolderLastName.configuration = lastNameConfiguration
		cardHolderLastName.placeholder = "Last Name"
	}

	func didTap(in formView: VGSPlaceholderFormItemView) {
		for item in textFiedFormItems {
			if item.formItemView === formView {
				item.textField.becomeFirstResponder()
			}
		}
	}
}

// MARK: - VGSTextFieldDelegate

extension VGSCardDataSectionManager: VGSTextFieldDelegate {

	func vgsTextFieldDidEndEditing(_ textField: VGSTextField) {
		formValidationHelper.updateFieldUIOnEndEditing(for: textField)
	}

	func vgsTextFieldDidChange(_ textField: VGSTextField) {
		formValidationHelper.updateFieldUIOnTextChange(for: textField)
		formValidationHelper.updateSecurityCodeFieldIfNeeded(for: textField)

		switch validationBehavior {
		case .onFocus:
			// Update the entire form state.
			if formValidationHelper.isFormValid() {
				state = .valid
			} else {
				state = .invalid
			}

			// Update form blocks UI.
			let formBlocks = formValidationHelper.formBlocks
			formBlocks.forEach { formBlock in
				let isFormBlockValid = self.formValidationHelper.isCardFormBlockValid(formBlock)
				self.cardFormView.updateFormBlock(formBlock, isValid: isFormBlockValid)
			}

			formValidationHelper.focusToNextFieldIfNeeded(for: textField)
		case .onTextChange:
			break
		}
	}

	func vgsTextFieldDidEndEditingOnReturn(_ textField: VGSTextField) {
		formValidationHelper.focusOnEndEditingOnReturn(for: textField)
	}
}

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
					formItem.formItemView.updateUI(for: .invalid)
				}
			}
		case .onTextChange:
			break
		}
	}

	internal func isCardFormBlockValid(_ formBlock: VGSAddCardFormBlock) -> Bool {
		let cardHolderFormItems = formItems.filter({$0.fieldType.formBlock == formBlock})

		return isStateValid(for: cardHolderFormItems)
	}

	internal func fieldFormItem(for textField: VGSTextField) -> VGSTextFieldFormItemProtocol? {
		return formItems.first(where: {$0.textField === textField})
	}

	internal func isFormValid() -> Bool {
		let invalidFields = formItems.filter { textField in
			return !textField.textField.state.isValid
		}
		let isValid = invalidFields.isEmpty

		return isValid
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

	internal var vgsTextFields: [VGSTextField] {
		return formItems.map({return $0.textField})
	}

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

	internal var formBlocks: [VGSAddCardFormBlock] {
		return Array(Set(formItems.map({return $0.fieldType.formBlock})))
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

	internal func updateSecurityCodeFieldIfNeeded(for editingTextField: VGSTextField) {
		if editingTextField.configuration?.type == .cardNumber, let cardState = editingTextField.state as? CardState {
			updateCVCPlaceholder(for: cardState.cardBrand)
		}
	}

	internal func updateCVCPlaceholder(for cardBrand: VGSCheckoutPaymentCards.CardBrand) {
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
