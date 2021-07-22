//
//  VGSStateDataSourceProvider.swift
//  VGSCheckout

import Foundation

/// Address region type.
internal enum VGSAddressRegionType {

	/// State (US).
	case state

	/// Province (Canada).
	case province

	/// County (United Kingdom).
	case county

	/// Suburb (New Zealand).
	case suburb

	/// Localized text field placeholder.
	internal var lozalizedPlaceholder: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: localizationPlaceholderKey)
	}

	/// Localized text field hint.
	internal var lozalizedHint: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: localizationFieldHintKey)
	}

	/// Localized empty text error.
	internal var lozalizedEmptyError: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: localizationPlaceholderKey)
	}

	/// Region type for country ISO.
	/// - Parameter countryISO: `VGSCountriesISO` object, country ISO.
	/// - Returns: `VGSAddressRegionType` matching specified country.
	internal static func regionType(for countryISO: VGSCountriesISO) -> VGSAddressRegionType {
		switch countryISO {
		case .us, .au:
			return .state
		case .gb:
			return .county
		case .ca:
			return .province
		default:
			return .state
		}
	}

	/// Localized key placeholder key.
	private var localizationPlaceholderKey: String {
		switch self {
		case .state:
			return "vgs_checkout_address_info_region_type_state_hint"
		case .province:
			return "vgs_checkout_address_info_region_type_province_hint"
		case .county:
			return "vgs_checkout_address_info_region_type_county_hint"
		case .suburb:
			return "vgs_checkout_address_info_region_type_suburb_hint"
		}
	}

	/// Localized key for label above the text field.
	private var localizationFieldHintKey: String {
		switch self {
		case .state:
			return "vgs_checkout_address_info_region_type_state_subtitle"
		case .province:
			return "vgs_checkout_address_info_region_type_province_subtitle"
		case .county:
			return "vgs_checkout_address_info_region_type_county_subtitle"
		case .suburb:
			return "vgs_checkout_address_info_region_type_suburb_subtitle"
		}
	}
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
