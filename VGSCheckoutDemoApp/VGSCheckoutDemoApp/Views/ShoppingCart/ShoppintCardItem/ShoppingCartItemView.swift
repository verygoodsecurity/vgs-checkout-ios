//
//  ShoppingCartItemView.swift
//  VGSCheckoutDemoApp
//

import Foundation
import UIKit

/// View for shopping cart item.
class ShoppingCartItemView: UIView {

	// MARK: - Vars

	/// Stack view.
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.spacing = 8
		stackView.distribution = .fill
		stackView.axis = .horizontal
		stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
		stackView.isLayoutMarginsRelativeArrangement = true

		return stackView
	}()

	/// Image view.
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit

		return imageView
	}()

	/// Title label.
	private lazy var titleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.preferredFont(forTextStyle: .body)
		label.adjustsFontForContentSizeCategory = true

		return label
	}()

	/// Price label.
	private lazy var priceLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.preferredFont(forTextStyle: .title2)
		label.adjustsFontForContentSizeCategory = true

		return label
	}()

	// MARK: - Initialization

	override init(frame: CGRect) {
		super.init(frame: frame)

		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Interface

	/// Configure UI with item.
	/// - Parameter item: `OrderItem` object.
	func configure(with item: OrderItem) {
		titleLabel.text = item.title
		imageView.image = item.image
		priceLabel.text = "$\(item.price)"
	}

	// MARK: - Helpers

	/// Setup basic UI and layout.
	private func setupUI() {
		addSubview(stackView)
		stackView.checkoutDemo_constraintViewToSuperviewEdges()

		stackView.addArrangedSubview(imageView)
		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(priceLabel)
	}
}
