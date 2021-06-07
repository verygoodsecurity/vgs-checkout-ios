//
//  VGSCustomRoundedButton.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Custom button.
internal class VGSCustomRoundedButton: UIControl {

	/// Defines button UI styles.
	internal enum ButtonStyle {

		/**
		Close button.
		*/
		case close

		/**
		Back button.
		*/
		case back

		/**
		Custom view.

		Parameters:
		- view: `UIView` object, custom view to add.
		*/
		case customView(_ view: UIView)

		/**
		Custom image.

		Parameters:
		- image: `UIImage` object, custom image to set.
		*/
		case customImage(_ image: UIImage)
	}

	/// Button radius.
	internal var radius: CGFloat = 12

	/// Min tappable area.
	internal var minTapAreaSize: CGSize = CGSize(width: 44, height: 44)

	/// Image view.
	internal lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit

		return imageView
	}()

	/// MARK: - Initialization

	/// no:doc
	override init(frame: CGRect) {
		super.init(frame: frame)

		setupUI()
	}

	/// no:doc
	required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
	}

	/// no:doc
	override var intrinsicContentSize: CGSize {
			return CGSize(width: radius * 2, height: radius * 2)
	}

	/// no:doc
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		let area = bounds.insetBy(dx: -minTapAreaSize.width / 2, dy: -minTapAreaSize.height / 2)
		return area.contains(point)
	}

	// MARK: - Interface

	/// Update button with style.
	/// - Parameter style: `ButtonStyle` object, button style.
	internal func updateStyle(with style: ButtonStyle) {
		switch style {
		case .close:
			imageView.image = UIImage(named: "navigation_view_close_button", in: BundleUtils.shared.resourcesBundle, compatibleWith: nil)
		case .back:
			break
		case .customImage(let image):
			imageView.image = image
		case .customView(let view):
			imageView.isHidden = true
			addSubview(view)
			view.translatesAutoresizingMaskIntoConstraints = false
			view.checkout_constraintViewToSuperviewEdges()
		}
	}

	// MARK: - Helpers

	/// Setup UI and layout.
	private func setupUI() {
		addSubview(imageView)
		imageView.checkout_constraintViewToSuperviewEdges()

		layer.shadowOffset = CGSize(width: 0, height: 1)
		layer.shadowRadius = 1.5
		if #available(iOS 13.0, *) {
			layer.shadowColor = UIColor.systemGray2.cgColor
		} else {
			layer.shadowColor = UIColor.gray.cgColor
		}
		layer.shadowOpacity = 0.1
		let path = UIBezierPath(
				arcCenter: CGPoint(x: radius, y: radius), radius: radius,
				startAngle: 0,
				endAngle: CGFloat.pi * 2,
				clockwise: true)
		layer.shadowPath = path.cgPath
	}
}
