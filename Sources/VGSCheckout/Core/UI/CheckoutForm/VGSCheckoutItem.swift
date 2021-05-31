//
//  VGSCheckoutComponent.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCollectSDK

internal protocol VGSComponentProtocol {
	var view: UIView {get}
}

public class VGSCheckoutComponent: NSObject {

//	internal var config: VGSCheckoutConfiguration?

	enum FormState {
		case invalid
		case valid
		case processing
	}

	var state = FormState.invalid {
		didSet {
			switch state {
			case .invalid:
				payButton.status = .disabled
			case .valid:
				payButton.status = .enabled
			case .processing:
				payButton.status = .processing
			}
		}
	}

	// MARK: - View

	internal lazy var backgroundStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.axis = .vertical
		stackView.distribution = .fill

		stackView.layer.cornerRadius = 4
		stackView.layer.borderColor = UIColor(hexString: "#C8D0DB").cgColor
		stackView.layer.borderWidth = 1

		stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
		stackView.isLayoutMarginsRelativeArrangement = true
		
		return stackView
	}()

	internal lazy var payButton: VGSSubmitButton = {
		let button = VGSSubmitButton(frame: .zero)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

		return button
	}()

	internal lazy var payButtonContainerView: VGSContainerItemView = {
		let view = VGSContainerItemView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		view.addContentView(payButton)
		view.paddings = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
		return view
	}()


	internal lazy var cardCheckoutView: VGSCheckoutCardFormView = {
		let view = VGSCheckoutCardFormView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	internal lazy var formController: VGSFormViewController = {
		let viewController = VGSFormViewController()
		viewController.formView.stackView.layoutMargins = UIEdgeInsets(top: 50, left: 16, bottom: 50, right: 16)
		viewController.formView.stackView.isLayoutMarginsRelativeArrangement = true

		viewController.formView.addFormItemView(backgroundStackView)

		backgroundStackView.addArrangedSubview(cardCheckoutView)
		backgroundStackView.addArrangedSubview(payButtonContainerView)

		//viewController.formView.addFormItemView(payButtonContainerView)

		let view = UIView()
		view.backgroundColor = .white
		view.translatesAutoresizingMaskIntoConstraints = false

//		viewController.formView.stackView.layer.borderWidth = 1
//		viewController.formView.stackView.layer.cornerRadius = 4

		viewController.formView.addFormItemView(view)

		return viewController
	}()

	internal var vgsCollect: VGSCollect

	// MARK: - Initialization

	public init(vgsCollect: VGSCollect) {
		self.vgsCollect = vgsCollect
		super.init()
		buildForm()
	}

	// MARK: - Helpers

	internal func buildForm() {
		setupElementsConfiguration()
		payButton.addTarget(self, action: #selector(payDidTap), for: .touchUpInside)
	}

	@objc fileprivate func payDidTap() {
		payButton.status = .processing
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.payButton.status = .success
		}
	}

	var textFiedComponents: [VGSTextFieldFormComponentProtocol] {
		return [cardCheckoutView.cardNumberComponentView,
						cardCheckoutView.expDateComponentView,
						cardCheckoutView.cvcDateComponentView]
	}

	private func setupElementsConfiguration() {
			let cardNumber = cardCheckoutView.cardNumberComponentView.cardTextField
			let expCardDate = cardCheckoutView.expDateComponentView.expDateTextField
			let cvcCardNum = cardCheckoutView.cvcDateComponentView.cvcTextField

			let cardConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "card_number")
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

			// To handle VGSTextFieldDelegate methods
			// cardNumber.delegate = self
			cardNumber.becomeFirstResponder()

			let expDateConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "card_expirationDate")
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

			let cvcConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "card_cvc")
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

	public func presentCheckout(from viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
		formController.modalPresentationStyle = .overFullScreen
		viewController.present(formController, animated: animated, completion: completion)
	}
}

// MARK: - VGSTextFieldDelegate

extension VGSCheckoutComponent: VGSTextFieldDelegate {
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

		let isValid = invalidFields.isEmpty
		if isValid {
			state = .valid
		} else {
			state = .invalid
		}
	}
}
