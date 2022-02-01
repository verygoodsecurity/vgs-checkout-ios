//
//  VGSCardHolderDetailsView.swift
//  VGSCheckoutSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for card holder details.
internal class VGSCardHolderDetailsView: UIView {

	/// Form items.
	internal var fildViews: [VGSTextFieldViewProtocol] = []

	/// Defines field distribution in card details section.
	internal enum FieldsDistribution {
		case singleLine
		case doubleLine
	}

	/// Fields distribution.
	internal var fieldsDistribution: FieldsDistribution = .singleLine

	/// Payment instrument.
	fileprivate let checkoutConfigurationType: VGSCheckoutConfigurationType

	/// Horizontal stack view for card holder name.
	internal lazy var cardHolderNameStackView: UIStackView = {
		let stackView = UIStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fillEqually
		stackView.axis = .horizontal

		return stackView
	}()

	// MARK: - Initialization

	internal init(checkoutConfigurationType: VGSCheckoutConfigurationType) {
		self.checkoutConfigurationType = checkoutConfigurationType
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

		switch checkoutConfigurationType {
		case .custom(let configuration):
			let cardHolderDetails = configuration.cardHolderFieldOptions
			if cardHolderDetails.fieldVisibility == .visible {
				switch cardHolderDetails.fieldNameType {
				case .single:
					setupSingleFieldName()
//				case .splitted:
//					setupSplittedFieldName()
				}
			}
		case .payoptAddCard, .payoptTransfers:
			setupSingleFieldName()
		}
	}

	private func setupSingleFieldName() {
		let itemView = VGSCardholderFieldView(frame: .zero)
		cardHolderNameStackView.addArrangedSubview(itemView)
		itemView.placeholderView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		itemView.placeholderView.stackView.isLayoutMarginsRelativeArrangement = true

		itemView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_holder_hint")
		itemView.placeholderView.hintComponentView.label.text = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_holder_subtitle")

		fildViews = [itemView]
	}

//	/// Setup splitted card holder fields.
//	private func setupSplittedFieldName() {
//
//		let firstNameItemView = VGSCardholderFieldView(frame: .zero)
//		let lastNameItemView = VGSCardholderFieldView(frame: .zero)
//
//		firstNameItemView.cardHolderName.placeholder = "John"
//		lastNameItemView.cardHolderName.placeholder = "Doe"
//
//		firstNameItemView.fieldType = .firstName
//		lastNameItemView.fieldType = .lastName
//
//		switch fieldsDistribution {
//		case .singleLine:
//			cardHolderNameStackView.axis = .horizontal
//		case .doubleLine:
//			cardHolderNameStackView.axis = .vertical
//		}
//
//		fildViews = [firstNameItemView, lastNameItemView]
//
//		firstNameItemView.placeholderView.hintComponentView.label.text = "First Name"
//		lastNameItemView.placeholderView.hintComponentView.label.text = "Last Name"
//
//		firstNameItemView.placeholderView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
//		firstNameItemView.placeholderView.stackView.isLayoutMarginsRelativeArrangement = true
//
//		lastNameItemView.placeholderView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
//		lastNameItemView.placeholderView.stackView.isLayoutMarginsRelativeArrangement = true
//
//		cardHolderNameStackView.addArrangedSubview(firstNameItemView)
//		cardHolderNameStackView.addArrangedSubview(lastNameItemView)
//	}
}
