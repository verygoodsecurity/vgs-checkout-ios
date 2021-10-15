//
//  VGSPostalCodeFieldView.swift
//  VGSCheckoutSDK

import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for postal code field view.
internal class VGSPostalCodeFieldView {

	// MARK: - Interface
	/// Updates UI for postal code field view.
	/// - Parameters:
	///   - fieldView: `VGSTextFieldViewProtocol` object, field view.
	///   - countryISOCode: `VGSCountriesISO` object, country iso code.
	internal static func updateUI(for fieldView: VGSTextFieldViewProtocol, countryISOCode: VGSCountriesISO) {
		let postalCode = VGSBillingAddressUtils.postalCode(for: countryISOCode)

		fieldView.placeholderView.hintLabel.text = postalCode.textFieldHint
		fieldView.textField.placeholder = postalCode.textFieldPlaceholder
	}
}
