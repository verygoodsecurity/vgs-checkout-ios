//
//  VGSCountryFieldView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for country form.
internal class VGSCountryFieldView: UIView, VGSTextFieldViewProtocol {

	// MARK: - Vars

	internal let fieldType: VGSAddCardFormFieldType = .country

	let placeholderView = VGSPlaceholderFieldView(frame: .zero)

	var textField: VGSTextField {
		return countryTextField
	}

	lazy var countryTextField: VGSPickerTextField = {
		let field = VGSPickerTextField()
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
		addSubview(placeholderView)
		placeholderView.translatesAutoresizingMaskIntoConstraints = false
		placeholderView.checkout_constraintViewToSuperviewEdges()

		placeholderView.hintLabel.text = "Country"
		placeholderView.stackView.addArrangedSubview(countryTextField)
	}
}

/// Holds UI for state picker form.
internal class VGSStatePickerFieldView: UIView, VGSTextFieldViewProtocol {

	// MARK: - Vars

	internal let fieldType: VGSAddCardFormFieldType = .state

	let placeholderView = VGSPlaceholderFieldView(frame: .zero)

	var textField: VGSTextField {
		return statePickerTextField
	}

	lazy var statePickerTextField: VGSPickerTextField = {
		let field = VGSPickerTextField()
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
		addSubview(placeholderView)
		placeholderView.translatesAutoresizingMaskIntoConstraints = false
		placeholderView.checkout_constraintViewToSuperviewEdges()

		placeholderView.hintLabel.text = "State"
		placeholderView.stackView.addArrangedSubview(statePickerTextField)
	}
}
