//
//  VGSCardNumberFormItemView.swift
//  VGSCheckoutSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal class VGSCardNumberFieldView: UIView, VGSTextFieldViewProtocol {

	// MARK: - Vars

	internal let fieldType: VGSAddCardFormFieldType = .cardNumber

	let fieldView = VGSPlaceholderFormItemView(frame: .zero)

	var textField: VGSTextField {
		return cardTextField
	}

	lazy var cardTextField: VGSCardTextField = {
		let field = VGSCardTextField()
		field.translatesAutoresizingMaskIntoConstraints = false

		field.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_number_hint")

		field.adjustsFontForContentSizeCategory = true
		field.cardIconSize = CGSize(width: 32, height: 20)
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

		fieldView.hintComponentView.label.text = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_number_subtitle")
		fieldView.stackView.addArrangedSubview(cardTextField)
	}
}
