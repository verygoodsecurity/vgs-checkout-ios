//
//  VGSHeaderBarView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Header view delate.
internal protocol VGSHeaderBarViewDelegate: AnyObject {
	func buttonDidTap(in header: VGSHeaderBarView)
}

/// Custom header bar vier for checkout.
internal class VGSHeaderBarView: UIView {

	/// Holds layout style.
	internal struct FixedBarLayout {

		/// Header view height.
		let barHeight: CGFloat

		/// Button left padding.
		let leftPaddig: CGFloat

		/// Button radius.
		let buttonRadius: CGFloat
	}

	/// Defines header view style.
	internal enum LayoutStyle {
		case fixed(_ layout: FixedBarLayout)
	}

	/// Layout style.
	internal var layoutStyle: LayoutStyle = .fixed(defaultLayout)

	/// Default layout for fixed style.
	static var defaultLayout = FixedBarLayout(barHeight: 50, leftPaddig: 8, buttonRadius: 12)

  // MARK: - Vars

	/// An object that acts as a delegate of `VGSHeaderBarView`.
	internal weak var delegate: VGSHeaderBarViewDelegate?

	/// Header bar view height.
	internal static var maxHeight: CGFloat = 60

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
		setupUI()
	}

	/// no:doc
	required init?(coder: NSCoder) {
		fatalError("not implemented")
	}

	// MARK: - Override

	/// no:doc
	override var intrinsicContentSize: CGSize {
		let height: CGFloat
		switch layoutStyle {
		case .fixed(let layoutStyle):
			height = layoutStyle.barHeight
		}
		return CGSize(width: UIView.noIntrinsicMetric, height: height)
	}

	// MARK: - Helpers

	/// Setup UI and layout.
	private func setupUI() {
		addSubview(button)
		switch layoutStyle {
		case .fixed(let style):
			let constraints = [
				button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: style.leftPaddig),
				button.centerYAnchor.constraint(equalTo: centerYAnchor),

			]
			NSLayoutConstraint.activate(constraints)
			button.updateStyle(with: .close)
			button.radius = style.buttonRadius
		}

		button.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
	}

	/// Tap action.
	@objc fileprivate func handleTap(_ sender: VGSCustomRoundedButton) {
		delegate?.buttonDidTap(in: self)
	}
}
