//
//  VGSCheckoutOnlyPostalCodeTests.swift
//  VGSCheckoutDemoAppUITests

import Foundation
import XCTest

/// Tests for `.onlyPostalCodeField` feature.
class VGSCheckoutOnlyPostalCodeTests: VGSCheckoutSaveCardBaseTestCase {

	/// Setup.
	override func setUp() {
		super.setUp()

		// Append onFocus validation feature.
		app.launchArguments.append(VGSCheckoutUITestsFeature.onFocusValidation.launchArgument)
	}

	/// Test validation when only zip code field is available (for USA).
	func testOnlyZipCodeField() {
		// Append valid countries.
		app.launchArguments.append(VGSCheckoutUITestsFeature.validCountries(["US"]).launchArgument)
		app.launchArguments.append(VGSCheckoutUITestsFeature.onlyPostalCodeFieldInAddress.launchArgument)

		// Launch app.
		app.launch()

		// Navigate to Custom config use case.
		navigateToCustomConfigUseCase()

		// Open checkout screen.
		startCheckout()

		// Verify ZIP field is available.
		verifyOnlyZipFieldIsVisible()

		// Fill in correct card data.
		fillInCorrectCardData()

		// Swipe up.
		app.swipeUp()

		// Verify zip code error is displayed for invalid zip.
		verifyInvalidZipCodeError()

		// Verify zip code error is not displayed for valid zip.
		verifyValidZipCodeNoError()

		// Wait for keyboard dismiss.
		wait(forTimeInterval: 0.5)

		// Tap to save card data.
		tapToSaveCardInCheckout()

		// Check success alert.
		verifySuccessAlertExists()
	}

	/// Test validation when only postal code field is available (for CA).
	func testOnlyPostalCodeField() {
		// Append valid countries.
		app.launchArguments.append(VGSCheckoutUITestsFeature.validCountries(["CA"]).launchArgument)
		app.launchArguments.append(VGSCheckoutUITestsFeature.onlyPostalCodeFieldInAddress.launchArgument)

		// Launch app.
		app.launch()

		// Navigate to Custom config use case.
		navigateToCustomConfigUseCase()

		// Open checkout screen.
		startCheckout()

		// Verify ZIP field is available.
		verifyOnlyPostalCodeFieldIsVisible()

		// Fill in correct card data.
		fillInCorrectCardData()

		// Swipe up.
		app.swipeUp()

		// Verify postal code error is displayed for invalid CA postal code.
		verifyPostalCodeErrorsForCanada()

		// Verify postal code error is not displayed for valid CA postal code.
		verifyPostalCodeNoErrorsForCanada()

		// Wait for keyboard dismiss.
		wait(forTimeInterval: 0.5)

		// Tap to save card data.
		tapToSaveCardInCheckout()

		// Check success alert.
		verifySuccessAlertExists()
	}


	/// Test address section is hidden when no postal code.
	func testAddressSectionHiddenWhenNoPostalCode() {
		// Append valid countries.
		app.launchArguments.append(VGSCheckoutUITestsFeature.validCountries(["BO"]).launchArgument)
		app.launchArguments.append(VGSCheckoutUITestsFeature.onlyPostalCodeFieldInAddress.launchArgument)

		// Launch app.
		app.launch()

		// Navigate to Custom config use case.
		navigateToCustomConfigUseCase()

		// Open checkout screen.
		startCheckout()

		// Verify ZIP field is hidden.
		XCTAssertFalse(Labels.CheckoutHints.BillingAddress.zipHint.exists(in: app))

		// Verify Postal code field is hidden.
		XCTAssertFalse(Labels.CheckoutHints.BillingAddress.postalCodeHint.exists(in: app))

		// Verify other fields are hidden.
		verifyAddressFieldsAreHidden()

		// Verify address section is hidden.
		XCTAssertFalse(Labels.CheckoutSectionTitles.billingAddress.exists(in: app))

		// Fill in correct card data.
		fillInCorrectCardData()

		// Swipe up.
		app.swipeUp()

		// Wait for keyboard dismiss.
		wait(forTimeInterval: 0.5)

		// Tap to save card data.
		tapToSaveCardInCheckout()

		// Check success alert.
		verifySuccessAlertExists()
	}

	// MARK: - Helpers

	/// Verifies error is not displayed for valid zip code.
	func verifyValidZipCodeNoError() {
		// Swipe up to bottom.
		app.swipeUp()

		// Type valid zip code.
		VGSTextField.BillingAddress.zip.find(in: app).type("12345")

		// Focus to card number field.
		VGSTextField.CardDetails.cardNumber.find(in: app).tap()

		// Verify invalid zip code error is not displayed.
		XCTAssertFalse(Labels.CheckoutErrorLabels.BillingAddress.invalidZIP.exists(in: app))
	}

	/// Verifies invalid zip code error is displayed.
	func verifyInvalidZipCodeError() {
		// Swipe up to bottom.
		app.swipeUp()

		// Type invalid zip code.
		VGSTextField.BillingAddress.zip.find(in: app).type("1234", shouldClear: true)

		// Focus to card number field.
		VGSTextField.CardDetails.cardNumber.find(in: app).tap()

		// Verify invalid zip code error is displayed.
		XCTAssertTrue(Labels.CheckoutErrorLabels.BillingAddress.invalidZIP.exists(in: app))
	}

	/// Verifies postal code/zip errors are updated correctly on country change.
	func verifyErrorsUpdateOnSwitchingCaToUS() {
		// Swipe up to bottom.
		app.swipeUp()

		// Type valid zip code.
		VGSTextField.BillingAddress.postalCode.find(in: app).type("12345", shouldClear: true)

		// Focus to city field.
		VGSTextField.BillingAddress.city.find(in: app).tap()

		// Check postal code errors.
		XCTAssertTrue(Labels.CheckoutErrorLabels.BillingAddress.invalidPostalCode.exists(in: app))

		// Switch to the US from Canada.
		selectCountry("United States", currentCounryName: "Canada")

		// Verify zip code UI is displayed.
		verifyZIPUI()

		// Verify zip code error is not displayed.
		XCTAssertFalse(Labels.CheckoutErrorLabels.BillingAddress.invalidZIP.exists(in: app))

		// Switch back to Canada from the US
		selectCountry("Canada", currentCounryName: "United States")

		// Verify postal code UI is displayed.
		verifyPostalCodeUI()

		// Verify postal code errors is displayed.
		XCTAssertTrue(Labels.CheckoutErrorLabels.BillingAddress.invalidPostalCode.exists(in: app))
	}

	/// Verifies postal code errors are displayed correctly for Canada.
	func verifyPostalCodeErrorsForCanada() {
		// Swipe up to bottom.
		app.swipeUp()

		// Type invalid postal code for Canada.
		VGSTextField.BillingAddress.postalCode.find(in: app).type("12345", shouldClear: true)

		// Focus to card number field.
		VGSTextField.CardDetails.cardNumber.find(in: app).tap()

		// Check postal code errors.
		XCTAssertTrue(Labels.CheckoutErrorLabels.BillingAddress.invalidPostalCode.exists(in: app))
	}

	/// Verifies no postal code errors are displayed correctly for Canada.
	func verifyPostalCodeNoErrorsForCanada() {
		// Swipe up to bottom.
		app.swipeUp()

		// Type valid postal code for Canada.
		VGSTextField.BillingAddress.postalCode.find(in: app).type("N0K1W0", shouldClear: true)

		// Focus to card number field.
		VGSTextField.CardDetails.cardNumber.find(in: app).tap()

		// Check postal code errors.
		XCTAssertFalse(Labels.CheckoutErrorLabels.BillingAddress.invalidPostalCode.exists(in: app))
	}

	/// Verifies only zip field is visible.
	func verifyOnlyZipFieldIsVisible() {
		// Swipe down.
		app.swipeDown()

		// Verify ZIP field is available.
		verifyZIPUI()

		// Verifies other address fields are hidden.
		verifyAddressFieldsAreHidden()
	}

	/// Verifies only postal code field is visible.
	func verifyOnlyPostalCodeFieldIsVisible() {
		// Swipe down.
		app.swipeDown()

		// Verify postal code field is available.
		verifyPostalCodeUI()

		// Verifies other address fields are hidden.
		verifyAddressFieldsAreHidden()
	}

	// Verifies other address fields are hidden.
	func verifyAddressFieldsAreHidden() {
		// Verify country hint doesn't exists.
		XCTAssertFalse(Labels.CheckoutHints.BillingAddress.countryHint.exists(in: app))

		// Verify address line 1 hint doesn't exists.
		XCTAssertFalse(Labels.CheckoutHints.BillingAddress.addressLine1Hint.exists(in: app))

		// Verify address line 2 hint doesn't exists.
		XCTAssertFalse(Labels.CheckoutHints.BillingAddress.addressLine2Hint.exists(in: app))

		// Verify city hint doesn't exists.
		XCTAssertFalse(Labels.CheckoutHints.BillingAddress.cityHint.exists(in: app))
	}
}
