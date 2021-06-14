//
//  VGSCheckoutDelegate.swift
//  VGSCheckout

import Foundation

/// A set of methods to notify about changes in checkout state.
public protocol VGSCheckoutDelegate: AnyObject {
	func checkoutDidFinish(with requestResult: VGSCheckoutRequestResult)

	func checkoutDidCancel()
}
