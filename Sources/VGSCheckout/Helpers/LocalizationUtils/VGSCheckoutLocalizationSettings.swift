//
//  VGSCheckoutLocalizationSettings.swift
//  VGSCheckout

import Foundation

/// Holds localization settings.
internal final class VGSCheckoutLocalizationSettings {

	/// Defines what bundle to use for localization.
	internal enum LocalizationBundlePolicy {

		/// Use VGS resources with a fallback to main app bundle if app language is not supported by VGS.
		case vgsCheckout

		/// Use main app bundle with a fallback to VGS translations. Can be used to to override EN translations.
		case mainApp
	}

	/// Defines localization policy, default is `.mainApp`.
	internal static var localizationPolicy: LocalizationBundlePolicy = .mainApp
}
