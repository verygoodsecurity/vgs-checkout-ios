//
//  VGSCheckoutServiceProtocol.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Defines interface for state change in checkout service.
internal protocol VGSCheckoutServiceDelegateProtocol: AnyObject {

	/// no:doc
	func checkoutServiceStateDidChange(with state: VGSAddCardFlowState, in service: VGSCheckoutServiceProtocol)
}

/// Defines interface for checkout service.
/// Checkout service should:
/// 1. init with configuration, collect, UI theme;
/// 2. create root checkout view controller;
/// 3. provide delegate to notify `VGSCheckout` instance with changes in service state.
internal protocol VGSCheckoutServiceProtocol {

	/// no:doc
	init(checkoutConfigurationType: VGSCheckoutConfigurationType, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol)

	/// Builds checkout view controller.
	/// - Returns: `UIViewController` object, view controller.
	func buildCheckoutViewController() -> UIViewController

	/// An object that acts as a checkout service delegate.
	var serviceDelegate: VGSCheckoutServiceDelegateProtocol? {get set}
}
