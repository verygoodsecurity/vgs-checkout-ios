//
//  VGSAddressCountriesDataProvider.swift
//  VGSCheckout

import Foundation

/// Countries provider for country address field.
internal class VGSAddressCountriesDataProvider {

	/// Holds model for country object.
	struct CountryModel {
		/// Country ISO code.
		let code: String

		/// Country display name.
		let name: String
	}

	/// Provide all countries.
	/// - Returns: `[CountryModel]`, array of `CountryModel`.
	static func provideCountries() -> [CountryModel] {
		let currentCountryCode = Locale.autoupdatingCurrent.regionCode
		let locale = NSLocale.autoupdatingCurrent

		let unsorted = Locale.isoRegionCodes.compactMap { (code) -> (String, String)? in
			let identifier = Locale.identifier(fromComponents: [
				NSLocale.Key.countryCode.rawValue: code
			])
			if let countryName = (locale as NSLocale).displayName(
					forKey: .identifier, value: identifier) {
				return (code, countryName)
			} else {
				return nil
			}
		}.map({return CountryModel(code: $0, name: $1)})

		return unsorted.sorted { (country1, country2) -> Bool in
			let code1 = country1.code
			let code2 = country2.code

			if code1 == currentCountryCode {
				return true
			} else if code2 == currentCountryCode {
				return false
			} else {
				let name1 = country1.name
				let name2 = country2.name
				return name1.compare(name2) == .orderedAscending ? true : false
			}
		}
	}
}
