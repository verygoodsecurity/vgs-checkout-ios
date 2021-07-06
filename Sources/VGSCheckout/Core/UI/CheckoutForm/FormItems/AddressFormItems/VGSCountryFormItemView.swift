//
//  VGSCountryFormItemView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal class VGSCountryFormItemView: UIView, VGSTextFieldFormItemProtocol {

	// MARK: - Vars

	internal let fieldType: VGSAddCardFormFieldType = .cvc

	let formItemView = VGSPlaceholderFormItemView(frame: .zero)

	var textField: VGSTextField {
		return cvcTextField
	}

	lazy var cvcTextField: VGSCVCTextField = {
		let field = VGSCVCTextField()
		field.translatesAutoresizingMaskIntoConstraints = false

		field.placeholder = "CVC"

		field.cvcIconSize = CGSize(width: 32, height: 20)
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

		formItemView.hintComponentView.label.text = "Security code"
		formItemView.stackView.addArrangedSubview(cvcTextField)
	}
}
