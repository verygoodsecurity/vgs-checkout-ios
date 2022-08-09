//
//  VGSCheckoutBillingAddressFieldsTests.swift
//  VGSCheckoutDemoAppUITests

import Foundation
import XCTest

/// Tests for billing address section fields checkout flow.
class VGSCheckoutBillingAddressFieldsTests: VGSCheckoutSaveCardBaseTestCase {

	/// Test custom config when all fields in billing address section are hidden.
	func testCustomConfigAllFieldsAreHidden() {
		// Display no address fields in billing address section.
		app.launchArguments.append(VGSCheckoutUITestsFeature.billingAddressFields([]).launchArgument)

		// Launch app.
		app.launch()

		// Navigate to Custom config use case.
		navigateToCustomConfigUseCase()

		// Open checkout screen.
		startCheckout()

		// Swipe up to bottom.
		app.swipeUp()

		// Verify address hints are hidden.
		verifyAllAddressFieldsAreHidden()

		// Swipe down to up.
		app.swipeDown()

		// Fill in card data.
		fillInCorrectCardData()

		// Wait for keyboard dismiss.
		wait(forTimeInterval: 0.5)

		// Tap to save card data.
		tapToSaveCardInCheckout()

		// Check success alert.
		verifySuccessAlertExists()
	}

	/// Test add card config when all fields in billing address section are hidden.
	func testAddCardConfigAllFieldsAreHidden() {
		// Display no address fields in billing address section.
		app.launchArguments.append(VGSCheckoutUITestsFeature.billingAddressFields([]).launchArgument)

		// Launch app.
		app.launch()

		// Navigate to Add card config use case.
		navigateToPayoptAddCardUseCase()

		// Open checkout screen.
		startPayoptAddCardCheckout()

		// Swipe up to bottom.
		app.swipeUp()

		// Verify address hints are hidden.
		verifyAllAddressFieldsAreHidden()

		// Swipe down to up.
		app.swipeDown()

		// Fill in card data.
		fillInCorrectCardData()

		// Wait for keyboard dismiss.
		wait(forTimeInterval: 0.5)

		// Tap to save card data.
		tapToSaveCardInCheckout()

		// Check success alert.
		verifySuccessAddCardConfigAlertExists()
	}

	/// Test custom config when only country field is visible in billing address.
	func testCustomConfigOnlyCountryFieldVisible() {
		// Display no address fields in billing address section.
		app.launchArguments.append(VGSCheckoutUITestsFeature.billingAddressFields([.country]).launchArgument)

		// Launch app.
		app.launch()

		// Navigate to Custom config use case.
		navigateToCustomConfigUseCase()

		// Open checkout screen.
		startCheckout()

		// Swipe up to bottom.
		app.swipeUp()

		// Verify address section is visible.
		verifyIsAddressSectionVisible(true)

		// Verify all address fields are hidden (except country).
		verifyFieldsVisibility([.addressLine1, .addressLine2, .city, .postalCode], isVisible: false)

    // Verify zip is hiden.
		verifyIsZipVisible(false)

		// Verify country field is visible.
		verifyFieldsVisibility([.country], isVisible: true)

		// Change country
		selectCountry("Canada", currentCounryName: "United States")

		// Wait for country change.
		wait(forTimeInterval: 0.2)

		// Verify correct country in field.
		verifyCountryIsDisplayed("Canada")

		// Change country
		selectCountry("United States", currentCounryName: "Canada")

		// Wait for country change.
		wait(forTimeInterval: 0.2)

		// Verify correct country in field.
		verifyCountryIsDisplayed("United States")

		// Wait for country change.
		wait(forTimeInterval: 0.2)

		// Swipe down to up.
		app.swipeDown()

		// Fill in card data.
		fillInCorrectCardData()

		// Wait for keyboard dismiss.
		wait(forTimeInterval: 0.5)

		// Tap to save card data.
		tapToSaveCardInCheckout()

		// Check success alert.
		verifySuccessAlertExists()
	}

	/// Test add card config when only country field is visible in billing address.
	func testAddCardConfigOnlyCountryFieldVisible() {
		// Display no address fields in billing address section.
		app.launchArguments.append(VGSCheckoutUITestsFeature.billingAddressFields([.country]).launchArgument)

		// Launch app.
		app.launch()

		// Navigate to Add card config use case.
		navigateToPayoptAddCardUseCase()

		// Open checkout screen.
		startPayoptAddCardCheckout()

		// Swipe up to bottom.
		app.swipeUp()

		// Verify address section is visible.
		verifyIsAddressSectionVisible(true)

		// Verify all address fields are hidden (except country).
		verifyFieldsVisibility([.addressLine1, .addressLine2, .city, .postalCode], isVisible: false)

		// Verify zip is hiden.
		verifyIsZipVisible(false)

		// Verify country field is visible.
		verifyFieldsVisibility([.country], isVisible: true)

		// Change country
		selectCountry("Canada", currentCounryName: "United States")

		// Wait for country change.
		wait(forTimeInterval: 0.2)

		// Verify correct country in field.
		verifyCountryIsDisplayed("Canada")

		// Change country
		selectCountry("United States", currentCounryName: "Canada")

		// Wait for country change.
		wait(forTimeInterval: 0.2)

		// Verify correct country in field.
		verifyCountryIsDisplayed("United States")

		// Wait for country change.
		wait(forTimeInterval: 0.2)

		// Swipe down to up.
		app.swipeDown()

		// Fill in card data.
		fillInCorrectCardData()

		// Wait for keyboard dismiss.
		wait(forTimeInterval: 0.5)

		// Tap to save card data.
		tapToSaveCardInCheckout()

		// Check success alert.
		verifySuccessAddCardConfigAlertExists()
	}

	/// Test custom config when only country field and postal code field is visible in billing address.
	func testCustomConfigCountryAndPostalCodeVisible() {
		// Display no address fields in billing address section.
		app.launchArguments.append(VGSCheckoutUITestsFeature.billingAddressFields([.country, .postalCode]).launchArgument)
		// Add onFocus validation.
		app.launchArguments.append(VGSCheckoutUITestsFeature.onFocusValidation.launchArgument)

		// Launch app.
		app.launch()

		// Navigate to Custom config use case.
		navigateToCustomConfigUseCase()

		// Open checkout screen.
		startCheckout()

		// Swipe up to bottom.
		app.swipeUp()

		// Verify address section is visible.
		verifyIsAddressSectionVisible(true)

		// Verify all address fields are hidden (except country).
		verifyFieldsVisibility([.addressLine1, .addressLine2, .city], isVisible: false)

		// Verify postal code is hidden.
		verifyIsPostalCodeVisible(false)

		// Verify country field is visible.
		verifyFieldsVisibility([.country, .postalCode], isVisible: true, shouldUseZIP: true)

		// Verify zip is visible.
		verifyIsZipVisible(true)

		// Change country
		selectCountry("Canada", currentCounryName: "United States")

		// Wait for country change.
		wait(forTimeInterval: 0.2)

		// Verify postal code UI is displayed.
		verifyPostalCodeUI()

		// Verify correct country in field.
		verifyCountryIsDisplayed("Canada")

		// Change country
		selectCountry("United States", currentCounryName: "Canada")

		// Wait for country change.
		wait(forTimeInterval: 0.2)

		// Verify change country flow when country has no postal code.
		verifyChangeCountryFlowUI()

		// Verify correct country in field.
		verifyCountryIsDisplayed("United States")

		// Verify postal code errors.
		verifyUpdatePostalCodeErrorOnCountryChange()

		// Wait for country change.
		wait(forTimeInterval: 0.2)

		// Swipe down to up.
		app.swipeDown()

		// Fill in card data.
		fillInCorrectCardData()

		// Wait for keyboard dismiss.
		wait(forTimeInterval: 0.5)

		// Type valid zip code.
		VGSTextField.BillingAddress.zip.find(in: app).type("12345", shouldClear: true)

		// Dismiss keyboard.
		dismissKeyboardForCardDetails()

		// Wait for keyboard dismiss.
		wait(forTimeInterval: 0.5)

		// Tap to save card data.
		tapToSaveCardInCheckout()

		// Check success alert.
		verifySuccessAlertExists()
	}

	/// Test add card config when only country field and postal code field is visible in billing address.
	func testAddCardConfigCountryAndPostalCodeVisible() {
		// Display no address fields in billing address section.
		app.launchArguments.append(VGSCheckoutUITestsFeature.billingAddressFields([.country, .postalCode]).launchArgument)
		// Add onFocus validation.
		app.launchArguments.append(VGSCheckoutUITestsFeature.onFocusValidation.launchArgument)

		// Launch app.
		app.launch()

		// Navigate to Add card config use case.
		navigateToPayoptAddCardUseCase()

		// Open checkout screen.
		startPayoptAddCardCheckout()

		// Swipe up to bottom.
		app.swipeUp()

		// Verify address section is visible.
		verifyIsAddressSectionVisible(true)

		// Verify all address fields are hidden (except country).
		verifyFieldsVisibility([.addressLine1, .addressLine2, .city], isVisible: false)

		// Verify postal code is hidden.
		verifyIsPostalCodeVisible(false)

		// Verify country field is visible.
		verifyFieldsVisibility([.country, .postalCode], isVisible: true, shouldUseZIP: true)

		// Verify zip is visible.
		verifyIsZipVisible(true)

		// Change country
		selectCountry("Canada", currentCounryName: "United States")

		// Wait for country change.
		wait(forTimeInterval: 0.2)

		// Verify postal code UI is displayed.
		verifyPostalCodeUI()

		// Verify correct country in field.
		verifyCountryIsDisplayed("Canada")

		// Change country
		selectCountry("United States", currentCounryName: "Canada")

		// Wait for country change.
		wait(forTimeInterval: 0.2)

		// Verify change country flow when country has no postal code.
		verifyChangeCountryFlowUI()

		// Verify correct country in field.
		verifyCountryIsDisplayed("United States")

		// Verify postal code errors.
		verifyUpdatePostalCodeErrorOnCountryChange()

		// Wait for country change.
		wait(forTimeInterval: 0.2)

		// Swipe down to up.
		app.swipeDown()

		// Fill in card data.
		fillInCorrectCardData()

		// Wait for keyboard dismiss.
		wait(forTimeInterval: 0.5)

		// Type valid zip code.
		VGSTextField.BillingAddress.zip.find(in: app).type("12345", shouldClear: true)

		// Dismiss keyboard.
		dismissKeyboardForCardDetails()

		// Wait for keyboard dismiss.
		wait(forTimeInterval: 0.5)

		// Tap to save card data.
		tapToSaveCardInCheckout()

		// Check success alert.
		verifySuccessAddCardConfigAlertExists()
	}
}
