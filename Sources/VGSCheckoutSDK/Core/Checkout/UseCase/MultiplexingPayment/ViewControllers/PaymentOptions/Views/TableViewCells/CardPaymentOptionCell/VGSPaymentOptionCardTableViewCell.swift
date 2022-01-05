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

		let last4Text = "**** \(last4) | \(expDate)"

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

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	/// Vertical stack view.
	internal lazy var cardDetailsVerticalStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.spacing = 4

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
		label.numberOfLines = 1

		return label
	}()

	/// Card details label.
	fileprivate lazy var cardDetailsLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 1

		return label
	}()

	internal func configure(with viewModel: VGSPaymentOptionCardCellViewModel, uiTheme: VGSCheckoutThemeProtocol) {

		contentView.subviews.forEach { subview in
			subview.removeFromSuperview()
		}

		let optionsItemView = VGSPaymentOptionItemView(uiTheme: uiTheme)
		optionsItemView.translatesAutoresizingMaskIntoConstraints  = false
		contentView.addSubview(optionsItemView)

		optionsItemView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
		optionsItemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		optionsItemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
		optionsItemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

		optionsItemView.stackView.arrangedSubviews.forEach { arrangedSubview in
			optionsItemView.stackView.removeArrangedSubview(arrangedSubview)
		}

		cardBrandImageView.image = viewModel.cardBrandImage
		cardDetailsVerticalStackView.addArrangedSubview(cardHolderLabel)
		cardHolderLabel.text = viewModel.cardHolder
		cardDetailsVerticalStackView.addArrangedSubview(cardDetailsLabel)
		cardDetailsLabel.text = viewModel.last4AndExpDateText

		optionsItemView.stackView.addArrangedSubview(cardBrandImageView)
		optionsItemView.stackView.addArrangedSubview(cardDetailsVerticalStackView)
	}
}
