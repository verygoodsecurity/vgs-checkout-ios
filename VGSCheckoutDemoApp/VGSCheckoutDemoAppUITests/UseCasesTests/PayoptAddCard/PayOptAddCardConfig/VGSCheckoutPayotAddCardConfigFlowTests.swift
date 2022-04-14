//
//  VGSCheckoutPayotAddCardConfigFlowTests.swift
//  VGSCheckoutDemoAppUITests

import Foundation
import XCTest

/// Test payopt add card config use case.
class VGSCheckoutPayotAddCardConfigFlowTests: VGSCheckoutSaveCardBaseTestCase {

	/// Setup tests.
	override func setUp() {
		super.setUp()

		// Launch app.
		app.launch()
	}

	/// Test success flow for correct inputs.
	func testSuccessFlow() {
		// Navigate to payopt add card config use case.
		navigateToPayoptAddCardUseCase()

		// Open checkout screen.
		startPayoptAddCardCheckout()

		// Fill in card data.
		fillInCorrectCardData()

		// Fill in billing addreess.
		fillInCorrectBillingAddress()

		// Wait for keyboard dismiss.
		wait(forTimeInterval: 0.5)

		// Tap to save card data.
		tapToSaveCardInCheckout()

		// Check success alert.
		verifySuccessAddCardConfigAlertExists()
	}

	/// Test success flow for correct inputs and country without postal code.
	func testSuccessFlowWithNoPostalCode() {
		// Navigate to payopt add card config use case.
		navigateToPayoptAddCardUseCase()

		// Open checkout screen.
		startPayoptAddCardCheckout()

		// Fill in card data.
		fillInCorrectCardData()

		// Fill in billing addreess with no postal code.
		fillInCorrectBillingAddressWithNoPostalCode()

		// Wait for keyboard dismiss.
		wait(forTimeInterval: 0.5)

		// Tap to save card data.
		tapToSaveCardInCheckout()

		// Check success alert.
		verifySuccessAddCardConfigAlertExists()
	}

	/// Test flow with incorrect input data.
	func testErrorFlow() {
		// Navigate to payopt add card config use case.
		navigateToPayoptAddCardUseCase()

		// Open checkout screen.
		startPayoptAddCardCheckout()

		// Fill in wrong card data.
		fillInWrongCardData()

		// Fill in wrong billing address.
		fillInInvalidBillingAddress()

		// Tap to save card data.
		tapToSaveCardInCheckout()

		// Check card details validation errors.
		verifyCardDetailsValidationErrors()

		// Check billing address validation errors.
		verifyBillingAddressValidationErrors()

		// Verify UI on country change - US to Australia.
		verifyChangeCountryFlowUI()
	}
}
