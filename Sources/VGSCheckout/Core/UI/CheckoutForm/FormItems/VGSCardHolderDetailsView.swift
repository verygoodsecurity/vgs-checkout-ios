//
//  VGSCardHolderDetailsView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for card holder details.
internal class VGSCardHolderDetailsView: UIView {

	/// Form items.
	internal var formItems: [VGSTextFieldViewProtocol] = []

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

	internal init(paymentInstrument: VGSPaymentInstrument) {
		self.paymentInstrument = paymentInstrument
		super.init(frame: .zero)

		setupUI()
	}

	/// no:doc
	internal required init?(coder: NSCoder) {
		fatalError("Not implemented")
	}

	// MARK: - Helpers

	/// Setup basic UI and layout.
	private func setupUI() {
		addSubview(cardHolderNameStackView)
		cardHolderNameStackView.checkout_constraintViewToSuperviewEdges()

		switch paymentInstrument {
		case .vault(let configuration):
			let cardHolderDetails = configuration.cardHolderFieldOptions
			if cardHolderDetails.fieldVisibility == .visible {
				switch cardHolderDetails.fieldNameType {
				case .single:
					setupSingleFieldName()
//				case .splitted:
//					setupSplittedFieldName()
				}
			}
		case .multiplexing(let multiplexing):
			setupSingleFieldName()
		}
	}

	private func setupSingleFieldName() {
		let itemView = VGSCardholderFieldView(frame: .zero)
		cardHolderNameStackView.addArrangedSubview(itemView)
		itemView.fieldView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		itemView.fieldView.stackView.isLayoutMarginsRelativeArrangement = true

		itemView.cardHolderName.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_holder_hint")
		itemView.fieldView.hintComponentView.label.text = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_holder_subtitle")

		formItems = [itemView]
	}

	/// Setup splitted card holder fields.
	private func setupSplittedFieldName() {

		let firstNameItemView = VGSCardholderFieldView(frame: .zero)
		let lastNameItemView = VGSCardholderFieldView(frame: .zero)

		firstNameItemView.cardHolderName.placeholder = "John"
		lastNameItemView.cardHolderName.placeholder = "Doe"

		firstNameItemView.fieldType = .firstName
		lastNameItemView.fieldType = .lastName

		switch fieldsDistribution {
		case .singleLine:
			cardHolderNameStackView.axis = .horizontal
		case .doubleLine:
			cardHolderNameStackView.axis = .vertical
		}

		formItems = [firstNameItemView, lastNameItemView]

		firstNameItemView.fieldView.hintComponentView.label.text = "First Name"
		lastNameItemView.fieldView.hintComponentView.label.text = "Last Name"

		firstNameItemView.fieldView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		firstNameItemView.fieldView.stackView.isLayoutMarginsRelativeArrangement = true

		lastNameItemView.fieldView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		lastNameItemView.fieldView.stackView.isLayoutMarginsRelativeArrangement = true

		cardHolderNameStackView.addArrangedSubview(firstNameItemView)
		cardHolderNameStackView.addArrangedSubview(lastNameItemView)
	}
}
