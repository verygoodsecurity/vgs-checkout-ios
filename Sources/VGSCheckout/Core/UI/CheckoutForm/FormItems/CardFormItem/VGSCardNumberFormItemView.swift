//
//  VGSCardNumberFormItemView.swift
//  VGSCheckoutSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal class VGSCardNumberFormItemView: UIView, VGSTextFieldFormItemProtocol {

	// MARK: - Vars

	internal let fieldType: VGSAddCardFormFieldType = .cardNumber

	let formItemView = VGSPlaceholderFormItemView(frame: .zero)

	var textField: VGSTextField {
		return cardTextField
	}

	lazy var cardTextField: VGSCardTextField = {
		let field = VGSCardTextField()
		field.translatesAutoresizingMaskIntoConstraints = false

		field.placeholder = "4111 1111 1111 1111"

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
		addSubview(formItemView)
		formItemView.translatesAutoresizingMaskIntoConstraints = false
		formItemView.checkout_constraintViewToSuperviewEdges()

		formItemView.hintComponentView.label.text = "Card number"
		formItemView.stackView.addArrangedSubview(cardTextField)
	}
}
