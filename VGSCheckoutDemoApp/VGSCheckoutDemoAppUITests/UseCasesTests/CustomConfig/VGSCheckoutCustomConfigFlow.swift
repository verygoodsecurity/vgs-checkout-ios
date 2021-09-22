//
//  VGSCheckoutCustomConfigFlow.swift
//  VGSCheckoutDemoAppUITests

import Foundation
import XCTest

/// Test custom config use case.
class VGSCheckoutCustomConfigFlow: VGSCheckoutSaveCardBaseTestCase {

	/// Test success flow for correct inputs.
	func testSuccessFlow() {
		// Navigate to Custom config use case.
		navigateToCustomConfigUseCase()

		// Open checkout screen.
		startCheckout()

		// Fill in card data.
		fillInCorrectCardData()

		// Fill in billing addreess.
		fillInCorrectBillingAddress()

		// Wait for keyboard dismiss.
		wait(forTimeInterval: 0.5)

		// Tap to save card data.
		tapToSaveCardInCheckout()

		// Check success alert.
		verifySuccessAlertExists()
	}

	/// Test flow with incorrect input data.
	func testErrorFlow() {
		// Navigate to Custom config use case.
		navigateToCustomConfigUseCase()

		// Open checkout screen.
		startCheckout()

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
