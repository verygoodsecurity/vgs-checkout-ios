//
//  VGSCountryPickerDataSource.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Data source for country picker.
internal class VGSCountryPickerDataSource: NSObject, VGSPickerTextFieldDataSourceProtocol {
  
  private(set) var countries = VGSAddressCountriesDataProvider.provideAllCountries()
  
  /// Init woth array of valid countries' ISO-Codes
  convenience init(validCountryISOCodes: [String]?) {
    self.init()
    countries = VGSAddressCountriesDataProvider.provideCountriesWithISOCode(validCountryISOCodes)
  }
  
	func pickerField(_ pickerField: VGSPickerTextField, titleForRow row: Int) -> String? {
		guard row >= 0,
					row < countries.count
		else {
			return nil
		}

		return countries[row].name
	}

	func pickerField(_ pickerField: VGSPickerTextField, selectedValueForRow row: Int) -> String? {
		guard row >= 0,
					row < countries.count
		else {
			return nil
		}

		return countries[row].code
	}

	func numberOfRows() -> Int {
		return countries.count
	}
}
