//
//  VGSCountryFormItemView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for country form.
internal class VGSCountryFormItemView: UIView, VGSTextFieldFormItemProtocol {

	// MARK: - Vars

	internal let fieldType: VGSAddCardFormFieldType = .country

	let formItemView = VGSPlaceholderFormItemView(frame: .zero)

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
		addSubview(formItemView)
		formItemView.translatesAutoresizingMaskIntoConstraints = false
		formItemView.checkout_constraintViewToSuperviewEdges()

		formItemView.hintLabel.text = "Country"
		formItemView.stackView.addArrangedSubview(countryTextField)
	}
}

/// Holds UI for state picker form.
internal class VGSStatePickerFormItemView: UIView, VGSTextFieldFormItemProtocol {

	// MARK: - Vars

	internal let fieldType: VGSAddCardFormFieldType = .state

	let formItemView = VGSPlaceholderFormItemView(frame: .zero)

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
		addSubview(formItemView)
		formItemView.translatesAutoresizingMaskIntoConstraints = false
		formItemView.checkout_constraintViewToSuperviewEdges()

		formItemView.hintLabel.text = "State"
		formItemView.stackView.addArrangedSubview(statePickerTextField)
	}
}
