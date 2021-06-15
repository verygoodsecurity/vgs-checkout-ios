//
//  VGSCardDataSectionManager.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCollectSDK

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

	// MARK: - Initialization

	internal init(paymentInstrument: VGSPaymentInstrument, vgsCollect: VGSCollect, validationBehavior: VGSFormValidationBehaviour = .onFocus) {
		self.paymentInstrument = paymentInstrument
		self.vgsCollect = vgsCollect
		self.validationBehavior = validationBehavior
		self.cardFormView = VGSCardDetailsFormView(paymentInstrument: paymentInstrument)

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

		let expDateConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: expDateFieldName)
		expDateConfiguration.isRequiredValidOnly = true
		expDateConfiguration.type = .expDate

		/// Default .expDate format is "##/##"
		expDateConfiguration.formatPattern = "##/####"

		/// Update validation rules
		/// FIXME - hardcoded for now!
		expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleCardExpirationDate(dateFormat: .longYear, error: VGSValidationErrorType.expDate.rawValue)
		])

		expCardDate.configuration = expDateConfiguration
		expCardDate.placeholder = "MM/YYYY"
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
		expDateConfiguration.serializers = [VGSExpDateSeparateSerializer(monthFieldName: "data.attributes.details.month", yearFieldName: "data.attributes.details.year")]
		expDateConfiguration.formatPattern = "##/##"

		/// Update validation rules
		expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleCardExpirationDate(dateFormat: .shortYear, error: VGSValidationErrorType.expDate.rawValue)
		])

		expCardDate.configuration = expDateConfiguration
		expCardDate.placeholder = "MM/YY"
		expCardDate.monthPickerFormat = .longSymbols

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
		/// Required to be not empty

		cardHolderFirstName.textAlignment = .natural
		cardHolderFirstName.configuration = firstNameConfiguration
		cardHolderFirstName.placeholder = "First Name"

		let lastNameConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "data.attributes.details.last_name")
		lastNameConfiguration.type = .cardHolderName
		lastNameConfiguration.keyboardType = .namePhonePad
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

	func vgsTextFieldDidBeginEditing(_ textField: VGSTextField) {
		textFiedFormItems.forEach { formComponent in
			if formComponent.textField === textField {
				formComponent.formItemView.highlight(with: .blue)
				formComponent.formItemView.increaseBorderZPosition()
			}
		}
	}

	func vgsTextFieldDidEndEditing(_ textField: VGSTextField) {

		switch validationBehavior {
		case .onFocus:
			textFiedFormItems.forEach { formComponent in
				if formComponent.textField === textField {

					let state = textField.state
					if !state.isDirty {
						formComponent.formItemView.removeHighlight()
						formComponent.formItemView.updateUI(for: .none)
						return
					}

					let isValid = state.isValid

					if isValid {
						formComponent.formItemView.removeHighlight()
						formComponent.formItemView.updateUI(for: .valid)
					} else {
						formComponent.formItemView.highlight(with: .red)
						formComponent.formItemView.updateUI(for: .invalid)
					}

					formComponent.formItemView.decreaseBorderZPosition()

					//formComponent.formItemView.updateUI(for: fieldState)
				}
			}
		default:
			break
		}
	}

	func vgsTextFieldDidChange(_ textField: VGSTextField) {
		switch validationBehavior {
		case .onFocus:
			print("textFiedFormItems: \(textFiedFormItems)")
			let invalidFields = textFiedFormItems.filter { textField in
				return !textField.textField.state.isValid
			}
			let isValid = invalidFields.isEmpty

			if isValid {
				state = .valid
        /// when input is valid - automatically navigate to the next textField
			} else {
				state = .invalid

				if let firstInvalidField = invalidFields.first(where: {$0.textField.isFocused}) {
					if let fieldError = firstInvalidField.textField.state.validationErrors.first {
						}
					}
				}

			if isValid {
				return 
			}

			if let last = textFiedFormItems.last?.textField {
				if textField.configuration?.type != .cardHolderName {
					if textField !== last && textField.state.isValid {
						navigateToNextTextField(from: textField)
					}
				}
			}
		default:
			break
		}
	}

	func vgsTextFieldDidEndEditingOnReturn(_ textField: VGSTextField) {
			textFiedFormItems.forEach { formItem in
				if formItem.textField === textField {
					switch formItem.fieldType {
					case .cardholderName, .firstName, .lastName:
						navigateToNextTextField(from: textField)
					default:
						break
					}
				}
			}
	}

  /// Navigate to next TextField from TextFields
  func navigateToNextTextField(from textField: VGSTextField) {
    guard let fieldIndex = vgsTextFields.firstIndex(where: { $0 == textField }), fieldIndex < (vgsTextFields.count - 1) else {
      return
    }
    vgsTextFields[fieldIndex + 1].becomeFirstResponder()
  }
}
