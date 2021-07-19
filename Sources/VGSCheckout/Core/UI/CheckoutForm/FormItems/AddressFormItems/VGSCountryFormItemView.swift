//
//  VGSCountryFormItemView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for country form.
internal class VGSCountryFormItemView: UIView, VGSTextFieldViewProtocol {

	// MARK: - Vars

	internal let fieldType: VGSAddCardFormFieldType = .country

	let fieldView = VGSPlaceholderFormItemView(frame: .zero)

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
		addSubview(fieldView)
		fieldView.translatesAutoresizingMaskIntoConstraints = false
		fieldView.checkout_constraintViewToSuperviewEdges()

		fieldView.hintLabel.text = "Country"
		fieldView.stackView.addArrangedSubview(countryTextField)
	}
}

/// Holds UI for state picker form.
internal class VGSStatePickerFormItemView: UIView, VGSTextFieldViewProtocol {

	// MARK: - Vars

	internal let fieldType: VGSAddCardFormFieldType = .state

	let fieldView = VGSPlaceholderFormItemView(frame: .zero)

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
		addSubview(fieldView)
		fieldView.translatesAutoresizingMaskIntoConstraints = false
		fieldView.checkout_constraintViewToSuperviewEdges()

		fieldView.hintLabel.text = "State"
		fieldView.stackView.addArrangedSubview(statePickerTextField)
	}
}
