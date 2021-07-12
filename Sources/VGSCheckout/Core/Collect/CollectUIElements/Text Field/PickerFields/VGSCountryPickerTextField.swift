//
//  VGSCountryPickerTextField.swift
//  VGSCheckout

import Foundation
#if os(iOS)
import UIKit
#endif

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

	lazy var countries: [VGSAddressCountriesDataProvider.CountryModel] = {
		return VGSAddressCountriesDataProvider.provideCountries()
	}()

	func numberOfRows() -> Int {
		return countries.count
	}
}
