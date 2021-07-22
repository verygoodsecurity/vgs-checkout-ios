//
//  VGSStateDataSourceProvider.swift
//  VGSCheckout

import Foundation

internal enum VGSAddressRegionType {
	case state
	case province
	case county
	case suburb
}

internal struct VGSAddressRegionModel {
	var regionType: VGSAddressRegionType = .state
	let displayName: String
	let code: String

	static let codeKey = "abbreviation"
	static let nameKey = "name"

	init?(json: JsonData) {
		guard let name = json[VGSAddressRegionModel.nameKey] as? String, let code =  json[VGSAddressRegionModel.codeKey] as? String else {
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
				if var region = VGSAddressRegionModel(json: json) {
					region.regionType = regionType(for: countryCode)
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
		let countryISOValue = countryISO(for: countryCode)

		switch countryISOValue {
		case .us:
			return .state
		case .ca:
			return .province
		default:
			return .state
		}
	}

	static func countryISO(for countryCode: String) -> VGSCountriesISO {
		return VGSCountriesISO(rawValue: countryCode) ?? .us
	}
}

final class VGSRegionsDataSourceProvider: VGSPickerTextFieldDataSourceProtocol {

	private let countryCode: String

	init(with countryCode: String) {
		self.countryCode = countryCode
	}

	lazy var regions: [VGSAddressRegionModel] = {
		return VGSAddressRegionProvider.provideRegions(for: countryCode)
	}()

	func numberOfRows() -> Int {
		return regions.count
	}

	func pickerField(_ pickerField: VGSPickerTextField, titleForRow row: Int) -> String? {
		guard row >= 0,
					row < regions.count
		else {
			return nil
		}

		return regions[row].displayName
	}

	func pickerField(_ pickerField: VGSPickerTextField, selectedValueForRow row: Int) -> String? {
		guard row >= 0,
					row < regions.count
		else {
			return nil
		}

		return regions[row].code
	}
}
