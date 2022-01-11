//
//  VGSCheckoutSDKFlowCoordinator.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Encapsulates navigation logic between different user flows.
internal class VGSCheckoutFlowCoordinator {

	// MARK: - Vars

	/// Payment instrument.
	private let checkoutConfigurationType: VGSCheckoutConfigurationType?

	/// Checkout service provider.
	internal let checkoutServiceProvider: VGSCheckoutServiceProviderProtocol

	// MARK: - Initializaer

	init(checkoutConfigurationType: VGSCheckoutConfigurationType, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol) {
		self.checkoutConfigurationType = checkoutConfigurationType
		self.checkoutServiceProvider = VGSCheckoutServiceProviderFactory.buildCheckoutServiceProvider(with: checkoutConfigurationType, vgsCollect: vgsCollect, uiTheme: uiTheme)
	}

	// MARK: - Interface

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
