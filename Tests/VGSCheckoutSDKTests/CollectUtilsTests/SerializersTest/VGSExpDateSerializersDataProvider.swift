//
//  VGSExpDateSerializersDataProvider.swift
//  VGSCheckoutSDKTests

import Foundation
import XCTest
@testable import VGSCheckoutSDK

final class VGSExpDateSerializersDataProvider {

	static func provideTestData(for fileName: String) -> [VGSExpDateSeparateSerializerTests.TestJSONData] {
		guard let rootTestJSON = JsonData(jsonFileName: fileName), let testDataJSONArray = rootTestJSON["test_data"] as? [JsonData] else {
			XCTFail("cannot build data for file VGSFieldNameToJSONTestData")
			return []
		}

		var testData = [VGSExpDateSeparateSerializerTests.TestJSONData]()

		for json in testDataJSONArray {
			if let testItem = VGSExpDateSeparateSerializerTests.TestJSONData(json: json) {
				testData.append(testItem)
			} else {
				XCTFail("Cannot build test data for json: \(json)")
			}
		}
		return testData
	}
}
