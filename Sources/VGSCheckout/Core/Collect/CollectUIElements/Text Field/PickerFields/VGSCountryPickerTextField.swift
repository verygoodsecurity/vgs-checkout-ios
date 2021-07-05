//
//  VGSCountryPickerTextField.swift
//  VGSCheckout

import Foundation
#if os(iOS)
import UIKit
#endif

/// Text field with picker view input.
internal class VGSCountryPickerTextField: VGSPickerTextField {

	override func mainInitialization() {
		super.mainInitialization()

		pickerView.selectRow(0, inComponent: 0, animated: false)
		pickerView(pickerView, didSelectRow: 0, inComponent: 0)
	}
}

internal class VGSCountryPickerDataSource: NSObject, VGSPickerTextFieldDataSourceProtocol {
	func pickerField(_ pickerField: VGSPickerTextField, titleForRow row: Int) -> String? {
		guard row >= 0,
					row < countries.count
		else {
			return nil
		}

		return countries[row].name
	}

	func pickerField(_ pickerField: VGSPickerTextField, inputValueForRow row: Int) -> String? {
		guard row >= 0,
					row < countries.count
		else {
			return nil
		}

		return countries[row].code
	}

	lazy var countries: [VGSAddressDataProvider.CountryModel] = {
		return VGSAddressDataProvider.provideCountries()
	}()

	func numberOfRows() -> Int {
		return countries.count
	}
}

internal class VGSAddressDataProvider {

	struct CountryModel {
		let code: String
		let name: String
	}

	static func provideCountries() -> [CountryModel] {
		let currentCountryCode = Locale.autoupdatingCurrent.regionCode
		let locale = NSLocale.autoupdatingCurrent

		let unsorted = Locale.isoRegionCodes.compactMap { (code) -> (String, String)? in
			let identifier = Locale.identifier(fromComponents: [
				NSLocale.Key.countryCode.rawValue: code
			])
			if let countryName = (locale as NSLocale).displayName(
					forKey: .identifier, value: identifier)
			{
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
