//
//  UIView+Extensions.swift
//  VGSCheckoutSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// no:doc
internal extension UIView {

	/// Constraints view to super view.
	func checkout_constraintViewToSuperviewEdges() {
		guard let view = superview else {
			assertionFailure("No superview!")
			return
		}

		let constraints = [
			leadingAnchor.constraint(equalTo: view.leadingAnchor),
			trailingAnchor.constraint(equalTo: view.trailingAnchor),
			bottomAnchor.constraint(equalTo: view.bottomAnchor),
			topAnchor.constraint(equalTo: view.topAnchor)
		]

		NSLayoutConstraint.activate(constraints)
	}

	/// Constraints view to super view safe area layout guide.
	func checkout_constraintViewToSafeAreaLayoutGuideEdges() {
		guard let view = superview else {
			assertionFailure("No superview!")
			return
		}

		let constraints = [
			leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
		]

		NSLayoutConstraint.activate(constraints)
	}

	/// Hack to fix issue with hidden state in stack view https://stackoverflow.com/a/55161538
	var isHiddenInCheckoutStackView: Bool {
		get {
			return isHidden
		}
		set {
			if isHidden != newValue {
				isHidden = newValue
			}
		}
	}

	/// Constrain view to superview with insets
	/// - Parameters:
	///   - leading: `CGFloat` object, leading inset.
	///   - trailing: `CGFloat` object, trailing inset.
	///   - bottom: `CGFloat` object, bottom inset.
	///   - top: `CGFloat` object, top inset.
	func checkout_constraintViewWithPaddingsToSuperview(_ leading: CGFloat, trailing: CGFloat, bottom: CGFloat, top: CGFloat) {
		guard let view = superview else {
			assertionFailure("No superview!")
			return
		}

		let constraints = [
			leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading),
			trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing),
			bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom),
			topAnchor.constraint(equalTo: view.topAnchor, constant: top)
		]

		NSLayoutConstraint.activate(constraints)
	}

	/// Setups default section insets.
	func checkout_defaultSectionViewConstraints() {
		checkout_constraintViewWithPaddingsToSuperview(16, trailing: -16, bottom: 0, top: 16)
	}
}
