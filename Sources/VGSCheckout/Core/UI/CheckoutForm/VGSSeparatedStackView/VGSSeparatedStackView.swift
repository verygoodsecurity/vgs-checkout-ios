//
//  VGSSeparatedStackView.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// StackView with separator - inspired from https://github.com/barisatamer/StackViewSeparator
internal class VGSSeparatedStackView: UIStackView {

	/// Border view.
	private lazy var borderView: UIView = {
		let view = UIView()
		view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.layer.shadowOffset = CGSize(width: 0, height: 2)
		view.layer.shadowColor = UIColor.gray.cgColor
		view.layer.shadowOpacity = 0.05
		view.layer.shadowRadius = 4

		return view
	}()

	/// Border corner raidus.
	internal var borderViewCornerRadius: CGFloat {
		get {
				return borderView.layer.cornerRadius
		}
		set {
			borderView.layer.cornerRadius = newValue
		}
	}

	/// Separator stroke color.
	internal var separatorColor: UIColor = UIColor.gray {
		didSet {
			separatorsShapeLayer.strokeColor = separatorColor.cgColor
		}
	}

	/// CALayer for separators.
	private let separatorsShapeLayer = CAShapeLayer()

	/// A boolean flag indicating whether view has border.
	internal var hasBorderView: Bool = false {
		didSet {
			if !hasBorderView {
				borderView.removeFromSuperview()
			} else {
				addSubview(borderView)
				sendSubviewToBack(borderView)
			}
			isLayoutMarginsRelativeArrangement = hasBorderView
		}
	}

	/// Array of visible arranged subviews.
	internal var visibleArrangeSubviews: [UIView] {
		get {
			return arrangedSubviews.filter({!$0.isHidden})
		}
	}

	/// A boolean flag indicating whether RTL is active.
	internal var isRTL: Bool {
		return traitCollection.layoutDirection == .rightToLeft
	}

	/// Stack view spacing.
	override var spacing: CGFloat {
		didSet {
			borderView.layer.borderWidth = spacing
			layoutMargins = UIEdgeInsets(
				top: spacing, left: spacing, bottom: spacing, right: spacing)
		}
	}

	// MARK: - Override

	override func layoutSubviews() {
		updateBorderView()
		super.layoutSubviews()

		addSeparatorsLayerIfNeeded()
		relayoutSeparators()
		borderView.layer.shadowPath =
				UIBezierPath(roundedRect: bounds, cornerRadius: borderViewCornerRadius).cgPath
	}

	// MARK: - Helpers

	/// Update border view position.
	internal func updateBorderView() {
		if borderView.superview != nil {
			sendSubviewToBack(borderView)
		}
	}

	/// Add separators if needed.
	internal func addSeparatorsLayerIfNeeded() {
		if separatorsShapeLayer.superlayer == nil {
			layer.addSublayer(separatorsShapeLayer)
		}
	}

	/// Relayout separators.
	internal func relayoutSeparators() {
		let path = UIBezierPath()
		path.lineWidth = spacing

		if spacing > 0 {
			for view in visibleArrangeSubviews {
				let minX = view.frame.minX
				let maxX = view.frame.maxX
				let maxY = view.frame.maxY
				let minY = view.frame.minY
				let separatorSpacing = 0.5 * spacing

				switch axis {
				case .vertical:
					if view == visibleArrangeSubviews.last {
						continue
					}

					path.move(to: CGPoint(x: minX, y: maxY + separatorSpacing))
					path.addLine(
						to: CGPoint(x: maxX, y: maxY + separatorSpacing))
				case .horizontal:
					if (!isRTL && view == visibleArrangeSubviews.first)
							|| (isRTL && view == visibleArrangeSubviews.last)
					{
						continue
					}

					path.move(to: CGPoint(x: minX - separatorSpacing, y: minY))
					path.addLine(
						to: CGPoint(x: minX - separatorSpacing, y: maxY))
				}
			}

			separatorsShapeLayer.path = path.cgPath
		}
	}
}
