//
//  VGSCheckoutDelegate.swift
//  VGSCheckout

import Foundation

/// A set of methods to notify about changes in checkout state.
public protocol VGSCheckoutDelegate: AnyObject {
	/// Tells the delegate that checkout flow did finish with result.
	/// - Parameter requestResult: `VGSCheckoutRequestResult` object, holds result of checkout flow.
	func checkoutDidFinish(with requestResult: VGSCheckoutRequestResult)

	/// Tells the delegate that user cancelled checkout flow (closed checkout screen.)
	func checkoutDidCancel()
}
