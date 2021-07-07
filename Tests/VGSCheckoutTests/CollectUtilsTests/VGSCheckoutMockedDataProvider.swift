//
//  VGSCheckoutMockedDataProvider.swift
//  VGSCheckoutTests

import Foundation
import XCTest

/// Provider for test data.
final class VGSCheckoutMockedDataProvider {

	static let shared = VGSCheckoutMockedDataProvider()

	var vaultID: String = ""

	private init() {
		setupMockedData()
	}

	func setupMockedData() {
			guard let path = Bundle.main.path(forResource: "VGSCheckoutTestConfig", ofType: "plist") else {
					print("Path not found")
					XCTFail("Test vault ID not found")
					return
			}

			guard let dictionary = NSDictionary(contentsOfFile: path) else {
					XCTFail("Test vault ID not found")
					return
			}

			vaultID = dictionary["vaultID"] as? String ?? ""
		}
}
