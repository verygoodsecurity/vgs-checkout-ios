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

internal typealias JSONArray = [Any]

extension JSONArray {
	init?(jsonFileName: String) {

		guard let bundle = BundleUtils.shared.resourcesBundle, let path = bundle.path(forResource: jsonFileName, ofType: "json") else {
			assertionFailure("Bundle not found!")
			return nil
		}

		do {
			guard let jsonArray = try JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: path)), options: JSONSerialization.ReadingOptions()) as? [Any] else {
				return nil
			}

			self = jsonArray
		} catch {
			return nil
		}
	}
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

	init?(json: JsonData) {
		guard let name = json[VGSAddressRegionModel.codeKey] as? String, let code =  json[VGSAddressRegionModel.nameKey] as? String else {
			return nil
		}

		self.displayName = name
		self.code = code
	}
}

internal class VGSAddressRegionProvider {
	static func provideRegions(for countryCode: String) -> [VGSAddressRegionModel] {

		guard let fileName = regionFileName(for: countryCode), let jsonArray = JSONArray(jsonFileName: fileName)  else {
			return []
		}

		var regions = [VGSAddressRegionModel]()

		for item in jsonArray {
			if let json = item as? JsonData {
				if let region = VGSAddressRegionModel(json: json) {
					regions.append(region)
				}
			}
		}

		return regions
	}

	static func regionFileName(for countryCode: String) -> String? {
		let iso = VGSCountriesISO.self

		switch countryCode {
		case iso.us.rawValue:
			return "VGSUnitedStatesRegions"
		case iso.ca.rawValue:
			return "VGSCanadaRegions"
		default:
			return nil
		}
	}

	static func regionType(for countryCode: String) -> VGSAddressRegionType {
		let countryISO = countryISO(for: countryCode)

		switch countryISO {
		case .us:
			return .state
		case .ca:
			return .province
		default:
			return .general
		}
	}

	static func countryISO(for countryCode: String) -> VGSCountriesISO {
		return VGSCountriesISO(rawValue: countryCode) ?? .us
	}
}
