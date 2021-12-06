//
//  VGSBillingAddressUtils.swift
//  VGSCheckoutSDK

import Foundation

/// Billing address utils.
internal class VGSBillingAddressUtils {

	/// Postal code for specified country.
	/// - Parameter countryISO: `VGSCountriesISO` object, country ISO code.
	/// - Returns: `VGSAddressPostalCode` object, corresponding postal code type for country.
	internal static func postalCode(for countryISO: VGSCountriesISO) -> VGSAddressPostalCode {
		switch countryISO {
		case .us:
			return .zip
		case .ca, .gb, .au, .nz:
			return .postalCode
		default:
			return .postalCode
		}
	}

	/// Checks if address verification service is available for specified country.
	/// - Parameter countryISO: `VGSCountriesISO` object, country ISO code.
	/// - Returns: `Bool` object, `true` if address verification service is available.
	internal static func isAddressVerificationAvailable(for countryISO: VGSCountriesISO) -> Bool {
		switch countryISO {
		case .us, .ca, .au, .nz, .gb:
			return true
		default:
			return false
		}
	}
}
