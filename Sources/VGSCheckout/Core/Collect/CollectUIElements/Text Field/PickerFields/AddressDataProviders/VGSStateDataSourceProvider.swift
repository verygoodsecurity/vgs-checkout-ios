//
//  VGSStateDataSourceProvider.swift
//  VGSCheckout

import Foundation

internal enum VGSAddressRegionType {
	case state
	case region
	case province
	case county
	case general
}

internal protocol VGSBaseRegionModelProtocol {
	var regionType: VGSAddressRegionType {get}
	var displayName: String {get set}
}

internal class VGSRegionModelUS: VGSBaseRegionModelProtocol {
	internal var regionType: VGSAddressRegionType {
		return .state
	}

	internal var displayName: String = ""

	internal let code: String = ""
}

internal class VGSAddressRegionProvider {
	static func provideRegions(for countryCode: String) -> [VGSBaseRegionModelProtocol] {

		let iso = VGSCountriesISO.self
		switch countryCode {
		case iso.us.rawValue:
			return []
		case iso.ca.rawValue:
			return []
		default:
			return []
		}

		return [

		]
	}
}

internal class VGSStateDataSourceProvider {

//	struct RegionModel {
//		let code: String
//		let name: String
//	}
//
//	static func provideCountries() -> [CountryModel] {
//		let currentCountryCode = Locale.autoupdatingCurrent.regionCode
//		let locale = NSLocale.autoupdatingCurrent
//
//		let unsorted = Locale.isoRegionCodes.compactMap { (code) -> (String, String)? in
//			let identifier = Locale.identifier(fromComponents: [
//				NSLocale.Key.countryCode.rawValue: code
//			])
//			if let countryName = (locale as NSLocale).displayName(
//					forKey: .identifier, value: identifier) {
//				return (code, countryName)
//			} else {
//				return nil
//			}
//		}.map({return CountryModel(code: $0, name: $1)})
//
//		return unsorted.sorted { (country1, country2) -> Bool in
//			let code1 = country1.code
//			let code2 = country2.code
//
//			if code1 == currentCountryCode {
//				return true
//			} else if code2 == currentCountryCode {
//				return false
//			} else {
//				let name1 = country1.name
//				let name2 = country2.name
//				return name1.compare(name2) == .orderedAscending ? true : false
//			}
//		}
//	}
}
