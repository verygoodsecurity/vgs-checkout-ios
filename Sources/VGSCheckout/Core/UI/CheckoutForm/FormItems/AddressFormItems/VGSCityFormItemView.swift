//
//  VGSCityFormItemView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for city form item.
internal class VGSCityFormItemView: UIView, VGSTextFieldViewProtocol {

	// MARK: - Vars

	internal var fieldType: VGSAddCardFormFieldType = .city

	let fieldView = VGSPlaceholderFormItemView(frame: .zero)

	var textField: VGSTextField {
		return cityTextField
	}

	lazy var cityTextField: VGSTextField = {
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

		fieldView.hintComponentView.label.text = "City"
		fieldView.stackView.addArrangedSubview(cityTextField)
	}
}
