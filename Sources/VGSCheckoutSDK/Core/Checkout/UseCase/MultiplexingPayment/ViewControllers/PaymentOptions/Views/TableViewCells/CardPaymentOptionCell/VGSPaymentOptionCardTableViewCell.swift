//
//  VGSPaymentOptionCardTableViewCell.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

internal struct VGSSavedCardModel {
	internal let id: String
	internal let cardBrand: String
	internal let last4: String
	internal let expDate: String
	internal let cardHolder: String
}

internal enum VGSPaymentMethod {
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
		contentView.addSubview(optionsItemView)
		optionsItemView.checkout_constraintViewToSuperviewEdges()

		optionsItemView.stackView.arrangedSubviews.forEach { arrangedSubview in
			optionsItemView.stackView.removeArrangedSubview(arrangedSubview)
		}

		cardDetailsVerticalStackView.addArrangedSubview(cardHolderLabel)
		cardDetailsVerticalStackView.addArrangedSubview(cardDetailsLabel)

		optionsItemView.stackView.addArrangedSubview(cardBrandImageView)
		optionsItemView.stackView.addArrangedSubview(cardDetailsVerticalStackView)
	}
}
