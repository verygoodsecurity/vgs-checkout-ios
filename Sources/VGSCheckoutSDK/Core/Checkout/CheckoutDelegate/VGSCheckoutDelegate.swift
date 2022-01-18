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
	/// - Parameter data: `Data?` object, holds response data.
	/// - Parameter response: `URLResponse?` object, holds response object.
	func saveCardDidSuccess(with data: Data?, response: URLResponse?)
}

/// Defeault protocol implementation.
public extension VGSCheckoutDelegate {

	/// no:doc
	func saveCardDidSuccess(with data: Data?, response: URLResponse?) {}
}
