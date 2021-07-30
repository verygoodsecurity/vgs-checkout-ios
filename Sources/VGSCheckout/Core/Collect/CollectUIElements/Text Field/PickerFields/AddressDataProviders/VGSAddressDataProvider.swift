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

	/// Countries with address verification support.
	private static let supportedCodes = ["US", "CA", "NZ", "GB", "AU"]

	/// First country in picker.
	private static let defaultFirstCountryCode = "US"

	/// First country model in picker.
	private static var firstCountryModel: CountryModel? {
		let locale = NSLocale.autoupdatingCurrent
		let identifier = Locale.identifier(fromComponents: [
			NSLocale.Key.countryCode.rawValue: defaultFirstCountryCode
		])

		if let countryName = (locale as NSLocale).displayName(
				forKey: .identifier, value: identifier) {
			return CountryModel(code: defaultFirstCountryCode, name: countryName)
		} else {
			return nil
		}
	}

	/// List of available countries in alphabetical order. US will be on the top of the list.
	static func provideSupportedCountries() -> [CountryModel] {
		// Filter valid coutries.
	  let filtered = provideCountries().filter({ supportedCodes.contains($0.code) })

		// Insert selected country on the top of the list.
		if let model = firstCountryModel {
			let unsortedFiltered = filtered.filter{($0.code != defaultFirstCountryCode)}
			return [model] + unsortedFiltered
		} else {
			return filtered
		}
	}

	/// Provide all countries.
	/// - Returns: `[CountryModel]`, array of `CountryModel`.
	private static func provideCountries() -> [CountryModel] {
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

		// Sort all countries in alphabetical order.
		return unsorted.sorted { (country1, country2) -> Bool in

			let name1 = country1.name
			let name2 = country2.name
			return name1.compare(name2) == .orderedAscending ? true : false
		}
	}
}
