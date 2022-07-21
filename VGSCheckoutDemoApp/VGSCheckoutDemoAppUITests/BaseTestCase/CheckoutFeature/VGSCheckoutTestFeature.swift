//
//  VGSCheckoutTestFeature.swift
//  VGSCheckoutDemoAppUITests

import Foundation

/// Defines features for UI tests to set in launch arguments.
enum VGSCheckoutUITestsFeature {

	/// On sumbit validation.
	case onSumbitValidation

	/// On focus validation.
	case onFocusValidation

	/**
	 List of valid countries in billing address..

	- Parameters:
		 - countries: An array of `String`, country codes in ISO format.
	*/
	case validCountries( _ countries: [String])

	/// Only postal code field in address is visible.
	case onlyPostalCodeFieldInAddress

	/// Saved cards.
	case savedCards

	/// Remove saved card success.
	case successRemoveSavedCard

	/// Remove card option is disabled.
	case removeCardDisabled

	/// Billing address section is hidden.
	case billingAddressIsHidden

	/**
	 List of fields in billing address section.

	 - Parameters:
			- fields: An array of `VGSCheckoutUITestsAddressFields`, address fields.
	*/
	case billingAddressFields( _ fields: [VGSCheckoutUITestsAddressFields])

	/// Launch argument for corresponding feature.
	var launchArgument: String {
		switch self {
		case .onSumbitValidation:
			return "onSumbitValidation"
		case .onFocusValidation:
			return "onFocusValidation"
		case .validCountries(let countries):
			return "validCountries=" + countries.joined(separator: ".")
		case .onlyPostalCodeFieldInAddress:
			return "onlyPostalCodeFieldInAddress"
		case .savedCards:
			return "savedCards"
		case .successRemoveSavedCard:
			return "successRemoveSavedCard"
		case .removeCardDisabled:
			return "removeCardDisabled"
		case .billingAddressIsHidden:
			return "billingAddressIsHidden"
		case .billingAddressFields(let fields):
			return "billingAddressFields=" + fields.map {$0.rawValue}.joined(separator: ".")
		}
	}
}
