//
//  DemoAppResponseParser.swift
//  VGSCheckoutDemoApp

import Foundation

class DemoAppResponseParser {
	
	static func stringifySuccessResponse(from data: Data?, rootJsonKey: String = "json") -> String? {
		if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
			// swiftlint:disable force_try
			let response = (String(data: try! JSONSerialization.data(withJSONObject: jsonData[rootJsonKey]!, options: .prettyPrinted), encoding: .utf8)!)
			let text = "Success: \n\(response)"

			return text
			// swiftlint:enable force_try
		}

		return nil
	}

	/// Financial instrument id from success multiplexing save card response.
	/// - Parameter data: `Data?` object, response data.
	/// - Returns: `String?` object, multiplexing financial instrument id or `nil`.
	static func multiplexingFinancialInstrumentID(from data: Data?) -> String? {
		if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
			if let json = jsonData["json"] as? [String: Any] {
				if let dataJSON = json["data"] as? [String: Any] {
					if let financialInstumentID = dataJSON["id"] as? String {
						return financialInstumentID
					}
				}
			}
		}

		return nil
	}
}
