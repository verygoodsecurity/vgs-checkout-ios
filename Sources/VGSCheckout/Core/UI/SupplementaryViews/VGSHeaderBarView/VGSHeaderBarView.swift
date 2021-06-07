//
//  VGSHeaderBarView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Custom header bar vier for checkout.
internal class VGSHeaderBarView: UIView {

	/// Defines button UI styles.
	internal enum ButtonStyle {
		case close
		case back
		case customView(_ view: UIView)
		case customImage(_ image: UIImage)
	}

  // MARK: - Vars

	/// Header bar view height.
	internal static var height: CGFloat = 50

	/// Close button.
	internal lazy var button: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}()

	fileprivate let style: ButtonStyle

	// MARK: - Initialization

	/// no:doc
	init(style: VGSHeaderBarView.ButtonStyle) {
		self.style = style
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

	private func setupUI() {
		let constraints = [
			button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),
			button.centerYAnchor.constraint(equalTo: centerYAnchor)
		]
		NSLayoutConstraint.activate(constraints)
	}
}
