//
//  ShoppingCartView.swift
//  VGSCheckoutDemoApp
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

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

		return stackView
	}()

	/// Items stack view.
	private lazy var itemsStackView: UIStackView = {
		let stackView = UIStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false

		if #available(iOS 13.0, *) {
			stackView.backgroundColor = .systemBackground
		} else {
			stackView.backgroundColor = .white
		}
		stackView.layer.cornerRadius = 6
		stackView.layer.masksToBounds = true

		stackView.axis = .vertical
		stackView.spacing = 0
		stackView.distribution = .fill
		stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
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

		return stackView
	}()

	/// Order title label.
	private lazy var orderTitleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.preferredFont(forTextStyle: .largeTitle).demoapp_bold()
		label.adjustsFontForContentSizeCategory = true
		label.text = "Your order"
		label.textAlignment = .left

		return label
	}()

	/// Total hint label.
	private lazy var totalHintLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.preferredFont(forTextStyle: .title2).demoapp_bold()
		label.adjustsFontForContentSizeCategory = true
		label.adjustsFontSizeToFitWidth = true
		label.textAlignment = .left
		label.text = "Total"
		label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

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

	/// Price label.
	private lazy var priceLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.preferredFont(forTextStyle: .title2).demoapp_bold()
		
		label.adjustsFontForContentSizeCategory = true
		label.textAlignment = .right

		label.setContentHuggingPriority(.defaultLow, for: .horizontal)

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
		stackView.addArrangedSubview(itemsStackView)

		for item in items {
			let itemView = ShoppingCartItemView(frame: .zero)
			itemView.configure(with: item)

			itemsStackView.addArrangedSubview(itemView)
		}

		stackView.addArrangedSubview(separatorView)
		stackView.addArrangedSubview(totalPriceStackView)

		priceLabel.text = "$\(items.totalPriceText)"
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
