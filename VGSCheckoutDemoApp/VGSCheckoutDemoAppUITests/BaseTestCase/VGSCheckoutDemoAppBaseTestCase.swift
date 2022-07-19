//
//  VGSCheckoutDemoAppBaseTestCase.swift
//  VGSCheckoutDemoAppUITests

import Foundation
import XCTest

/// Base test case.
class VGSCheckoutDemoAppBaseTestCase: XCTestCase {

	/// App.
	var app: XCUIApplication!

	/// Setup tests.
	override func setUp() {
		super.setUp()

		// Start the app.
		app = XCUIApplication()
		continueAfterFailure = false
		app.launchArguments.append("VGSCheckoutDemoAppUITests")
	}

	/// Tear down tests.
	override func tearDown() {
		super.tearDown()
	}

	/// Demo app use cases.
	enum UseCases {
		/// Checkout custom config.
		static let customConfig = "Checkout Custom Config"

		/// Checkout add card payopt config.
		static let addCardPayoptConfig = "Checkout Payment Orchestration"
	}

	/// Navigates to custom config use case.
	func navigateToCustomConfigUseCase() {
		app.tables.staticTexts[UseCases.customConfig].tap()
	}

	/// Navigates to pay opt add card use case.
	func navigateToPayoptAddCardUseCase() {
		app.tables.staticTexts[UseCases.addCardPayoptConfig].tap()
	}
}
