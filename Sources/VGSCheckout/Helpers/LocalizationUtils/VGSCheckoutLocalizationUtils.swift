//
//  VGSCheckoutLocalizationUtils.swift
//  VGSCheckout

import Foundation

/// Localization utils.
internal final class VGSCheckoutLocalizationUtils {

	/// Uknown localized string key.
	internal static let NotFoundStringId = "VGSLocalizedStringNotFound"

	/// A boolean flag indicating whether SKD should use user resources.
	internal static let isMainBundleLocalization: Bool = {
		if BundleUtils.shared.resourcesBundle?.preferredLocalizations.first != Bundle.main.preferredLocalizations.first {
			return false
		} else {
			return true
		}
	}()

	/// Returns localized string for key. If VGS SDK doesn't have preferred localization try to use user localizable strings.
	/// - Parameter key: `String` object, key to localize.
	/// - Returns: `String` object, localized string.
	internal static func vgsLocalizedString(forKey key: String) -> String {

		let vgsLocalizedString = BundleUtils.shared.resourcesBundle?.localizedString(forKey: key, value: NotFoundStringId, table: nil) ?? NotFoundStringId
		switch VGSCheckoutLocalizationSettings.localizationPolicy {
		case .vgsCheckout:
			if isMainBundleLocalization {
				let appMainLocalizedString = Bundle.main.localizedString(
					forKey: key, value: NotFoundStringId, table: nil)

				/// Since for not found localizable string iOS returns empty `value` should use some key to identify not found string.
				if appMainLocalizedString != NotFoundStringId {
					return appMainLocalizedString
				}
			}

			return BundleUtils.shared.resourcesBundle?.localizedString(
				forKey: key, value: nil, table: nil) ?? ""
		case .mainApp:
			let stringInMainBundle = Bundle.main.localizedString(
				forKey: key, value: NotFoundStringId, table: nil)
			if stringInMainBundle == NotFoundStringId {
				return vgsLocalizedString
			} else {
				return stringInMainBundle
			}
		}
	}
}
