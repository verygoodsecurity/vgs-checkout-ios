//
//  VGSExpirationDateFormItemView.swift
//  VGSCollectSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCollectSDK

internal enum VGSCheckoutFormValidationState {
	case none
	case valid
	case invalid
}

internal protocol VGSTextFieldFormComponentProtocol: AnyObject {
	var placeholderComponent: VGSPlaceholderFormItemView {get}
	var textField: VGSTextField {get}
}

internal class VGSExpirationDateFormItemView: UIView, VGSTextFieldFormComponentProtocol {

	// MARK: - Vars

	let placeholderComponent = VGSPlaceholderFormItemView(frame: .zero)

	var textField: VGSTextField {
		return expDateTextField
	}

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
		addSubview(placeholderComponent)
		placeholderComponent.translatesAutoresizingMaskIntoConstraints = false
		placeholderComponent.checkout_constraintViewToSuperviewEdges()

		placeholderComponent.hintComponentView.label.text = "MM/YY"
		placeholderComponent.stackView.addArrangedSubview(expDateTextField)
	}
}
