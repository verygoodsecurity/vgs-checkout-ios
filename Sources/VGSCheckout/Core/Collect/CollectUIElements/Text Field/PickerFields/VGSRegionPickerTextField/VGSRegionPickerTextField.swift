//
//  VGSRegionPickerTextField.swift
//  VGSCheckout

import Foundation
#if os(iOS)
import UIKit
#endif

///// Text field with picker view input.
//internal class VGSCountryPickerTextField: VGSPickerTextField {
//
//	override func mainInitialization() {
//		super.mainInitialization()
//
//		selectFirstRow()
//	}
//
//	internal func selectFirstRow() {
//		pickerView.selectRow(0, inComponent: 0, animated: false)
//		pickerView(pickerView, didSelectRow: 0, inComponent: 0)
//	}
//}

internal class VGSStatePickerDataSource: NSObject, VGSPickerTextFieldDataSourceProtocol {
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
