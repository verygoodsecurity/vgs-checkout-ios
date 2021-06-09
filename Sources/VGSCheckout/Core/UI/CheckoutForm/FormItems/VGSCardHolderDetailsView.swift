//
//  VGSCardHolderDetailsView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for card holder details.
internal class VGSCardHolderDetailsView: UIView {

	/// Defines field distribution in card details section.
	internal enum FieldsDistribution {
		case singleLine
		case doubleLine
	}

	/// Fields distribution.
	internal var fieldsDistribution: FieldsDistribution = .singleLine

	/// Payment instrument.
	fileprivate let paymentInstrument: VGSPaymentInstrument

	/// Horizontal stack view for card holder name.
	internal lazy var cardHolderNameStackView: VGSSeparatedStackView = {
		let stackView = VGSSeparatedStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.distribution = .fillEqually
		stackView.axis = .horizontal

		stackView.hasBorderView = true
		stackView.borderViewCornerRadius = 4

		stackView.spacing = 1
		stackView.separatorColor = UIColor.gray

		return stackView
	}()

	// MARK: - Initialization

	init(paymentInstrument: VGSPaymentInstrument) {
		self.paymentInstrument = paymentInstrument
		super.init(frame: .zero)

		setupUI()
	}

	/// no:doc
	required init?(coder: NSCoder) {
		fatalError("Not implemented")
	}

	// MARK: - Helpers

	/// Setup basic UI and layout.
	fileprivate func setupUI() {
		addSubview(cardHolderNameStackView)
		cardHolderNameStackView.checkout_constraintViewToSuperviewEdges()

		switch paymentInstrument {
		case .vault(let configuration):
			let cardHolderDetails = configuration.cardHolderFieldOptions
			if cardHolderDetails.fieldVisibility == .visible {
				switch cardHolderDetails.fieldNameType {
				case .single:
					let itemView = VGSCardholderFormItemView(frame: .zero)
					cardHolderNameStackView.addArrangedSubview(itemView)
					itemView.placeholderComponent.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
					itemView.placeholderComponent.stackView.isLayoutMarginsRelativeArrangement = true

					itemView.cardHolderName.placeholder = "John Doe"
					itemView.placeholderComponent.hintComponentView.label.text = "Cardholder"
				case .splitted:
					setupSplittedFieldName()
				}
			}
		}
	}

	fileprivate func setupSplittedFieldName() {
		switch fieldsDistribution {
		case .singleLine:
			cardHolderNameStackView.axis = .horizontal
		case .doubleLine:
			cardHolderNameStackView.axis = .vertical
		}

		let firstNameItemView = VGSCardholderFormItemView(frame: .zero)
		let lastNameItemView = VGSCardholderFormItemView(frame: .zero)

		firstNameItemView.cardHolderName.placeholder = "John"
		lastNameItemView.cardHolderName.placeholder = "Doe"

		firstNameItemView.formFieldType = .firstName
		lastNameItemView.formFieldType = .lastName

		firstNameItemView.placeholderComponent.hintComponentView.label.text = "First Name"
		lastNameItemView.placeholderComponent.hintComponentView.label.text = "Last Name"

		firstNameItemView.placeholderComponent.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		firstNameItemView.placeholderComponent.stackView.isLayoutMarginsRelativeArrangement = true

		lastNameItemView.placeholderComponent.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		lastNameItemView.placeholderComponent.stackView.isLayoutMarginsRelativeArrangement = true

		cardHolderNameStackView.addArrangedSubview(firstNameItemView)
		cardHolderNameStackView.addArrangedSubview(lastNameItemView)
	}
}
