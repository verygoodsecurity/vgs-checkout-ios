//
//  VGSCheckoutAddressSectionTests.swift
//  VGSCheckoutDemoAppUITests
//

import Foundation
import XCTest

/// Tests for address section checkout flow.
class VGSCheckoutAddressSectionTests: VGSCheckoutSaveCardBaseTestCase {

	/// Test custom config when billing address section is hidden.
	func testCustomConfigWhenAddressHidden() {
		// Hide billing address section.
		app.launchArguments.append(VGSCheckoutUITestsFeature.billingAddressIsHidden.launchArgument)

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
}
