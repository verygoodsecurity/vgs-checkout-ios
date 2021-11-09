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

		// Append onEdit validation feature.
		app.launchArguments.append(VGSCheckoutTestFeature.onEditValidation)
	}

	/// Test success flow with onedit validation.
	func testOnEditValidationSuccessFlow() {
		// Navigate to Custom config use case.
		navigateToCustomConfigUseCase()

		// Open checkout screen.
		startCheckout()

		// Verify save button is initially disabled.
		verifySaveCardButtonUserInteraction(isEnabled: false)

		// Verify error is displayed only for dirty field in card number.
		verifyNoEmptyCardError()
		verifyEmptyCardErrorInDirtyField()

		// Dismiss keyboard.
		dismissKeyboardForCardDetails()

		// Verify empty error is displayed.
		verifyInvalidCardNumberError()

		// Dismiss keyboard.
		dismissKeyboardForCardDetails()

		// Verify error is hidden only after editing incorrect field.
		verifyHideErrorOnEditing()




		// Verify there is no error in cardHolder field after endEditing field event and changing focus without any initial input (cardHolder is not dirty).

		// Fill in billing addreess.
		fillInCorrectBillingAddress()

		// Wait for keyboard dismiss.
		wait(forTimeInterval: 0.5)

		// Tap to save card data.
		tapToSaveCardInCheckout()

		// Check success alert.
		verifySuccessAlertExists()
	}

	// MARK: - Helpers

	/// Verifies save card button user interaction.
	/// - Parameter isEnabled: `Bool` object, `isEnabled` flag.
	func verifySaveCardButtonUserInteraction(isEnabled: Bool) {

		// Swipe up to the bottom of the screen.
		app.swipeUp()

		// Verify if save card button is disabled.
		XCTAssertTrue(Buttons.checkoutSaveCard.find(in: app).isEnabled == isEnabled)

		// Swipe down to the top of the screen.
		app.swipeDown()
	}

	/// Verifies empty card error is not displayed.
	func verifyNoEmptyCardError() {
		// Focus card number field.
		VGSTextField.CardDetails.cardNumber.find(in: app).tap()

		// Focus card exp date.
		VGSTextField.CardDetails.expirationDate.find(in: app).tap()

		// Verify empty card error is not displayed.
		XCTAssertFalse(Labels.CheckoutErrorLabels.CardDetails.emptyCardNumber.find(in: app))
	}

	/// Verifies empty card error is displayed for dirty field.
	func verifyEmptyCardErrorInDirtyField() {
		// Focus card number field and type smth.
		VGSTextField.CardDetails.cardNumber.find(in: app).type("411")

		// Clear card number field.
		VGSTextField.CardDetails.cardNumber.find(in: app).type("", shouldClear: true)

		// Focus card exp date.
		VGSTextField.CardDetails.expirationDate.find(in: app).tap()

		// Verify empty card error is displayed.
		XCTAssertTrue(Labels.CheckoutErrorLabels.CardDetails.emptyCardNumber.find(in: app))
	}

	/// Verifies invalid card number error is displayed.
	func verifyInvalidCardNumberError() {
		// Focus card number field and type smth.
		VGSTextField.CardDetails.cardNumber.find(in: app).type("411", shouldClear: true)

		// Focus card exp date.
		VGSTextField.CardDetails.expirationDate.find(in: app).tap()

		// Verify empty card error is displayed.
		XCTAssertTrue(Labels.CheckoutErrorLabels.CardDetails.invalidCardNumber.find(in: app))
	}

	/// Verifies error is hidden only on editing.
	func verifyHideErrorOnEditing() {
		// Focus card number field and type smth.
		VGSTextField.CardDetails.cardNumber.find(in: app).type("411", shouldClear: true)

		// Focus card exp date.
		VGSTextField.CardDetails.expirationDate.find(in: app).tap()

		// Verify empty card error is displayed.
		XCTAssertTrue(Labels.CheckoutErrorLabels.CardDetails.invalidCardNumber.find(in: app))

		// Focus card number again.
		VGSTextField.CardDetails.cardNumber.find(in: app)

		// Verify error is still displayed.
		XCTAssertTrue(Labels.CheckoutErrorLabels.CardDetails.invalidCardNumber.find(in: app))

		// Start typing smth in card number.
		VGSTextField.CardDetails.cardNumber.find(in: app).type("411", shouldClear: false)

		// Verify error is not displayed after editing card number.
		XCTAssertFalse(Labels.CheckoutErrorLabels.CardDetails.invalidCardNumber.find(in: app))
	}
}
