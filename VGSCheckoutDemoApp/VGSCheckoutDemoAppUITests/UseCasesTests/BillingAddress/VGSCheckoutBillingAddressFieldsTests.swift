//
//  VGSCheckoutBillingAddressFieldsTests.swift
//  VGSCheckoutDemoAppUITests

import Foundation
import XCTest

/// Tests for billing address section fields checkout flow.
class VGSCheckoutBillingAddressFieldsTests: VGSCheckoutSaveCardBaseTestCase {

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

	// Verifies all address fields are hidden.
	func verifyAllAddressFieldsAreHidden() {
		// Verify billing address section hint doesn't exist.
		XCTAssertFalse(Labels.CheckoutSectionTitles.billingAddress.exists(in: app))

		// Verify country hint doesn't exists.
		XCTAssertFalse(Labels.CheckoutHints.BillingAddress.countryHint.exists(in: app))

		// Verify address line 1 hint doesn't exists.
		XCTAssertFalse(Labels.CheckoutHints.BillingAddress.addressLine1Hint.exists(in: app))

		// Verify address line 2 hint doesn't exists.
		XCTAssertFalse(Labels.CheckoutHints.BillingAddress.addressLine2Hint.exists(in: app))

		// Verify city hint doesn't exists.
		XCTAssertFalse(Labels.CheckoutHints.BillingAddress.cityHint.exists(in: app))

		// Verify zip code hint doesn't exists.
		XCTAssertFalse(Labels.CheckoutHints.BillingAddress.zipHint.exists(in: app))

		// Verify postal code hint doesn't exists.
		XCTAssertFalse(Labels.CheckoutHints.BillingAddress.postalCodeHint.exists(in: app))
	}
}
