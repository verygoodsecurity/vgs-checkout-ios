//
//  DemoAppResponseParser.swift
//  VGSCheckoutDemoApp

import Foundation

class DemoAppResponseParser {
	
	static func stringifySuccessResponse(from data: Data?) -> String? {
		if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
			// swiftlint:disable force_try
			let response = (String(data: try! JSONSerialization.data(withJSONObject: jsonData["json"]!, options: .prettyPrinted), encoding: .utf8)!)
			let text = "Success: \n\(response)"

			return text
			// swiftlint:enable force_try
		}

		return nil
	}
}
