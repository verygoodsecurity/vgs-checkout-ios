//
//  VGSContainerItemView.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Container view is a helper view to hold content views in form and add paddings.
internal class VGSContainerItemView: UIView {

	// MARK: - Vars

	/// Padding constraints.
	private var paddingConstraints: [NSLayoutConstraint] = []

	/// Content view paddings.
	internal var paddings: UIEdgeInsets = .zero {
		didSet {
			layoutPaddings()
		}
	}

	/// Content view.
	internal var contentView: UIView?

	// MARK: - Interface

	/// Add content view.
	/// - Parameter view: `UIView` object, content view to add.
	internal func addContentView(_ view: UIView) {
		view.translatesAutoresizingMaskIntoConstraints = false
		contentView?.removeFromSuperview()
		contentView = view
		addSubview(view)
		layoutPaddings()
	}

	// MARK: - Helpers

	/// Layout paddings.
	private func layoutPaddings() {
		guard let contentView = contentView else {return}
		contentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		paddingConstraints.forEach { constraint in
			constraint.isActive = false
		}
		paddingConstraints = [
			contentView.topAnchor.constraint(equalTo: topAnchor, constant: paddings.top),
			contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddings.left),
			contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -paddings.right),
			contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddings.bottom)
		]

		NSLayoutConstraint.activate(paddingConstraints)
	}
}
