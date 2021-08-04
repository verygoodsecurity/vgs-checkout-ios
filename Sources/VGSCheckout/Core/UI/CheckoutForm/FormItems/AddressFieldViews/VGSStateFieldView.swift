//
//  VGSStateFieldView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for state form item.
internal class VGSStateFieldView: UIView, VGSTextFieldViewProtocol {

	// MARK: - Vars

	internal var fieldType: VGSAddCardFormFieldType = .state

	let placeholderView = VGSPlaceholderFieldView(frame: .zero)

	var textField: VGSTextField {
		return stateTextField
	}

	lazy var stateTextField: VGSTextField = {
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
		addSubview(placeholderView)
		placeholderView.translatesAutoresizingMaskIntoConstraints = false
		placeholderView.checkout_constraintViewToSuperviewEdges()

		placeholderView.hintComponentView.label.text = "State"
		placeholderView.stackView.addArrangedSubview(stateTextField)
	}
}
