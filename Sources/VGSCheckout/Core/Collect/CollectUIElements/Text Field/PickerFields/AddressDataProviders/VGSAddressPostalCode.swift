//
//  VGSAddressPostalCode.swift
//  VGSCheckout

import Foundation

/// Defines address postal code.
internal enum VGSAddressPostalCode {

  /// Country doesn't have postal code.
	case noPostalCode

	/// ZIP code (US)
	case zip

	/// Postal code (other countries except US)
	case postalCode
}
