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
			case .billingAddressFields(let fields):
				// Hide all address fields initially.
				hideAllAddressFields(in: &configuration)

				fields.forEach { field in
					switch field {
					case .country:
						configuration.billingAddressCountryFieldOptions.visibility = .visible
					case .addressLine1:
						configuration.billingAddressLine1FieldOptions.visibility = .visible
					case .addressLine2:
						configuration.billingAddressLine2FieldOptions.visibility = .visible
					case .city:
						configuration.billingAddressCityFieldOptions.visibility = .visible
					case .postalCode:
						configuration.billingAddressPostalCodeFieldOptions.visibility = .visible
					}
				}
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
			case .billingAddressFields(let fields):
				// Hide all address fields initially.
				hideAllAddressFields(in: &configuration)

				fields.forEach { field in
					switch field {
					case .country:
						configuration.billingAddressCountryFieldOptions.visibility = .visible
					case .addressLine1:
						configuration.billingAddressLine1FieldOptions.visibility = .visible
					case .addressLine2:
						configuration.billingAddressLine2FieldOptions.visibility = .visible
					case .city:
						configuration.billingAddressCityFieldOptions.visibility = .visible
					case .postalCode:
						configuration.billingAddressPostalCodeFieldOptions.visibility = .visible
					}
				}
			default:
				break
			}
		}
	}

	/// Hides all address fields in custom config.
	/// - Parameter customConfig: `VGSCheckoutCustomConfiguration` object, custom configuration.
	private static func hideAllAddressFields(in customConfig: inout VGSCheckoutCustomConfiguration) {
		customConfig.billingAddressCountryFieldOptions.visibility = .hidden
		customConfig.billingAddressLine1FieldOptions.visibility = .hidden
		customConfig.billingAddressLine2FieldOptions.visibility = .hidden
		customConfig.billingAddressCityFieldOptions.visibility = .hidden
		customConfig.billingAddressPostalCodeFieldOptions.visibility = .hidden
	}

	/// Hides all address fields in add card config.
	/// - Parameter addCardConfig: `VGSCheckoutAddCardConfiguration` object, add card configuration.
	private static func hideAllAddressFields(in addCardConfig: inout VGSCheckoutAddCardConfiguration) {
		addCardConfig.billingAddressCountryFieldOptions.visibility = .hidden
		addCardConfig.billingAddressLine1FieldOptions.visibility = .hidden
		addCardConfig.billingAddressLine2FieldOptions.visibility = .hidden
		addCardConfig.billingAddressCityFieldOptions.visibility = .hidden
		addCardConfig.billingAddressPostalCodeFieldOptions.visibility = .hidden
	}
}
