//
//  ShoppingCartView.swift
//  VGSCheckoutDemoApp
//

import Foundation
import UIKit

/// Shopping cart view.
class ShoppingCartView: UIView {

	// MARK: - Vars

	/// Stack view.
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.axis = .vertical
		stackView.spacing = 8
		stackView.distribution = .fill
		stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
		stackView.isLayoutMarginsRelativeArrangement = true

		return stackView
	}()

	/// Horizontal stack view for total price.
	private lazy var totalPriceStackView: UIStackView = {
		let stackView = UIStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.axis = .horizontal
		stackView.spacing = 8
		stackView.distribution = .fill
		stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
		stackView.isLayoutMarginsRelativeArrangement = true

		return stackView
	}()

	/// Order title label.
	private lazy var orderTitleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.preferredFont(forTextStyle: .title2)
		label.adjustsFontForContentSizeCategory = true
		label.text = "Your order"

		return label
	}()

	/// Total hint label.
	private lazy var totalHintLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.preferredFont(forTextStyle: .title1)
		label.adjustsFontForContentSizeCategory = true
		label.text = "Total"

		return label
	}()

	/// Separator view.
	private lazy var separatorView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.heightAnchor.constraint(equalToConstant: 1).isActive = true
		view.backgroundColor = .systemGray

		return view
	}()

	/// Image view.
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit

		return imageView
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

	/// Configure with items.
	/// - Parameter items: `[OrderItem]` object.
	func configure(with items: [OrderItem]) {
		stackView.arrangedSubviews.forEach { view in
			stackView.removeArrangedSubview(view)
		}
		stackView.addArrangedSubview(orderTitleLabel)

		for item in items {
			let itemView = ShoppingCartItemView(frame: .zero)
			itemView.configure(with: item)

			stackView.addArrangedSubview(itemView)
		}

		stackView.addArrangedSubview(separatorView)
		stackView.addArrangedSubview(totalPriceStackView)

		priceLabel.text = "$\(items.totalPrice)"
	}

	// MARK: - Helpers

	/// Setup basic UI and layout.
	private func setupUI() {
		addSubview(stackView)
		stackView.checkoutDemo_constraintViewToSuperviewEdges()
		stackView.addArrangedSubview(orderTitleLabel)

		totalPriceStackView.addArrangedSubview(totalHintLabel)
		totalPriceStackView.addArrangedSubview(priceLabel)
	}
}
