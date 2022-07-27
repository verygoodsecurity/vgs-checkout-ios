//
//  VGSCheckoutUITestsFeature.swift
//  VGSCheckoutDemoApp
//

import Foundation

/// Defines features for UI tests to set in launch arguments.
enum VGSCheckoutUITestsFeature {

	/// On sumbit validation.
	case onSumbitValidation

	/// On focus validation.
	case onFocusValidation

	/// List of valid countries in billing address.
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
			- fields: An array of `VGSCheckoutUITestsAddressField`, address fields.
	*/
	case billingAddressFields( _ fields: [VGSCheckoutUITestsAddressField])

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

	/// Initialier with launch argument.
	init?(launchArgument: String) {
		if launchArgument == VGSCheckoutUITestsFeature.onSumbitValidation.launchArgument {
			self = .onSumbitValidation
			return
		} else if launchArgument == VGSCheckoutUITestsFeature.onFocusValidation.launchArgument {
			self = .onFocusValidation
			return
		} else if launchArgument == VGSCheckoutUITestsFeature.onlyPostalCodeFieldInAddress.launchArgument {
			self = .onlyPostalCodeFieldInAddress
			return
		} else if launchArgument == VGSCheckoutUITestsFeature.savedCards.launchArgument {
				self = .savedCards
				return
		} else if launchArgument == VGSCheckoutUITestsFeature.successRemoveSavedCard.launchArgument {
			self = .successRemoveSavedCard
			return
		} else if launchArgument == VGSCheckoutUITestsFeature.removeCardDisabled.launchArgument {
			self = .removeCardDisabled
			return
		} else if launchArgument == VGSCheckoutUITestsFeature.billingAddressIsHidden.launchArgument {
			self = .billingAddressIsHidden
			return
		} else if launchArgument.hasPrefix("billingAddressFields=") {
			let countriesStringList = launchArgument.components(separatedBy: "=")[1]
			let addressFields = countriesStringList.components(separatedBy: ".").compactMap { field in
				return VGSCheckoutUITestsAddressField(rawValue: field)
			}
			self = .billingAddressFields(addressFields)
			return
		} else if launchArgument.hasPrefix("validCountries=") {
			let countriesStringList = launchArgument.components(separatedBy: "=")[1]
			let countriesList = countriesStringList.components(separatedBy: ".")
			self = .validCountries(countriesList)
			return
		}

		return nil
	}
}
