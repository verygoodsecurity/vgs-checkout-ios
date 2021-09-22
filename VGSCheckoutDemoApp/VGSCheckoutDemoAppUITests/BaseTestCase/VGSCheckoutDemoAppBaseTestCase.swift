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

		continueAfterFailure = false

		app = XCUIApplication()
		app.launchArguments.append("VGSCheckoutDemoAppUITests")

		// Start the app.
		app.launch()
	}

	/// Tear down tests.
	override func tearDown() {
		super.tearDown()
	}

	/// Demo app use cases.
	enum UseCases {
		/// Checkout custom config.
		static let customConfig = "Checkout Custom Config"
	}

	/// Navigate to custom config use case.
	func navigateToCustomConfigUseCase() {
		app.tables.staticTexts[UseCases.customConfig].tap()
	}
}
