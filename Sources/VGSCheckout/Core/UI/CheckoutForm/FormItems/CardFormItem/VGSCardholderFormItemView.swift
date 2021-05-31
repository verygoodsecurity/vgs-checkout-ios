//
//  VGSCardholderFormItemView.swift
//  VGSCollectSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCollectSDK

internal class VGSCardholderFormItemView: UIView, VGSTextFieldFormComponentProtocol {

	// MARK: - Vars

	let placeholderComponent = VGSPlaceholderComponentView(frame: .zero)

	var textField: VGSTextField {
		return cardHolderName
	}

	lazy var cardHolderName: VGSTextField = {
		let field = VGSTextField()
		field.translatesAutoresizingMaskIntoConstraints = false

		field.placeholder = "Cardholder"

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

	/// Setup UI.
	private func buildUI() {
		addSubview(placeholderComponent)
		placeholderComponent.translatesAutoresizingMaskIntoConstraints = false
		placeholderComponent.checkout_constraintViewToSuperviewEdges()

		placeholderComponent.hintComponentView.label.text = "Cardholder"
		placeholderComponent.stackView.addArrangedSubview(cardHolderName)
	}
}
