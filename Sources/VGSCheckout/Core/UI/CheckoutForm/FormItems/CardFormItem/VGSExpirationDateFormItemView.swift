//
//  VGSExpirationDateFormItemView.swift
//  VGSCollectSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCollectSDK

internal enum VGSAddCardFormBlock {
	case cardHolder
	case cardDetails
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
}

internal enum VGSAddCardFormFieldType {
	case cardNumber
	case expirationDate
	case cvc
	case cardholderName
	case firstName
	case lastName

	var formBlock: VGSAddCardFormBlock {
		switch self {
		case .cardholderName, .firstName, .lastName:
			return .cardHolder
		case .cardNumber, .expirationDate, .cvc:
			return .cardDetails
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

		field.placeholder = "MM/YY"

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

		formItemView.hintComponentView.label.text = "Expiration date"
		formItemView.stackView.addArrangedSubview(expDateTextField)
	}
}
