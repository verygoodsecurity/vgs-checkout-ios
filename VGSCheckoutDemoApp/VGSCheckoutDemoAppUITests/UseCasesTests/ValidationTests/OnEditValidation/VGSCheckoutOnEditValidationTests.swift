//
//  VGSCheckoutOnEditValidationTests.swift
//  VGSCheckoutDemoAppUITests
//

import Foundation
import XCTest
import VGSCheckoutDemoApp

/// Test custom config use case.
class VGSCheckoutOnEditValidationTests: VGSCheckoutSaveCardBaseTestCase {

	/// Setup
	override func setUp() {
		super.setUp()

		app.launchArguments.append(VGSCheckoutTestFeature.onEditValidation)
	}

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
