//
//  UIView+Extensions.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal extension UIView {
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
    
    func checkout_defaultSectionViewConstraints() {
        checkout_constraintViewWithPaddingsToSuperview(16, trailing: -16, bottom: -16, top: 16)
    }
}
