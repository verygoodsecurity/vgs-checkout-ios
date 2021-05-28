//
//  CheckoutFlowMainView.swift
//  VGSCheckoutDemoApp
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Checkout main view delegate.
protocol CheckoutFlowMainViewDelegate: AnyObject {
	func checkoutButtonDidTap(in view: CheckoutFlowMainView)
}

/// Main view for checkout screens.
class CheckoutFlowMainView: UIView {

	// MARK: - Vars

	/// An object that acts as a view delegate.
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

	/// Container view with insets for button.
	private lazy var buttonContainerView: DemoInsetContainerView = {
		let view = DemoInsetContainerView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	/// Button.
	private lazy var button: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
		button.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

		button.adjustsImageSizeForAccessibilityContentSizeCategory = true
		button.backgroundColor = .systemBlue
		button.layer.cornerRadius = 6
		button.layer.masksToBounds = true
		button.setTitle("CHECKOUT", for: .normal)
		button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2).demoapp_bold()
		button.titleLabel?.adjustsFontForContentSizeCategory = true

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
		if #available(iOS 13.0, *) {
			backgroundColor = .systemGroupedBackground
		} else {
			backgroundColor = UIColor(demoHexString: "#f2f2f7ff")
		}

		addSubview(stackView)
		stackView.checkoutDemo_constraintViewToSuperviewEdges()
		stackView.addArrangedSubview(shoppingCartView)

		let emptyBottomView = UIView()
		emptyBottomView.backgroundColor = .clear
		emptyBottomView.translatesAutoresizingMaskIntoConstraints = false

		buttonContainerView.paddings = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
		buttonContainerView.addContentView(button)
		stackView.addArrangedSubview(buttonContainerView)

		stackView.addArrangedSubview(emptyBottomView)

		button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
	}

	// MARK: - Actions

	/// Tap on button action.
	@objc private func buttonDidTap() {
		delegate?.checkoutButtonDidTap(in: self)
	}
}
