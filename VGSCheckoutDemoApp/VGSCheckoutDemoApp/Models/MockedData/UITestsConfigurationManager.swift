//
//  UITestsConfigurationManager.swift
//  VGSCheckoutDemoApp

import Foundation
import VGSCheckoutSDK

/// Configuration manager for UI tests.
internal class UITestsConfigurationManager {

	/// Updates checkout configuration for UI tests.
	/// - Parameter configuration: `VGSCheckoutCustomConfiguration` object, configuration to update.
	static func updateCustomCheckoutConfigurationForUITests(_ configuration: inout VGSCheckoutCustomConfiguration) {
		// Get all features from the UI tests launch arguments.
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
		// Get all features from the UI tests launch arguments.
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
