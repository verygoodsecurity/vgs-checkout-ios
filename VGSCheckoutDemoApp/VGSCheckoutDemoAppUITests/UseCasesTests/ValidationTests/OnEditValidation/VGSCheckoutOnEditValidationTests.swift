//
//  VGSCheckoutOnEditValidationTests.swift
//  VGSCheckoutDemoAppUITests
//

import Foundation
import XCTest

/// Defines features for UI tests to set in launch arguments.
enum VGSCheckoutUITestsFeature: String {

	/// On sumbit validation.
	case onSumbitValidation

	/// On edit validation.
	case onEditValidation
}

/// Tests for `.onEdit` validation feature..
class VGSCheckoutOnEditValidationTests: VGSCheckoutSaveCardBaseTestCase {

	/// Setup
	override func setUp() {
		super.setUp()

		// Append onEdit validation feature.
		app.launchArguments.append(VGSCheckoutUITestsFeature.onEditValidation.rawValue)
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

		// Dismiss keyboard.
		dismissKeyboardForCardDetails()

		// Verifies errors for valid card are not displayed.
		verifyNoErrorForValidCard()

		// Dismiss keyboard.
		dismissKeyboardForCardDetails()
	}

	// MARK: - Helpers

	/// Verifies save card button user interaction.
	/// - Parameter isEnabled: `Bool` object, `isEnabled` flag.
	func verifySaveCardButtonUserInteraction(isEnabled: Bool) {

		// Swipe up to the bottom of the screen.
		app.swipeUp()

		// Verify if save card button is disabled.
		print(Buttons.checkoutSaveCard.find(in: app).isEnabled)
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
		XCTAssertFalse(Labels.CheckoutErrorLabels.CardDetails.emptyCardNumber.exists(in: app))
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
		XCTAssertTrue(Labels.CheckoutErrorLabels.CardDetails.emptyCardNumber.exists(in: app))
	}

	/// Verifies invalid card number error is displayed.
	func verifyInvalidCardNumberError() {
		// Focus card number field and type smth.
		VGSTextField.CardDetails.cardNumber.find(in: app).type("411", shouldClear: true)

		// Focus card exp date.
		VGSTextField.CardDetails.expirationDate.find(in: app).tap()

		// Verify empty card error is displayed.
		XCTAssertTrue(Labels.CheckoutErrorLabels.CardDetails.invalidCardNumber.exists(in: app))
	}

	/// Verifies error is hidden only on editing.
	func verifyHideErrorOnEditing() {
		// Focus card number field and type smth.
		VGSTextField.CardDetails.cardNumber.find(in: app).type("411", shouldClear: true)

		// Focus card exp date.
		VGSTextField.CardDetails.expirationDate.find(in: app).tap()

		// Verify empty card error is displayed.
		XCTAssertTrue(Labels.CheckoutErrorLabels.CardDetails.invalidCardNumber.exists(in: app))

		// Focus card number again.
		VGSTextField.CardDetails.cardNumber.find(in: app).tap()

		// Verify error is still displayed.
		XCTAssertTrue(Labels.CheckoutErrorLabels.CardDetails.invalidCardNumber.exists(in: app))

		// Start typing smth in card number.
		VGSTextField.CardDetails.cardNumber.find(in: app).type("411", shouldClear: false)

		// Verify error is not displayed after editing card number.
		XCTAssertFalse(Labels.CheckoutErrorLabels.CardDetails.invalidCardNumber.exists(in: app))
	}

	/// Verifies no error for valid card.
	func verifyNoErrorForValidCard() {
		// Focus card number field and type smth.
		VGSTextField.CardDetails.cardNumber.find(in: app).type("4111111111111111", shouldClear: true)

		// Focus card exp date.
		VGSTextField.CardDetails.expirationDate.find(in: app).tap()

		// Verify card errors are not displayed.
		XCTAssertFalse(Labels.CheckoutErrorLabels.CardDetails.invalidCardNumber.exists(in: app))
		XCTAssertFalse(Labels.CheckoutErrorLabels.CardDetails.emptyCardNumber.exists(in: app))
	}
}
