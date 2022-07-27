//
//  VGSCheckoutSaveCardBaseTestCase+OnFocusAddressValidationExtensions.swift
//  VGSCheckoutDemoAppUITests

import Foundation
import XCTest

// no:doc
extension VGSCheckoutSaveCardBaseTestCase {

	/// Verifies error is not displayed for valid zip code. `.onFocus` validation should be enabled to use this verify func.
	func verifyValidZipCodeNoError() {
		// Swipe up to bottom.
		app.swipeUp()

		// Type valid zip code.
		VGSTextField.BillingAddress.zip.find(in: app).type("12345")

		// Focus to city field.
		VGSTextField.BillingAddress.city.find(in: app).tap()

		// Verify invalid zip code error is not displayed.
		XCTAssertFalse(Labels.CheckoutErrorLabels.BillingAddress.invalidZIP.exists(in: app))
	}

	/// Verifies invalid zip code error is displayed. `.onFocus` validation should be enabled to use this verify func.

	func verifyInvalidZipCodeError() {
		// Swipe up to bottom.
		app.swipeUp()

		// Type invalid zip code.
		VGSTextField.BillingAddress.zip.find(in: app).type("1234", shouldClear: true)

		// Focus to city field.
		VGSTextField.BillingAddress.city.find(in: app).tap()

		// Verify invalid zip code error is displayed.
		XCTAssertTrue(Labels.CheckoutErrorLabels.BillingAddress.invalidZIP.exists(in: app))
	}

	/// Verifies postal code/zip errors are updated correctly on country change. `.onFocus` validation should be enabled to use this verify func.

	func verifyUpdatePostalCodeErrorOnCountryChange() {
		// Swipe up to bottom.
		app.swipeUp()

		// Type valid zip code.
		VGSTextField.BillingAddress.zip.find(in: app).type("12345", shouldClear: true)

		// Switch to Canada from the US.
		selectCountry("Canada", currentCounryName: "United States")

		// Verify postal code UI is displayed.
		verifyPostalCodeUI()

		// Verify postal code error is displayed.
		XCTAssertTrue(Labels.CheckoutErrorLabels.BillingAddress.invalidPostalCode.exists(in: app))

		// Switch to the US from Canada
		selectCountry("United States", currentCounryName: "Canada")

		// Verify zip code UI is displayed.
		verifyZIPUI()

		// Verify error for postal code is not displayed.
		XCTAssertFalse(Labels.CheckoutErrorLabels.BillingAddress.invalidPostalCode.exists(in: app))
	}
}
