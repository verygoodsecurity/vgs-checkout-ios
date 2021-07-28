//
//  VGSPostalCodeFieldView.swift
//  VGSCheckout

import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for postal code field view.
internal class VGSPostalCodeFieldView: UIView, VGSTextFieldViewProtocol {

	// MARK: - Vars

	internal var fieldType: VGSAddCardFormFieldType = .postalCode

	let placeholderView = VGSPlaceholderFieldView(frame: .zero)

	var textField: VGSTextField {
		return postalCodeTextField
	}

	lazy var postalCodeTextField: VGSTextField = {
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

	// MARK: - Interface

	/// Updates UI for postal code field view.
	/// - Parameters:
	///   - fieldView: `VGSTextFieldViewProtocol` object, field view.
	///   - countryISOCode: `VGSCountriesISO` object, country iso code.
	internal static func updateUI(for fieldView: VGSTextFieldViewProtocol,  countryISOCode: VGSCountriesISO) {
		let postalCode = VGSBillingAddressUtils.postalCode(for: countryISOCode)

		fieldView.placeholderView.hintLabel.text = postalCode.textFieldHint
		fieldView.textField.placeholder = postalCode.textFieldPlaceholder
	}

	// MARK: - Helpers

	private func buildUI() {
		addSubview(placeholderView)
		placeholderView.translatesAutoresizingMaskIntoConstraints = false
		placeholderView.checkout_constraintViewToSuperviewEdges()

		placeholderView.hintComponentView.label.text = "ZIP"
		placeholderView.stackView.addArrangedSubview(postalCodeTextField)
	}
}
