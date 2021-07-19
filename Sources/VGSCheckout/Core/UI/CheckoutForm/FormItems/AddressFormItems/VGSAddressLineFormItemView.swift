//
//  VGSAddressLineFormItemView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for address line form item.
internal class VGSAddressLineFormItemView: UIView, VGSTextFieldViewProtocol {

	// MARK: - Vars

	internal var fieldType: VGSAddCardFormFieldType = .addressLine1

	let fieldView = VGSPlaceholderFormItemView(frame: .zero)

	var textField: VGSTextField {
		return addressLineTextField
	}

	lazy var addressLineTextField: VGSTextField = {
		let field = VGSTextField()
		field.translatesAutoresizingMaskIntoConstraints = false

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
		addSubview(fieldView)
		fieldView.translatesAutoresizingMaskIntoConstraints = false
		fieldView.checkout_constraintViewToSuperviewEdges()

		fieldView.hintComponentView.label.text = "Address Line 1"
		fieldView.stackView.addArrangedSubview(addressLineTextField)
	}
}
