//
//  VGSCheckoutErrorUtils.swift
//  VGSCheckout

import Foundation

/// Error handling utils.
internal class VGSCheckoutErrorUtils {

	/// Check whether error is no connection.
	/// - Parameter error: `Error?` object, error.
	/// - Returns: `true` if network connection error.
	internal static func isNoConnectionError(_ error: Error?) -> Bool {
		guard let networkError = error as? NSError, networkError.domain == NSURLErrorDomain, networkError.code == NSURLErrorNotConnectedToInternet else {
			return false
		}

		return true
	}
}
