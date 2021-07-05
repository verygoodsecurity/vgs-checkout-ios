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

	/// Defines close button style.
	internal enum CloseButtonStyle {
		case text
		case customRounded
		case image(_ image: UIImage)
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

	/// Close button style.
	internal var closeButtonStyle: CloseButtonStyle

	/// Close button.
	internal var closeButton: UIControl?
	// MARK: - Initialization

	/// no:doc
	init(closeButtonStyle: CloseButtonStyle = .text) {
		self.closeButtonStyle = closeButtonStyle
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
		let button: UIControl
		switch closeButtonStyle {
		case .customRounded:
			let roundedButton = VGSCustomRoundedButton(frame: .zero)
			roundedButton.updateStyle(with: .close)
			roundedButton.radius = VGSHeaderBarView.defaultLayout.buttonRadius
			button = roundedButton
		case .text:
			let textButton = UIButton(frame: .zero)
			textButton.setTitle("Cancel", for: .normal)
			textButton.setTitleColor(UIColor.systemBlue, for: .normal)
			textButton.setTitleColor(UIColor.gray, for: .disabled)
			textButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
			textButton.titleLabel?.adjustsFontForContentSizeCategory = true

			button = textButton
		case .image(let image):
			let imageButton = UIButton(frame: .zero)
			imageButton.setImage(image, for: .normal)

			button = imageButton
		}

		button.translatesAutoresizingMaskIntoConstraints = false
		addSubview(button)

		switch layoutStyle {
		case .fixed(let style):
			let constraints = [
				button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: style.leftPaddig),
				button.centerYAnchor.constraint(equalTo: centerYAnchor),

			]
			NSLayoutConstraint.activate(constraints)
		}

		button.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)

		closeButton = button
	}

	/// Tap action.
	@objc fileprivate func handleTap(_ sender: VGSCustomRoundedButton) {
		delegate?.buttonDidTap(in: self)
	}
}
