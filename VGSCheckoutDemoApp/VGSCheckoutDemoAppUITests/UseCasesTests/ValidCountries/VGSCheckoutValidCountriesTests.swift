//
//  VGSCheckoutValidCountriesTests.swift
//  VGSCheckoutDemoAppUITests

import Foundation
import XCTest

/// Tests for `.validCounries` feature.
class VGSCheckoutValidCountriesTests: VGSCheckoutSaveCardBaseTestCase {

	/// Setup.
	override func setUp() {
		super.setUp()

		// Append onFocus validation feature.
		app.launchArguments.append(VGSCheckoutUITestsFeature.onFocusValidation.launchArgument)
	}

	/// Test valid countries feature with Bolivia first in list - Bolivia doesn't have postal code.
	func testValidCountriesWithBoliviaFirst() {
		// Append valid countries.
		app.launchArguments.append(VGSCheckoutUITestsFeature.validCountries(["BO", "US"]).launchArgument)

		// Launch app.
		app.launch()

		// Navigate to Custom config use case.
		navigateToCustomConfigUseCase()

		// Open checkout screen.
		startCheckout()

		// Verify postal code/zip fields are not displayed for Bolivia.
		verifyNoPostalCodeUI()

		// Verify Bolivia is displayed in country field.
		verifyCountryFieldUI(for: "Bolivia")
	}

	/// Test valid countries feature with Canada first in list - Canada has postal code.
	func testValidCountriesWithCanadaFirst() {
		// Append valid countries.
		app.launchArguments.append(VGSCheckoutUITestsFeature.validCountries(["CA", "US"]).launchArgument)

		// Launch app.
		app.launch()

		// Navigate to Custom config use case.
		navigateToCustomConfigUseCase()

		// Open checkout screen.
		startCheckout()

		// Verify postal code UI is displayed.
		verifyPostalCodeUI()

		// Verify Canada is displayed in country field.
		verifyCountryFieldUI(for: "Canada")
	}

	/// Test valid countries feature with empty list - should be all countries with US first.
	func testValidCountriesWithEmptyList() {
		// Append valid countries.
		app.launchArguments.append(VGSCheckoutUITestsFeature.validCountries([]).launchArgument)

		// Launch app.
		app.launch()

		// Navigate to Custom config use case.
		navigateToCustomConfigUseCase()

		// Open checkout screen.
		startCheckout()

		// Verify zip code UI is displayed.
		verifyZIPUI()

		// Verify United States is displayed in country field.
		verifyCountryFieldUI(for: "United States")
	}

	// MARK: - Helpers

	/// Verifies postal code/zip fields are hidden.
	func verifyNoPostalCodeUI() {
		// Swipe up to bottom.
		app.swipeUp()

		// Verify zip field is not displayed.
		XCTAssertFalse(VGSTextField.BillingAddress.zip.exists(in: app))
		// Verify postal code field is not displayed.
		XCTAssertFalse(VGSTextField.BillingAddress.postalCode.exists(in: app))
	}

	/// Verifies correct country name is displayed in country field.
	/// - Parameter countryName: `String` object, country name.
	func verifyCountryFieldUI(for countryName: String) {
		// Swipe up to bottom.
		app.swipeUp()

		// Verify country text field.
		let countryField = VGSUITestElement(type: .textField, identifier: countryName)
		XCTAssertTrue(countryField.exists(in: app))
	}

	/// Verifies error is not displayed for valid zip code.
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

	/// Verifies invalid zip code error is displayed.
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

	/// Verifies postal code/zip errors are updated correctly on country change.
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
