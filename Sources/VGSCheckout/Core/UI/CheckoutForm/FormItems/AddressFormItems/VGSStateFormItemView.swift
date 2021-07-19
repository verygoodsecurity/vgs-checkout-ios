//
//  VGSStateFormItemView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for state form item.
internal class VGSStateFormItemView: UIView, VGSTextFieldViewProtocol {

	// MARK: - Vars

	internal var fieldType: VGSAddCardFormFieldType = .state

	let fieldView = VGSPlaceholderFormItemView(frame: .zero)

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
		addSubview(fieldView)
		fieldView.translatesAutoresizingMaskIntoConstraints = false
		fieldView.checkout_constraintViewToSuperviewEdges()

		fieldView.hintComponentView.label.text = "State"
		fieldView.stackView.addArrangedSubview(stateTextField)
	}
}
