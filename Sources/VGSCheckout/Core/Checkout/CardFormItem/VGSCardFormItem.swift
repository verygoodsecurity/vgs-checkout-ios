//
//  VGSCardFormItemManager.swift
//  VGSCheckout
//

import Foundation
import UIKit
import VGSCollectSDK

/// Holds logic for card form setup and handling events.
final internal class VGSCardFormItemController {

	/// Card view.
	internal lazy var cardFormView: VGSCheckoutCardFormView = {
		let view = VGSCheckoutCardFormView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	var textFiedComponents: [VGSTextFieldFormComponentProtocol] {
		return [cardFormView.cardNumberComponentView,
						cardFormView.expDateComponentView,
						cardFormView.cvcDateComponentView]
	}

	/// Configuration type.
	internal let paymentFlow: VGSPaymentFlow

	/// VGSCollect instance.
	internal let vgsCollect: VGSCollect

	// MARK: - Initialization

	internal init(paymentFlow: VGSPaymentFlow, vgsCollect: VGSCollect) {
		self.paymentFlow = paymentFlow
		self.vgsCollect = vgsCollect
	}

	// MARK: - Interface

	internal func buildForm() {
		switch paymentFlow {
		case .vault(let configuration):
			setupCardForm(with: configuration)
		default:
			break
		}
	}

	// MARK: - Helpers

	private func setupCardForm(with vaultConfiguration: VGSCheckoutVaultConfiguration) {
		let cardDetails = vaultConfiguration.cardDetailsOptions

		let cardNumber = cardFormView.cardNumberComponentView.cardTextField
		let expCardDate = cardFormView.expDateComponentView.expDateTextField
		let cvcCardNum = cardFormView.cvcDateComponentView.cvcTextField

		let cardConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: cardDetails.cardNumberFieldName)
		cardConfiguration.type = .cardNumber
		cardConfiguration.isRequiredValidOnly = true

		/// Enable validation of unknown card brand if needed
		cardConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRulePaymentCard(error: VGSValidationErrorType.cardNumber.rawValue, validateUnknownCardBrand: true)
		])
		cardNumber.configuration = cardConfiguration
		cardNumber.placeholder = "4111 1111 1111 1111"
//			cardNumber.textAlignment = .natural
//			cardNumber.cardIconLocation = .right

		// To handle VGSTextFieldDelegate methods
		// cardNumber.delegate = self
		cardNumber.becomeFirstResponder()

		let expDateConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: cardDetails.expidationDateFieldName)
		expDateConfiguration.isRequiredValidOnly = true
		expDateConfiguration.type = .expDate

		/// Default .expDate format is "##/##"
		expDateConfiguration.formatPattern = "##/####"

		/// Update validation rules
		expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleCardExpirationDate(dateFormat: .longYear, error: VGSValidationErrorType.expDate.rawValue)
		])

		expCardDate.configuration = expDateConfiguration
		expCardDate.placeholder = "MM/YYYY"
//        expCardDate.monthPickerFormat = .longSymbols

		let cvcConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: cardDetails.cvcFieldName)
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

extension VGSCardFormItemController: VGSTextFieldDelegate {
	public func vgsTextFieldDidEndEditing(_ textField: VGSTextField) {
		var isFormValid = false
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
	}

	public func vgsTextFieldDidChange(_ textField: VGSTextField) {
		let invalidFields = textFiedComponents.filter { textField in
			return !textField.textField.state.isValid
		}

//		let isValid = invalidFields.isEmpty
//		if isValid {
//			state = .valid
//		} else {
//			state = .invalid
//		}
	}
}
