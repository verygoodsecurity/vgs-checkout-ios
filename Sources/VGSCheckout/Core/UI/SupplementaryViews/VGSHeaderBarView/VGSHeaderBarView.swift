//
//  VGSHeaderBarView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal protocol VGSHeaderBarViewDelegate: AnyObject {
	func buttonDidTap(in header: VGSHeaderBarView)
}

/// Custom header bar vier for checkout.
internal class VGSHeaderBarView: UIView {

  // MARK: - Vars

	/// An object that acts as a delegate of `VGSHeaderBarView`.
	internal weak var delegate: VGSHeaderBarViewDelegate?

	/// Header bar view height.
	internal static var height: CGFloat = 50

	/// Close button.
	internal lazy var button: VGSCustomRoundedButton = {
		let button = VGSCustomRoundedButton(frame: .zero)
		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}()

	// MARK: - Initialization

	/// no:doc
	init() {
		super.init(frame: .zero)
	}

	/// no:doc
	required init?(coder: NSCoder) {
		fatalError("not implemented")
	}

	// MARK: - Override

	/// no:doc
	override var intrinsicContentSize: CGSize {
			return CGSize(width: UIView.noIntrinsicMetric, height: VGSHeaderBarView.height)
	}

	// MARK: - Helpers

	/// Setup UI and layout.
	private func setupUI() {
		let constraints = [
			button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),
			button.centerYAnchor.constraint(equalTo: centerYAnchor)
		]
		NSLayoutConstraint.activate(constraints)

		button.updateStyle(with: .close)

		button.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
	}

	/// Tap action.
	@objc fileprivate func handleTap(_ sender: VGSCustomRoundedButton) {
		delegate?.buttonDidTap(in: self)
	}
}
