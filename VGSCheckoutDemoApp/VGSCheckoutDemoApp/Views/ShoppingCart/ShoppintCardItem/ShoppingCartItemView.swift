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

		return stackView
	}()

	/// Image view.
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleToFill
		
		imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
		imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true

		return imageView
	}()

	/// Title label.
	private lazy var titleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.numberOfLines = 0
		label.adjustsFontSizeToFitWidth = true
		label.font = UIFont.preferredFont(forTextStyle: .title3)
		label.adjustsFontForContentSizeCategory = true
		label.textAlignment = .left
		label.lineBreakMode = .byTruncatingTail
		label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

		return label
	}()

	/// Price label.
	private lazy var priceLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.preferredFont(forTextStyle: .title3).demoapp_bold()
		label.adjustsFontForContentSizeCategory = true
		label.textAlignment = .right

		label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

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
		priceLabel.text = "$\(item.priceText)"
	}

	// MARK: - Helpers

	/// Setup basic UI and layout.
	private func setupUI() {
		if #available(iOS 13.0, *) {
			backgroundColor = .systemBackground
		} else {
			backgroundColor = .white
		}
		addSubview(stackView)
		stackView.checkoutDemo_constraintViewToSuperviewEdges()

		stackView.addArrangedSubview(imageView)
		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(priceLabel)
	}
}
