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
