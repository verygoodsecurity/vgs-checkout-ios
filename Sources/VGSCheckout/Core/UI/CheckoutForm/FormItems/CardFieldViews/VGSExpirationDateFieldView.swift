//
//  VGSExpirationDateFieldView.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal class VGSExpirationDateFieldView: UIView, VGSTextFieldViewProtocol {

	// MARK: - Vars

	let placeholderView = VGSPlaceholderFieldView(frame: .zero)

	var textField: VGSTextField {
		return expDateTextField
	}

	let fieldType: VGSAddCardFormFieldType = .expirationDate

	lazy var expDateTextField: VGSExpDateTextField = {
		let field = VGSExpDateTextField()
		field.translatesAutoresizingMaskIntoConstraints = false

		field.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_expiration_date_hint")

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

		placeholderView.hintComponentView.label.text = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_expiration_date_subtitle")
		placeholderView.stackView.addArrangedSubview(expDateTextField)
	}
}