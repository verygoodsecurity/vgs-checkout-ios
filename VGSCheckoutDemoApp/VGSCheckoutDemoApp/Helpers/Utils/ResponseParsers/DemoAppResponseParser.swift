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

	/// Log failed request.
	/// - Parameters:
	///   - response: `URLResponse?` object.
	///   - data: `Data?` object of failed request.
	///   - error: `Error?` object, request error.
	///   - code: `Int` object, status code.
	internal static func logErrorResponse(_ response: URLResponse?, data: Data?, error: Error?) {

		if let url = response?.url {
			print("❗Failed ⬇️ request url: \(stringFromURL(url))")
		}

		if let httpResponse = response as? HTTPURLResponse {
			print("❗Failed ⬇️ response status code: \(httpResponse.statusCode)")
			print("❗Failed ⬇️ response headers:")
			print(normalizeHeadersForLogs(httpResponse.allHeaderFields))
		}
		if let errorData = data {
			if let bodyErrorText = String(data: errorData, encoding: String.Encoding.utf8) {
				print("❗Failed ⬇️ response extra info:")
				if bodyErrorText.count > 10000 {
					print("response size is too big to print. Use debugger if needed.")
				} else {
					print("\(bodyErrorText)")
				}
			}
		}

		// Track error.
		let errorMessage = (error as NSError?)?.localizedDescription ?? ""

		print("❗Failed ⬇️ response error message: \(errorMessage)")
		print("------------------------------------")
	}

	/// Log sending request.
	/// - Parameters:
	///   - request: `URLRequest` object, request to send.
	///   - payload: `String: Any` object, request payload.
	internal static func logRequest(_ request: URLRequest, payload: [String: Any]?) {

		print("⬆️ Send request url: \(stringFromURL(request.url))")
		print("⬆️ request method: \(request.httpMethod ?? "HTTP METHOD NOT SET!")")
		if let headers = request.allHTTPHeaderFields {
			print("⬆️ Send request headers:")
			print(normalizeRequestHeadersForLogs(headers))
		}
		if let payloadValue = payload {
			print("⬆️ Send request payload:")
			print(stringifyRawRequestPayloadForLogs(payloadValue))
		}
		print("------------------------------------")
	}

	/// Stringify URL.
	/// - Parameter url: `URL?` to stringify.
	/// - Returns: String representation of `URL` string or "".
	private static func stringFromURL(_ url: URL?) -> String {
		guard let requestURL = url else {return ""}
		return requestURL.absoluteString
	}

	/// Utility function to normalize request headers for logging.
	/// - Parameter headers: `[String : String]`, request headers.
	/// - Returns: `String` object, normalized headers string.
	private static func normalizeRequestHeadersForLogs(_ headers: [String: String]) -> String {
		let stringifiedHeaders = headers.map({return "  \($0.key) : \($0.value)"}).joined(separator: "\n  ")

		return "[\n  \(stringifiedHeaders) \n]"
	}

	/// Utility function to normalize response headers for logging.
	/// - Parameter headers: `[AnyHashable : Any]`, response headers.
	/// - Returns: `String` object, normalized headers string.
	private static func normalizeHeadersForLogs(_ headers: [AnyHashable: Any]) -> String {
		let stringifiedHeaders = headers.map({return "  \($0.key) : \($0.value)"}).joined(separator: "\n  ")

		return "[\n  \(stringifiedHeaders) \n]"
	}

	/// Stringify payload of `Any` type for logging.
	/// - Parameter payload: `Any` paylod.
	/// - Returns: `String` object, formatted stringified payload.
	private static func stringifyRawRequestPayloadForLogs(_ payload: Any) -> String {
		if let json = payload as? [String: Any] {
			return stringifyJSONForLogs(json)
		}

		return ""
	}

	/// Stringify `JSON` for logging.
	/// - Parameter vgsJSON: `[String: Any]` object.
	/// - Returns: `String` object, pretty printed `JSON`.
	private static func stringifyJSONForLogs(_ vgsJSON: [String: Any]) -> String {
		if let json = try? JSONSerialization.data(withJSONObject: vgsJSON, options: .prettyPrinted) {
			let stringToPrint = String(decoding: json, as: UTF8.self)
			if stringToPrint.count > 10000 {
				return "Response size is too big to print. Use debugger if needed."
			} else {
				return stringToPrint
			}
		} else {
				return ""
		}
	}
}
