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
}
