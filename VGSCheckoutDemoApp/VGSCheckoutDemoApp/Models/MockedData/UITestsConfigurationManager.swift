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

	/// Launch argument for corresponding feature.
	var launchArgument: String {
		switch self {
		case .onSumbitValidation:
			return "onSumbitValidation"
		case .onFocusValidation:
			return "onFocusValidation"
		case .validCountries(let countries):
			return "validCountries=" + countries.joined(separator: ".")
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
			}
		}
	}
}