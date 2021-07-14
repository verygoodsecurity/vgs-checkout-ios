//
//  VGSExpirationDateFormItemView.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal enum VGSAddCardFormBlock {
	case cardHolder
	case cardDetails
	case addressInfo
}

internal enum VGSCheckoutFormValidationState {
	case inactive
	case focused
	case valid
	case invalid
	case disabled
}

internal protocol VGSTextFieldFormItemProtocol: AnyObject {
	var formItemView: VGSPlaceholderFormItemView {get}
	var textField: VGSTextField {get}
	var fieldType: VGSAddCardFormFieldType {get}
  
  func updateUI(for validationState: VGSCheckoutFormValidationState)
}

/// TODO: Move to base class?
extension VGSTextFieldFormItemProtocol {
  
  // MARK: - Interface

  /// Update UI.
  /// - Parameter validationState: `VGSCheckoutFormValidationState` object, form validation state.
  func updateUI(for validationState: VGSCheckoutFormValidationState) {
    switch validationState {
    case .focused, .inactive, .valid:
      formItemView.hintComponentView.accessory = .none
    case .invalid:
      formItemView.hintComponentView.accessory = .invalid
    case .disabled:
      formItemView.hintComponentView.accessory = .none
    }
  }
}

internal enum VGSAddCardFormFieldType {
	case cardNumber
	case expirationDate
	case cvc
	case cardholderName
	case firstName
	case lastName
	case country
	case addressLine1
	case addressLine2
	case city
	case state
	case zipCode

	var formBlock: VGSAddCardFormBlock {
		switch self {
		case .cardholderName, .firstName, .lastName:
			return .cardHolder
		case .cardNumber, .expirationDate, .cvc:
			return .cardDetails
		case .country, .addressLine1, .addressLine2, .city, .state, .zipCode:
			return .addressInfo
		}
	}

	/// Empty field name error.
	var emptyFieldNameError: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: emptyFieldNameLocalizationKey)
	}

	private var emptyFieldNameLocalizationKey: String {
		switch self {
		case .cardholderName:
			return "vgs_checkout_card_holder_empty_error"
		case .firstName:
			return "vgs_checkout_card_holder_empty_error"
		case .lastName:
			return "vgs_checkout_card_holder_empty_error"
		case .cardNumber:
			return "vgs_checkout_card_number_empty_error"
		case .expirationDate:
			return "vgs_checkout_card_expiration_date_empty_error"
		case .cvc:
			return "vgs_checkout_card_verification_code_invalid_error"
		default:
			return "Field is empty"
		}
	}
}

internal class VGSExpirationDateFormItemView: UIView, VGSTextFieldFormItemProtocol {

	// MARK: - Vars

	let formItemView = VGSPlaceholderFormItemView(frame: .zero)

	var textField: VGSTextField {
		return expDateTextField
	}

	let fieldType: VGSAddCardFormFieldType = .expirationDate

	lazy var expDateTextField: VGSExpDateTextField = {
		let field = VGSExpDateTextField()
		field.translatesAutoresizingMaskIntoConstraints = false

		field.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_expiration_date_hint")

		field.cornerRadius = 0
		field.borderWidth = 0
		return field
	}()

	// MARK: - Initialization

	override init(frame: CGRect) {
		super.init(frame: .zero)

		buildUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Helpers

	private func buildUI() {
		addSubview(formItemView)
		formItemView.translatesAutoresizingMaskIntoConstraints = false
		formItemView.checkout_constraintViewToSuperviewEdges()

		formItemView.hintComponentView.label.text = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_expiration_date_subtitle")
		formItemView.stackView.addArrangedSubview(expDateTextField)
	}
}
