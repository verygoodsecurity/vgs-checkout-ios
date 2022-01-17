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

	init?(json: JsonData) {
		guard let dataJSON = json["data"] as? JsonData,
					let id = dataJSON["id"] as? String,
				let cardJSON = dataJSON["card"] as? JsonData,
		let cardNumber = cardJSON["number"] as? String,
		let name = cardJSON["name"] as? String,
		let expYear = cardJSON["exp_year"] as? Int,
		let expMonth = cardJSON["exp_month"] as? Int,
		let brand = cardJSON["brand"] as? String
		else {
			return nil
		}
		self.id = id
		self.cardHolder = name
		self.last4 = String(cardNumber.suffix(4))
		self.expDate = "\(expMonth)/" + "\(expYear)"
		self.cardBrand = brand
	}

	internal var paymentOptionCellViewModel: VGSPaymentOptionCardCellViewModel {
		var image = VGSCheckoutPaymentCards.visa.brand.brandIcon
		if cardBrand == VGSCheckoutPaymentCards.maestro.name {
			image = VGSCheckoutPaymentCards.maestro.brandIcon
		}

		let last4Text = "•••• \(last4) | \(expDate)"

		return VGSPaymentOptionCardCellViewModel(cardBrandImage: image, cardHolder: cardHolder, last4AndExpDateText: last4Text, isSelected: isSelected)
	}
}

internal extension Array where Element == VGSSavedCardModel {
	func reorderByIds(_ cardIds: [String]) -> [VGSSavedCardModel] {
		var orderedArray: [VGSSavedCardModel] = []
		cardIds.forEach { id in
			for card in self {
				if card.id == id {
					orderedArray.append(card)
				}
			}
		}

		return orderedArray
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

/// Holds UI for saved card payment option cell.
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

	///
	fileprivate lazy var checkboxContainerView: UIView = {
		let view = UIView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()


	/// Checkbox
	fileprivate var checkbox: VGSRoundedCheckbox?

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

		if checkbox == nil {
			let roundedCheckbox = VGSRoundedCheckbox(theme: uiTheme)
			roundedCheckbox.translatesAutoresizingMaskIntoConstraints = false
			checkboxContainerView.addSubview(roundedCheckbox)
			roundedCheckbox.centerXAnchor.constraint(equalTo: checkboxContainerView.centerXAnchor).isActive = true
			roundedCheckbox.centerYAnchor.constraint(equalTo: checkboxContainerView.centerYAnchor).isActive = true
			checkbox = roundedCheckbox
		}
		checkbox?.isSelected = viewModel.isSelected
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
		itemContainerView.stackView.addArrangedSubview(checkboxContainerView)
		checkboxContainerView.widthAnchor.constraint(equalToConstant: 22).isActive = true

		cardDetailsStackView.addArrangedSubview(cardHolderLabel)
		cardDetailsStackView.addArrangedSubview(cardDetailsLabel)
	}
}

/// Holds UI for new card payment option cell.
internal class VGSPaymentOptionNewCardTableViewCell: UITableViewCell {

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

	/// New card image image view.
	fileprivate lazy var newCardImageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
		imageView.contentMode = .scaleAspectFit
		imageView.image = UIImage(named: "new-card-payment-option", in: BundleUtils.shared.resourcesBundle, compatibleWith: nil)

		return imageView
	}()

	/// Pay with card label.
	fileprivate lazy var payWithCardLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.text = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_payment_options_pay_with_new_card_title")

		return label
	}()

	// MARK: - Interface

	internal func configure(with uiTheme: VGSCheckoutThemeProtocol) {
		itemContainerView.backgroundColor = uiTheme.checkoutPaymentOptionBackgroundColor
		payWithCardLabel.textColor = uiTheme.checkoutPaymentOptionNewCardTitleColor
		payWithCardLabel.font = uiTheme.checkoutPaymentOptionNewCardTitleFont
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

		itemContainerView.stackView.addArrangedSubview(newCardImageView)
		itemContainerView.stackView.addArrangedSubview(payWithCardLabel)
	}
}
