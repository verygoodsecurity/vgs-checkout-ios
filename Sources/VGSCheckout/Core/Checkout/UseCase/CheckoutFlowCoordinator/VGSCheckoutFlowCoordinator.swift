//
//  VGSCheckoutFlowCoordinator.swift
//  VGSCheckout

import Foundation
#if os(iOS)
import UIKit
#endif

/// Encapsulates navigation logic between different user flows.
internal class VGSCheckoutFlowCoordinator {

	/// Root view controller.
	internal var rootController: UIViewController?

	/// Set new flow view controller as root.
	/// - Parameter viewController: `UIViewController` object, controller to set.
	internal func setRootViewController(_ viewController: UIViewController) {
		rootController = viewController
	}

	/// Dismiss current root controller.
	internal func dismissRootViewController(with completion: @escaping () -> Void
	) {
		rootController?.dismiss(animated: true, completion: completion)
	}
}
