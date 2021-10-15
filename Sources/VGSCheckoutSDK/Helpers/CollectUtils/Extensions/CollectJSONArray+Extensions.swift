//
//  CollectJSONArray+Extensions.swift
//  VGSCheckoutSDK

import Foundation

/// Defines JSON array.
internal typealias JSONArray = [Any]

internal extension JSONArray {

	/// Init JSONArray with local file.
	/// - Parameter jsonFileName: `String` object, local filename.
	init?(jsonFileName: String) {

		guard let bundle = BundleUtils.shared.resourcesBundle else {
			assertionFailure("Bundle not found!")
			return nil
		}

		guard let path = bundle.path(forResource: jsonFileName, ofType: "json") else {
		assertionFailure("file \(jsonFileName) not found!")
		return nil
		}

		do {
			guard let jsonArray = try JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: path)), options: JSONSerialization.ReadingOptions()) as? [Any] else {
				return nil
			}

			self = jsonArray
		} catch {
			return nil
		}
	}
}
