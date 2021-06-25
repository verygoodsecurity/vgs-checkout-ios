//
//  VGSCheckoutBaseTestCase.swift
//  VGSCheckoutTests
//
//  Created on 17.02.2021.
//  Copyright © 2021 VGS. All rights reserved.
//

import Foundation
import XCTest
@testable import VGSCheckout

/// BaseVGSCheckout test case for common setup.
class VGSCheckoutBaseTestCase: XCTestCase {

	/// Setup collect before tests.
	override class func setUp() {
		super.setUp()

		// Disable analytics in unit tests.
		VGSCheckoutAnalyticsClient.shared.shouldCollectAnalytics = false
	}
}
