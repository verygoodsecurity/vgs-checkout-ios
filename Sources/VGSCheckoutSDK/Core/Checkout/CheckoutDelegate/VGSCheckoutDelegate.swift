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

	/// Tells the delegate that save card succeeded and fin instrument created.
	/// - Parameter data: `Data?` object, holds response data with created financial instrument for saved card.
	/// - Parameter response: `URLResponse?` object, holds URL response object with created financial instrument for saved card.
	func saveCardDidSuccess(with data: Data?, response: URLResponse?)

	/// Tells the delegate that user removed saved card from payment options methods.
	/// - Parameter id: `String` object, removed saved card financial instrument id.
	func savedCardDidRemove(_ id: String)
}

/// Defeault protocol implementation.
public extension VGSCheckoutDelegate {

	/// no:doc
	func saveCardDidSuccess(with data: Data?, response: URLResponse?) {}

	/// no:doc
	func savedCardDidRemove(_ id: String) {}
}
