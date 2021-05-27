//
//  CheckoutFlowMainView.swift
//  VGSCheckoutDemoApp
//

import Foundation
import UIKit

/// Checkout main view delegate.
protocol CheckoutFlowMainViewDelegate: AnyObject {
	func checkoutButtonDidTap(in view: CheckoutFlowMainView)
}

class CheckoutFlowMainView: UIView {

	// MARK: - Vars

	weak var delegate: CheckoutFlowMainViewDelegate?

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

	/// Button
	private lazy var button: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
		button.backgroundColor = .systemBlue
		button.layer.cornerRadius = 6
		button.layer.masksToBounds = true
		button.setTitle("CHECKOUT", for: .normal)

		return button
	}()

	/// Shopping cart view.
	lazy var shoppingCartView: ShoppingCartView = {
		let view = ShoppingCartView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	// MARK: - Initializer

	override init(frame: CGRect) {
		super.init(frame: .zero)

		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Helpers

	/// Setup basic UI.
	private func setupUI() {
		addSubview(stackView)
		stackView.checkoutDemo_constraintViewToSuperviewEdges()
		stackView.addArrangedSubview(shoppingCartView)
		stackView.addArrangedSubview(button)

		button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
	}

	// MARK: - Actions

	/// Tap on button action.
	@objc private func buttonDidTap() {
		delegate?.checkoutButtonDidTap(in: self)
	}
}
