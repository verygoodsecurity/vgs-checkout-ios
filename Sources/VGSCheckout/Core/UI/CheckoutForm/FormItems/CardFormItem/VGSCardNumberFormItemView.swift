//
//  VGSCardNumberFormItemView.swift
//  VGSCheckoutSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCollectSDK

internal class VGSCardNumberFormItemView: UIView, VGSTextFieldFormComponentProtocol {

	// MARK: - Vars

	internal let formFieldType: VGSAddCardFormFieldType = .cardNumber

	let placeholderComponent = VGSPlaceholderFormItemView(frame: .zero)

	var textField: VGSTextField {
		return cardTextField
	}

	lazy var cardTextField: VGSCardTextField = {
		let field = VGSCardTextField()
		field.translatesAutoresizingMaskIntoConstraints = false

		field.placeholder = "4111 1111 1111 1111"

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
		addSubview(placeholderComponent)
		placeholderComponent.translatesAutoresizingMaskIntoConstraints = false
		placeholderComponent.checkout_constraintViewToSuperviewEdges()

		placeholderComponent.hintComponentView.label.text = "Card number"
		placeholderComponent.stackView.addArrangedSubview(cardTextField)
	}
}
