//
//  VGSCheckoutSDKMockedDataProvider.swift
//  VGSCheckoutSDKTests

import Foundation
import XCTest

/// Provider for test data.
final class VGSCheckoutMockedDataProvider {

	static let shared = VGSCheckoutMockedDataProvider()

	var vaultID: String = ""

	/// Not real dummy mocked token for unit tests.
	var dummyMockedTestJWTToken = ""

	/// Not real dummy mocked invalid token for unit tests.
	var dummyMockedTestInvalidJWTToken = ""

	/// no:doc
	private init() {
		setupMockedData()
	}

	func setupMockedData() {

			#if SWIFT_PACKAGE
				let bundle = Bundle.module
			#else
				let bundle = Bundle(for: type(of: VGSCollectTestBundleHelper()))
			#endif

			guard let path = bundle.path(forResource: "VGSCheckoutTestConfig", ofType: "plist") else {
					print("Path not found")
					XCTFail("VGSCheckoutTestConfig not found: bundle: \(bundle)")
					return
			}

			guard let dictionary = NSDictionary(contentsOfFile: path) else {
					XCTFail("Test vault ID not found!")
					return
			}

			vaultID = dictionary["vaultID"] as? String ?? ""
			dummyMockedTestJWTToken = dictionary["dummyMockedTestJWTToken"] as? String ?? ""
			dummyMockedTestInvalidJWTToken = dictionary["dummyMockedTestInvalidJWTToken"] as? String ?? ""
		  print("vaultID in mock data: \(vaultID)")
			print("dummyMockedTestJWTToken in mock data: \(dummyMockedTestJWTToken)")
			print("dummyMockedTestInvalidJWTToken in mock data: \(dummyMockedTestInvalidJWTToken)")
		}
}
