//
//  VGSAddressCountriesDataProvider.swift
//  VGSCheckoutSDK

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

//	/// Countries with address verification support.
//	private static let countriesWithAVSSupport = ["US", "CA", "NZ", "GB", "AU"]

	/// First country in picker.
	internal static let defaultFirstCountryCode: VGSCountriesISO = VGSCountriesISO.us

	/// First country model in picker.
	private static var firstCountryModel: CountryModel? {
		let locale = NSLocale(localeIdentifier: "en_US")
		let identifier = Locale.identifier(fromComponents: [
			NSLocale.Key.countryCode.rawValue: defaultFirstCountryCode.rawValue
		])

		if let countryName = (locale as NSLocale).displayName(
				forKey: .identifier, value: identifier) {
			return CountryModel(code: defaultFirstCountryCode.rawValue, name: countryName)
		} else {
			return nil
		}
	}
  
  /// List of  country models that match provided valid `countryISOCodes`. Order will be the same as order in `countryISOCodes`. Returns all countries if no valid `countryISOCodes`.
  static func provideCountriesWithISOCode(_ countryISOCodes: [String]?) -> [CountryModel] {
    let allCountries = provideAllCountries()
    guard let countryCodes = countryISOCodes, !countryCodes.isEmpty else {
      let message = "No valid country ISO Codes provided. All countries will be used."
      let event = VGSLogEvent(level: .warning, text: message, severityLevel: .error)
      VGSCheckoutLogger.shared.forwardLogEvent(event)
      return allCountries
    }
    
    /// Normalize case sensitive country codes and remove duplicates.
    let normalizeCountryCodes = normalizeCountryCodes(countryCodes)
    
    var validCountryModels = [CountryModel]()
    var invalidCountryISOCodes = [String]()
    for countryCode in normalizeCountryCodes {
      if let countryModel = allCountries.first(where: {$0.code == countryCode}) {
        validCountryModels.append(countryModel)
      } else {
        invalidCountryISOCodes.append(countryCode)
      }
    }
    if !invalidCountryISOCodes.isEmpty {
      let message = "Invalid country ISO Codes provided and will be ignored: \(invalidCountryISOCodes.description) \n\n NOTE: Check valid country ISO codes here: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2"
      let event = VGSLogEvent(level: .warning, text: message, severityLevel: .warning)
      VGSCheckoutLogger.shared.forwardLogEvent(event)
    }
    
    guard !validCountryModels.isEmpty else {
      let message = "No valid country ISO Codes provided. All countries will be used.\n\n NOTE: Check valid country ISO codes here: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2 ."
      let event = VGSLogEvent(level: .warning, text: message, severityLevel: .error)
      VGSCheckoutLogger.shared.forwardLogEvent(event)
      return allCountries
    }
    return validCountryModels
  }
  
	/// List of available countries in alphabetical order. US will be on the top of the list.
	static func provideAllCountries() -> [CountryModel] {
		// Filter valid coutries.
	  let filtered = provideCountries()
    
		// Insert selected country on the top of the list.
		if let model = firstCountryModel {
			let unsortedFiltered = filtered.filter({ $0.code != defaultFirstCountryCode.rawValue})
			return [model] + unsortedFiltered
		} else {
			return filtered
		}
	}

	/// Provide all countries.
	/// - Returns: `[CountryModel]`, array of `CountryModel`.
	private static func provideCountries() -> [CountryModel] {
		let locale = NSLocale(localeIdentifier: "en_US")

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
  
  // Normalize case sensitive country codes and remove duplicates.
  fileprivate  static func normalizeCountryCodes(_ countryCodes: [String]) -> [String] {
    return countryCodes.map({return $0.uppercased()}).uniqued()
  }
}
