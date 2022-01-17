//
//  VGSPaymentOptionCardTableViewCell.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

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
		view.layer.cornerRadius = 8
		view.layer.masksToBounds = true

		return view
	}()

	/// Vertical stack view.
	internal lazy var cardDetailsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 8, right: 0)
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.distribution = .fill
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

	/// Checkbox container view.
	fileprivate lazy var checkboxContainerView: UIView = {
		let view = UIView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	/// Checkbox.
	fileprivate var checkbox: VGSRoundedCheckbox?

	// MARK: - Interface

	internal func configure(with viewModel: VGSPaymentOptionCardCellViewModel, uiTheme: VGSCheckoutThemeProtocol) {

		cardHolderLabel.textColor = uiTheme.checkoutSavedCardCardholderTitleColor
		cardHolderLabel.font = uiTheme.checkoutSavedCardCardholderTitleFont

		cardDetailsLabel.textColor = uiTheme.checkoutSavedCardDetailsTitleColor
		cardDetailsLabel.font = uiTheme.checkoutSavedCardDetailsTitleFont

		itemContainerView.backgroundColor = uiTheme.checkoutPaymentOptionBackgroundColor

		cardBrandImageView.image = viewModel.cardBrandImage
		cardHolderLabel.text = viewModel.cardHolder?.uppercased()
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
		if viewModel.isSelected {
			cardHolderLabel.textColor = uiTheme.checkoutSavedCardCardholderTitleColor
			itemContainerView.layer.borderColor = uiTheme.checkoutSavedCardSelectedBorderColor.cgColor
			itemContainerView.layer.borderWidth = 1
		} else {
			cardHolderLabel.textColor = UIColor.vgsInputBlackTextColor
			itemContainerView.layer.borderWidth = 0
		}
	}

	// MARK: - Helpers

	/// Setups UI.
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
