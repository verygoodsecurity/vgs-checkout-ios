//
//  UITestsConfigurationManager.swift
//  VGSCheckoutDemoApp

import Foundation
import VGSCheckoutSDK

/// Defines features for UI tests to set in launch arguments.
public enum VGSCheckoutUITestsFeature: String {

	/// On sumbit validation.
	case onSumbitValidation

	/// On edit validation.
	case onEditValidation
}

/// Configuration manager for UI tests.
internal class UITestsConfigurationManager {

	/// Updates checkout configuration for UI tests.
	/// - Parameter configuration: `VGSCheckoutCustomConfiguration` object, configuration to update.
	static func updateCustomCheckoutConfigurationForUITests(_ configuration: inout VGSCheckoutCustomConfiguration) {
		// Get all features from the UI tests launch argument.
		let uiTestsFeatures = ProcessInfo().arguments.compactMap({return VGSCheckoutUITestsFeature(rawValue: $0)})
		guard UIApplication.isRunningUITest, !uiTestsFeatures.isEmpty else {return}

		uiTestsFeatures.forEach { testFeautre in
			switch testFeautre {
			case .onEditValidation:
				configuration.formValidationBehaviour = .onEdit
			case .onSumbitValidation:
				configuration.formValidationBehaviour = .onSubmit
			}
		}
	}
}
