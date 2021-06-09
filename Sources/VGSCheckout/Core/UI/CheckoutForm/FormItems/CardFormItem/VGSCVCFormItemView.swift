//
//  VGSCVCFormComponentView.swift
//  VGSCollectSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCollectSDK

internal class VGSCVCFormItemView: UIView, VGSTextFieldFormComponentProtocol {

	// MARK: - Vars

	internal let formFieldType: VGSAddCardFormFieldType = .cvc

	let placeholderComponent = VGSPlaceholderFormItemView(frame: .zero)

	var textField: VGSTextField {
		return cvcTextField
	}

	lazy var cvcTextField: VGSCVCTextField = {
		let field = VGSCVCTextField()
		field.translatesAutoresizingMaskIntoConstraints = false

		field.placeholder = "CVC"

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

		placeholderComponent.hintComponentView.label.text = "CVC"
		placeholderComponent.stackView.addArrangedSubview(cvcTextField)
	}
}
