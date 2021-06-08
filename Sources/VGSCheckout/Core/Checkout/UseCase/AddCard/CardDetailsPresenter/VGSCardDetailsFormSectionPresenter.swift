//
//  VGSCardDetailsFormSectionPresenter.swift
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

/// Form section sate.
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
final internal class VGSCardDetailsFormSectionPresenter: VGSBaseFormSectionProtocol {

	weak var delegate: VGSFormSectionPresenterDelegate?

	internal var state: VGSFormSectionState = .invalid {
		didSet {
			delegate?.stateDidChange(state)
		}
	}

	internal let validationBehavior: VGSFormValidationBehaviour

	/// Card form view.
	internal let cardFormView: VGSCheckoutCardFormView

	/// TODO: - this should be dynamic.
	var textFiedComponents: [VGSTextFieldFormComponentProtocol] {
		return [
			      cardFormView.cardNumberComponentView,
						cardFormView.expDateComponentView,
						cardFormView.cvcDateComponentView]
	}

	var vgsTextFields: [VGSTextField] {
		return textFiedComponents.map({return $0.textField})
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
		self.cardFormView = VGSCheckoutCardFormView(paymentInstrument: paymentInstrument)

		buildForm()
	}

	// MARK: - Interface

	internal func buildForm() {
		cardFormView.translatesAutoresizingMaskIntoConstraints = false
		
		switch paymentInstrument {
		case .vault(let configuration):
			setupCardForm(with: configuration)
		}
	}

	// MARK: - Helpers

	private func setupCardForm(with vaultConfiguration: VGSCheckoutConfiguration) {
		let cardNumberFieldName = vaultConfiguration.formConfiguration.cardOptions.cardNumberOptions.fieldName
		let cvcFieldName = vaultConfiguration.formConfiguration.cardOptions.cvcOptions.fieldName
		let expDateFieldName = vaultConfiguration.formConfiguration.cardOptions.expirationDateOptions.fieldName

		let cardNumber = cardFormView.cardNumberComponentView.cardTextField
		let expCardDate = cardFormView.expDateComponentView.expDateTextField
		let cvcCardNum = cardFormView.cvcDateComponentView.cvcTextField

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

		cardNumber.becomeFirstResponder()

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

		vgsCollect.textFields.forEach { textField in
			textField.textColor = UIColor.black
			textField.font = UIFont.preferredFont(forTextStyle: .body)
			textField.adjustsFontForContentSizeCategory = true
			textField.tintColor = .lightGray
			textField.delegate = self
		}
	}
}

// MARK: - VGSTextFieldDelegate

extension VGSCardDetailsFormSectionPresenter: VGSTextFieldDelegate {
	func vgsTextFieldDidEndEditing(_ textField: VGSTextField) {

		switch validationBehavior {
		case .onFocus:
			textFiedComponents.forEach { formComponent in
				if formComponent.textField === textField {
					let state = textField.state
					let isValid = state.isValid

					var fieldState = VGSCheckoutFormValidationState.valid
					if !isValid {
						fieldState = .invalid
					}

					formComponent.placeholderComponent.updateUI(for: fieldState)
				}
			}
		default:
			break
		}
	}

	func vgsTextFieldDidChange(_ textField: VGSTextField) {
		switch validationBehavior {
		case .onFocus:
			let invalidFields = textFiedComponents.filter { textField in
				return !textField.textField.state.isValid
			}
			let isValid = invalidFields.isEmpty
			if isValid {
				state = .valid
        /// when input is valid - automatically navigaste to the next textField
			} else {
				state = .invalid
			}
      if textField.state.isValid {
        navigateToNextTextField(from: textField)
      }
		default:
			break
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
