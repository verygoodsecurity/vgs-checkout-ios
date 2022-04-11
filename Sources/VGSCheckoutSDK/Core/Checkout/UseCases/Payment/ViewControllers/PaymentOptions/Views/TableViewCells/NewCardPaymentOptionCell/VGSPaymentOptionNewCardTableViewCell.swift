//
//  VGSPaymentOptionNewCardTableViewCell.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

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
		view.layer.cornerRadius = 8
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
	fileprivate lazy var addNewCardLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.text = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_payment_options_add_new_card_title")

		return label
	}()

	// MARK: - Interface

	/// Configure cell.
	/// - Parameter uiTheme: `VGSCheckoutThemeProtocol` object, ui theme.
	internal func configure(with uiTheme: VGSCheckoutThemeProtocol) {
		itemContainerView.backgroundColor = uiTheme.checkoutPaymentOptionBackgroundColor
		addNewCardLabel.textColor = uiTheme.checkoutPaymentOptionNewCardTitleColor
		addNewCardLabel.font = uiTheme.checkoutPaymentOptionNewCardTitleFont
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
		itemContainerView.stackView.addArrangedSubview(addNewCardLabel)
	}
}
