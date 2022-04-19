//
//  VGSCheckoutSDKDelegate.swift
//  VGSCheckoutSDK

import Foundation

/// A set of methods to notify about changes in checkout state.
public protocol VGSCheckoutDelegate: AnyObject {
	/// Tells the delegate that checkout flow did finish with result.
	/// - Parameter requestResult: `VGSCheckoutRequestResult` object, holds result of checkout flow.
	func checkoutDidFinish(with requestResult: VGSCheckoutRequestResult)

	/// Tells the delegate that user cancelled checkout flow (closed checkout screen).
	func checkoutDidCancel()

	/// Tells the delegate that user removed saved card from payment options methods.
	/// - Parameter id: `String` object, removed saved card financial instrument id.
	/// - Parameter result: `VGSCheckoutRequestResult` object, remove card request result.
	func removeCardDidFinish(with id: String, result: VGSCheckoutRequestResult)

	/// Tells the delegate that checkout flow did finish with payment method.
	/// - Parameter paymentMethod: `VGSCheckoutPaymentMethod` object, holds payment method info.
	func checkoutDidFinish(with paymentMethod: VGSCheckoutPaymentMethod)
}

/// no:doc
public extension VGSCheckoutDelegate {

	/// no:doc
	func checkoutDidFinish(with requestResult: VGSCheckoutRequestResult) {}

	/// no:dc
	func checkoutDidCancel() {}

	/// no:doc
	func removeCardDidFinish(with id: String, result: VGSCheckoutRequestResult) {}

	/// no:doc
	func checkoutDidFinish(with paymentMethod: VGSCheckoutPaymentMethod) {}
}
