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

internal extension JsonData {

	init?(jsonFileName: String) {
		let notFoundCompletion = {
			print("JSON file \(jsonFileName).json not found or is invalid")
		}

		guard let bundle = BundleUtils.shared.resourcesBundle else {
			assertionFailure("Bundle not found!")
			return nil
		}

		if let path = bundle.path(forResource: jsonFileName, ofType: "json") {
			do {
				let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
				let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
				guard let json = jsonResult as? JsonData else {
					notFoundCompletion()
					return nil
				}

				self = json
			} catch {
				notFoundCompletion()
				return nil
			}
		} else {
			notFoundCompletion()
			return nil
		}
	}
}

internal struct VGSAddressRegionModel {
	var regionType: VGSAddressRegionType = .region
	let displayName: String
	let code: String

	static let codeKey = "abbreviation"
	static let nameKey = "name"

	init?(regionFileName: String) {
		guard let json = JsonData.init(jsonFileName: regionFileName) else {
			return nil
		}

		guard let name = json[VGSAddressRegionModel.codeKey] as? String, let code =  json[VGSAddressRegionModel.nameKey] as? String else {
			return nil
		}

		self.displayName = name
		self.code = code
	}
}

internal class VGSAddressRegionProvider {
	static func provideRegions(for countryCode: String) -> [VGSAddressRegionModel] {

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
