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

	/// Constraints view to super view center.
	func checkout_constraintViewToSuperviewCenter() {
		guard let view = superview else {
			assertionFailure("No superview!")
			return
		}

		let constraints = [
			centerXAnchor.constraint(equalTo: view.centerXAnchor),
			centerYAnchor.constraint(equalTo: view.centerYAnchor),
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

internal extension UIView {

		static let loadingViewTag = 1938123987
		static let overlayViewTag = 1938123988

	private var overlayView: UIView {
		let view: UIView = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .vgsSystemBackground
		view.alpha = 0.5
		view.tag = UIView.overlayViewTag
		return view
	}

	private var activityIndicatorView: UIActivityIndicatorView {
		let view: UIActivityIndicatorView
		if #available(iOS 13.0, *) {
			view = UIActivityIndicatorView(style: .large)
		} else {
			view = UIActivityIndicatorView(style: .whiteLarge)
		}
		view.translatesAutoresizingMaskIntoConstraints = false
		view.tag = UIView.loadingViewTag
		return view
	}

	private func setActivityIndicatorView() {
				 guard !isDisplayingActivityIndicatorOverlay() else { return }
				 let overlayView: UIView = self.overlayView
				 let activityIndicatorView: UIActivityIndicatorView = self.activityIndicatorView

				 //add subviews
				 overlayView.addSubview(activityIndicatorView)
				 addSubview(overlayView)

				 //add overlay constraints
				 overlayView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
				 overlayView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

				 //add indicator constraints
				 activityIndicatorView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true
				 activityIndicatorView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor).isActive = true

				 //animate indicator
				 activityIndicatorView.startAnimating()
		 }

		 private func removeActivityIndicatorView() {
				 guard let overlayView: UIView = getOverlayView(), let activityIndicator: UIActivityIndicatorView = getActivityIndicatorView() else {
						 return
				 }
				 UIView.animate(withDuration: 0.2, animations: {
						 overlayView.alpha = 0.0
						 activityIndicator.stopAnimating()
				 }) { _ in
						 activityIndicator.removeFromSuperview()
						 overlayView.removeFromSuperview()
				 }
		 }

		 private func isDisplayingActivityIndicatorOverlay() -> Bool {
				 getActivityIndicatorView() != nil && getOverlayView() != nil
		 }

		 private func getActivityIndicatorView() -> UIActivityIndicatorView? {
			 viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
		 }

		 private func getOverlayView() -> UIView? {
			 viewWithTag(UIView.overlayViewTag)
		 }
}

// no:doc
internal extension UIView {
		func displayAnimatedActivityIndicatorView() {
				setActivityIndicatorView()
		}

		func hideAnimatedActivityIndicatorView() {
				removeActivityIndicatorView()
		}
}

internal extension UIViewController {
		private var overlayContainerView: UIView {
				if let navigationView: UIView = navigationController?.view {
						return navigationView
				}
				return view
		}

		func displayLoader() {
				overlayContainerView.displayAnimatedActivityIndicatorView()
		}

		func hideLoader() {
				overlayContainerView.hideAnimatedActivityIndicatorView()
		}
}
