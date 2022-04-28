//
//  VGSCheckoutPayotAddCardSavedCardsTests.swift
//  VGSCheckoutDemoAppUITests

import Foundation
import XCTest

/// Test payopt add card with saved cards.
class VGSCheckoutPayotAddCardSavedCardsTests: VGSCheckoutSaveCardBaseTestCase {

	/// Setup tests.
	override func setUp() {
		super.setUp()

	}

	/// Tests remove saved cards.
	func testRemoveSavedCard() {
		// Append saved cards.
		app.launchArguments.append(VGSCheckoutUITestsFeature.savedCards.launchArgument)
		// Mock remove saved card success api request result.
		app.launchArguments.append(VGSCheckoutUITestsFeature.successRemoveSavedCard.launchArgument)

		// Launch app.
		app.launch()

		// Navigate to payopt add card config use case.
		navigateToPayoptAddCardUseCase()

		// Open checkout screen.
		startPayoptAddCardCheckout()

		/// Verifies saved items UI.
		verifySavedCardsItems()

		/// Verifies editing mode UI.
		verifyStartEditingModeUI()

		/// Verifies cancel editing mode UI.
		verifyCancelEditingModeUI()

		/// Tap to start editing mode for saved cards.
		SavedCardsList.Buttons.editButton.find(in: app).tap()

		/// Select second saved card.
		SavedCardsList.SavedCards.secondSavedCard.find(in: app).tap()

		/// Check delete buttons exist.
		XCTAssertTrue(SavedCardsList.Buttons.removeFirstSavedCardButton.exists(in: app))
		XCTAssertTrue(SavedCardsList.Buttons.removeSecondSavedCardButton.exists(in: app))

		/// Remove second card.
		SavedCardsList.Buttons.removeSecondSavedCardButton.find(in: app).tap()

		/// Wait for popup to be presented.
		wait(forTimeInterval: 0.3)

		/// Verify remove card alert.
		XCTAssert(app.alerts.element.staticTexts[SavedCardsList.Alerts.secondCardDescription].exists)

		/// Tap to remove.
		app.alerts.element.buttons[SavedCardsList.Alerts.removeButton].tap()

		/// Wait for delete card.
		wait(forTimeInterval: 2)

		/// Check first card exists.
		XCTAssertTrue(SavedCardsList.SavedCards.firstSavedCard.exists(in: app))

		/// Check second doesn't card exists.
		XCTAssertFalse(SavedCardsList.SavedCards.secondSavedCard.exists(in: app))

		/// Check add new card exists.
		XCTAssertTrue(SavedCardsList.SavedCards.addNewCard.exists(in: app))

		/// Vefiry edit button exists.
		XCTAssertTrue(SavedCardsList.Buttons.editButton.exists(in: app))

		/// Vefiry cancel button doesn't exists.
		XCTAssertFalse(SavedCardsList.Buttons.cancelButton.exists(in: app))

		/// Tap to start editing mode for saved cards.
		SavedCardsList.Buttons.editButton.find(in: app).tap()

		/// Remove first card.
		SavedCardsList.Buttons.removeFirstSavedCardButton.find(in: app).tap()

		/// Wait for popup to be presented.
		wait(forTimeInterval: 0.3)

		/// Verify remove card alert.
		XCTAssert(app.alerts.element.staticTexts[SavedCardsList.Alerts.firstCardDescription].exists)

		/// Tap to remove.
		app.alerts.element.buttons[SavedCardsList.Alerts.removeButton].tap()

		/// Wait for delete card.
		wait(forTimeInterval: 2)

		/// Check first card doesn't exist.
		XCTAssertFalse(SavedCardsList.SavedCards.firstSavedCard.exists(in: app))

		/// Vefiry edit button doesn't exist. We have no more cards to edit.
		XCTAssertFalse(SavedCardsList.Buttons.editButton.exists(in: app))

		/// Vefiry cancel button doesn't exists.
		XCTAssertFalse(SavedCardsList.Buttons.cancelButton.exists(in: app))

		/// Check add new card exists.
		XCTAssertTrue(SavedCardsList.SavedCards.addNewCard.exists(in: app))
	}

	/// Tests when remove card option is disabled.
	func testRemoveCardOptionDisabledUI() {
		// Append saved cards.
		app.launchArguments.append(VGSCheckoutUITestsFeature.savedCards.launchArgument)
		// Disable remove saved card option.
		app.launchArguments.append(VGSCheckoutUITestsFeature.removeCardDisabled.launchArgument)

		// Launch app.
		app.launch()

		// Navigate to payopt add card config use case.
		navigateToPayoptAddCardUseCase()

		// Open checkout screen.
		startPayoptAddCardCheckout()

		/// Verifies saved items UI.
		verifySavedCardsItems()

		/// Vefiry edit button doesn't exist.
		XCTAssertFalse(SavedCardsList.Buttons.editButton.exists(in: app))

		/// Vefiry cancel button doesn't exists.
		XCTAssertFalse(SavedCardsList.Buttons.cancelButton.exists(in: app))
	}

	/// Verifies saved items UI.
	func verifySavedCardsItems() {
		/// Vefiry first saved card exists.
		XCTAssertTrue(SavedCardsList.SavedCards.firstSavedCard.exists(in: app))

		/// Vefiry second saved card exists.
		XCTAssertTrue(SavedCardsList.SavedCards.secondSavedCard.exists(in: app))

		/// Vefiry add new card exists.
		XCTAssertTrue(SavedCardsList.SavedCards.addNewCard.exists(in: app))
	}

	/// Verifies editing mode UI.
	func verifyStartEditingModeUI() {
		/// Tap to start editing mode for saved cards.
		SavedCardsList.Buttons.editButton.find(in: app).tap()

		/// Vefiry edit button doesn't exist.
		XCTAssertFalse(SavedCardsList.Buttons.editButton.exists(in: app))

		/// Vefiry cancel button exists.
		XCTAssertTrue(SavedCardsList.Buttons.cancelButton.exists(in: app))

		/// Vefiry pay button is disabled on editing mode - try to tap.
		Buttons.checkoutSaveCard.find(in: app).tap()
	}

	/// Verifies cancel editing mode UI.
	func verifyCancelEditingModeUI() {
		/// Tap to start editing mode for saved cards.
		SavedCardsList.Buttons.cancelButton.find(in: app).tap()

		/// Vefiry edit button exists.
		XCTAssertTrue(SavedCardsList.Buttons.editButton.exists(in: app))

		/// Vefiry cancel button doesn't exists.
		XCTAssertFalse(SavedCardsList.Buttons.cancelButton.exists(in: app))
	}
}
