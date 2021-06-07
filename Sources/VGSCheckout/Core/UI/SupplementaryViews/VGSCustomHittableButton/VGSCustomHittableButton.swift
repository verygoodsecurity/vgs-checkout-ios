//
//  VGSCustomRoundedButton.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Custom button.
internal class VGSCustomRoundedButton: UIControl {

	/// Button radius.
	private var radius: CGFloat = 12

	/// Min tappable area.
	private var minTapAreaSize: CGSize = CGSize(width: 44, height: 44)

	/// Image view.
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false

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
