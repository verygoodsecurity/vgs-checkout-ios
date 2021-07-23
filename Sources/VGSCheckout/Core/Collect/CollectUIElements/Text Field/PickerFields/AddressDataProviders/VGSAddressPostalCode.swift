//
//  VGSAddressPostalCode.swift
//  VGSCheckout

import Foundation

/// Defines address postal code.
internal enum VGSAddressPostalCode {

  /// Country doesn't have postal code.
	case noPostalCode

	/// ZIP code (US).
	case zip

	/// Postal code (other countries except US).
	case postalCode

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
			return .noPostalCode
		}
	}

	/// Text field placeholder.
	internal var textFieldPlaceholder: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: self.localizedPlaceholderKey)
	}

	/// Text field hint (text above the text field).
	internal var textField: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: self.localizedHintKey)
	}

	/// Localization key for text field placeholder.
	private var localizedPlaceholderKey: String {
		switch self {
		case .zip:
			return "vgs_checkout_address_info_address_zip_hint"
		case .postalCode:
			return "vgs_checkout_address_info_postal_code_hint"
		default:
			return ""
		}
	}

	/// Localization key for postal code placeholder.
	private var localizedHintKey: String {
		switch self {
		case .zip:
			return "vgs_checkout_address_info_address_zip_subtitle"
		case .postalCode:
			return "vgs_checkout_address_info_postal_code_subtitle"
		default:
			return ""
		}
	}

	/// Localization key for postal code empty error.
	private var localizedEmptyErrorKey: String {
		switch self {
		case .zip:
			return "vgs_checkout_address_info_zipcode_empty_error"
		case .postalCode:
			return "vgs_checkout_address_info_postal_code_empty_error"
		default:
			return ""
		}
	}

	/// Localization key for postal code invalid error.
	private var localizedInvalidErrorKey: String {
		switch self {
		case .zip:
			return "vgs_checkout_address_info_zipcode_invalid_error"
		case .postalCode:
			return "vgs_checkout_address_info_postal_code_invalid_error"
		default:
			return ""
		}
	}
}
