//
//  VGSCheckoutSDKBaseTestCase.swift
//  VGSCheckoutSDKTests

import Foundation
import XCTest
@testable import VGSCheckoutSDK

/// BaseVGSCheckout test case for common setup.
class VGSCheckoutBaseTestCase: XCTestCase {

	/// Setup collect before tests.
	override class func setUp() {
		super.setUp()

		// Disable analytics in unit tests.
		VGSCheckoutAnalyticsClient.shared.shouldCollectAnalytics = false
	}
}
