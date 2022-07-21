//
//  UITestsConfigurationManager.swift
//  VGSCheckoutDemoApp

import Foundation
import VGSCheckoutSDK

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
		} else if launchArgument.hasPrefix("validCountries=") {
			let countriesStringList = launchArgument.components(separatedBy: "=")[1]
			let countriesList = countriesStringList.components(separatedBy: ".")
			self = .validCountries(countriesList)
			return
		}

		return nil
	}
}

/// Configuration manager for UI tests.
internal class UITestsConfigurationManager {

	/// Updates checkout configuration for UI tests.
	/// - Parameter configuration: `VGSCheckoutCustomConfiguration` object, configuration to update.
	static func updateCustomCheckoutConfigurationForUITests(_ configuration: inout VGSCheckoutCustomConfiguration) {
		// Get all features from the UI tests launch argument.
		let uiTestsFeatures = ProcessInfo().arguments.compactMap({return VGSCheckoutUITestsFeature(launchArgument: $0)})
		guard UIApplication.isRunningUITest, !uiTestsFeatures.isEmpty else {return}

		uiTestsFeatures.forEach { testFeautre in
			switch testFeautre {
			case .onFocusValidation:
				configuration.formValidationBehaviour = .onFocus
			case .onSumbitValidation:
				configuration.formValidationBehaviour = .onSubmit
			case .validCountries(let countries):
				configuration.billingAddressCountryFieldOptions.validCountries = countries
			case .onlyPostalCodeFieldInAddress:
				configuration.billingAddressCountryFieldOptions.visibility = .hidden
				configuration.billingAddressLine1FieldOptions.visibility = .hidden
				configuration.billingAddressLine2FieldOptions.visibility = .hidden
				configuration.billingAddressCityFieldOptions.visibility = .hidden
				configuration.billingAddressCityFieldOptions.visibility = .hidden
			case .billingAddressIsHidden:
				configuration.billingAddressVisibility = .hidden
			default:
				break
			}
		}
	}

	/// Updates checkout configuration for UI tests.
	/// - Parameter configuration: `VGSCheckoutAddCardConfiguration` object, configuration to update.
	static func updateAddCardCheckoutConfigurationForUITests(_ configuration: inout VGSCheckoutAddCardConfiguration) {
		// Get all features from the UI tests launch argument.
		let uiTestsFeatures = ProcessInfo().arguments.compactMap({return VGSCheckoutUITestsFeature(launchArgument: $0)})
		guard UIApplication.isRunningUITest, !uiTestsFeatures.isEmpty else {return}

		uiTestsFeatures.forEach { testFeautre in
			switch testFeautre {
			case .onFocusValidation:
				configuration.formValidationBehaviour = .onFocus
			case .onSumbitValidation:
				configuration.formValidationBehaviour = .onSubmit
			case .validCountries(let countries):
				configuration.billingAddressCountryFieldOptions.validCountries = countries
			case .onlyPostalCodeFieldInAddress:
				configuration.billingAddressCountryFieldOptions.visibility = .hidden
				configuration.billingAddressLine1FieldOptions.visibility = .hidden
				configuration.billingAddressLine2FieldOptions.visibility = .hidden
				configuration.billingAddressCityFieldOptions.visibility = .hidden
				configuration.billingAddressCityFieldOptions.visibility = .hidden
			case .removeCardDisabled:
				configuration.isRemoveCardOptionEnabled = false
			case .billingAddressIsHidden:
				configuration.billingAddressVisibility = .hidden
			default:
				break
			}
		}
	}
}
