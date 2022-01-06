//
//  VGSPaymentOptionCardTableViewCell.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

// GET array of saved card by id1,id2

internal struct VGSSavedCardModel {
	internal let id: String
	internal let cardBrand: String
	internal let last4: String
	internal let expDate: String
	internal let cardHolder: String
	internal var isSelected = false

	internal var paymentOptionCellViewModel: VGSPaymentOptionCardCellViewModel {
		var image = VGSCheckoutPaymentCards.visa.brand.brandIcon
		if cardBrand == VGSCheckoutPaymentCards.maestro.name {
			image = VGSCheckoutPaymentCards.maestro.brandIcon
		}

		let last4Text = "•••• \(last4) | \(expDate)"

		return VGSPaymentOptionCardCellViewModel(cardBrandImage: image, cardHolder: cardHolder, last4AndExpDateText: last4Text, isSelected: isSelected)
	}
}

internal enum VGSPaymentOption {
	case savedCard(_ card: VGSSavedCardModel)
	case newCard
}

internal struct VGSPaymentOptionCardCellViewModel {
	internal let cardBrandImage: UIImage?
	internal let cardHolder: String?
	internal let last4AndExpDateText: String?
	internal var isSelected: Bool
}

/// Holds UI for payment options screen.
internal class VGSPaymentOptionCardTableViewCell: UITableViewCell {

	// MARK: - Initialization

	// no:doc
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}

	/// no:doc
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Vars

	/// Container view.
	internal lazy var itemContainerView: VGSPaymentOptionItemContainerView = {
		let view = VGSPaymentOptionItemContainerView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.stackView.setContentCompressionResistancePriority(.required, for: .vertical)
		view.layer.cornerRadius = 6
		view.layer.masksToBounds = true

		return view
	}()

	/// Vertical stack view.
	internal lazy var cardDetailsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 4, right: 0)
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.distribution = .equalCentering

		return stackView
	}()

	/// Card brand image image view.
	fileprivate lazy var cardBrandImageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
		imageView.contentMode = .scaleAspectFit

		return imageView
	}()

	/// Card holder label.
	fileprivate lazy var cardHolderLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0

		return label
	}()

	/// Card details label.
	fileprivate lazy var cardDetailsLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0

		return label
	}()

	// MARK: - Interface

	internal func configure(with viewModel: VGSPaymentOptionCardCellViewModel, uiTheme: VGSCheckoutThemeProtocol) {

		cardHolderLabel.textColor = uiTheme.checkoutSavedCardCardholderTitleColor
		cardHolderLabel.font = uiTheme.checkoutSavedCardCardholderTitleFont

		cardDetailsLabel.textColor = uiTheme.checkoutSavedCardDetailsTitleColor
		cardDetailsLabel.font = uiTheme.checkoutSavedCardDetailsTitleFont

		itemContainerView.backgroundColor = uiTheme.checkoutPaymentOptionBackgroundColor

		cardBrandImageView.image = viewModel.cardBrandImage
		cardHolderLabel.text = viewModel.cardHolder
		cardDetailsLabel.text = viewModel.last4AndExpDateText
	}

	// MARK: - Helpers

	/// Setup UI.
	private func setupUI() {
		selectionStyle = .none
		contentView.backgroundColor = .clear
		backgroundColor = .clear
		contentView.addSubview(itemContainerView)

		itemContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
		itemContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		itemContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
		itemContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

		itemContainerView.stackView.addArrangedSubview(cardBrandImageView)
		itemContainerView.stackView.addArrangedSubview(cardDetailsStackView)

		cardDetailsStackView.addArrangedSubview(cardHolderLabel)
		cardDetailsStackView.addArrangedSubview(cardDetailsLabel)
	}
}
