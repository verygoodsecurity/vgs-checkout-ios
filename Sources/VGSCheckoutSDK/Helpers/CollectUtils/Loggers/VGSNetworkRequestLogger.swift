//
//  VGSNetworkRequestLogger.swift
//  VGSCheckoutSDK
//

import Foundation

/// Utilities to log network requests.
internal class VGSNetworkRequestLogger {

	/// A boolean flag, when `true` log analytics request. Default is `false`. 
	internal static var shouldLogAnalyticsRequests = false

	/// Log sending analytics request.
	/// - Parameters:
	///   - request: `URLRequest` object, request to send.
	///   - payload: `VGSRequestPayloadBody` object, request payload.
	internal static func logAnalyticsRequest(_ request: URLRequest, payload: JsonData?) {

		if !shouldLogAnalyticsRequests {return}

		print("⬆️ Send VGSCheckout request url: \(stringFromURL(request.url))")
		if let headers = request.allHTTPHeaderFields {
			print("⬆️ Send VGSCheckout request headers:")
			print(normalizeRequestHeadersForLogs(headers))
		}
		if let payloadValue = payload {
			print("⬆️ Send VGSCheckout request payload:")
			print(stringifyRawRequestPayloadForLogs(payloadValue))
		}
		print("------------------------------------")
	}

	/// Log sending request.
	/// - Parameters:
	///   - request: `URLRequest` object, request to send.
	///   - payload: `VGSRequestPayloadBody` object, request payload.
	internal static func logRequest(_ request: URLRequest, payload: JsonData?) {

		if !VGSCheckoutLogger.shared.configuration.isNetworkDebugEnabled {return}

		print("⬆️ Send VGSCheckout request url: \(stringFromURL(request.url))")
		if let headers = request.allHTTPHeaderFields {
			print("⬆️ Send VGSCheckout request headers:")
			print(normalizeRequestHeadersForLogs(headers))
		}
		if let payloadValue = payload {
			print("⬆️ Send VGSCheckout request payload:")
			print(stringifyRawRequestPayloadForLogs(payloadValue))
		}
		print("------------------------------------")
	}

	/// Log failed request.
	/// - Parameters:
	///   - response: `URLResponse?` object.
	///   - data: `Data?` object of failed request.
	///   - error: `Error?` object, request error.
	///   - code: `Int` object, status code.
	internal static func logErrorResponse(_ response: URLResponse?, data: Data?, error: Error?, code: Int) {

		if !VGSCheckoutLogger.shared.configuration.isNetworkDebugEnabled {return}

		if let url = response?.url {
			print("❗Failed ⬇️ VGSCheckout request url: \(stringFromURL(url))")
		}
		print("❗Failed ⬇️ VGSCheckout response status code: \(code)")
		if let httpResponse = response as? HTTPURLResponse {
			print("❗Failed ⬇️ VGSCheckout response headers:")
			print(normalizeHeadersForLogs(httpResponse.allHeaderFields))
		}
		if let errorData = data {
			if let bodyErrorText = String(data: errorData, encoding: String.Encoding.utf8) {
				print("❗Failed ⬇️ VGSCheckout response extra info:")
				if bodyErrorText.count > maxTextCountToPrintLimit {
					print("VGSCheckout response size is too big to print. Use debugger if needed.")
				} else {
					print("\(bodyErrorText)")
				}
			}
		}

		// Track error.
		let errorMessage = (error as NSError?)?.localizedDescription ?? ""

		print("❗Failed ⬇️ VGSCheckout response error message: \(errorMessage)")
		print("------------------------------------")
	}

	/// Log success request.
	/// - Parameters:
	///   - response: `URLResponse?` object.
	///   - data: `Data?` object of success request.
	///   - code: `Int` object, status code.
	internal static func logSuccessResponse(_ response: URLResponse?, data: Data?, code: Int) {

		if !VGSCheckoutLogger.shared.configuration.isNetworkDebugEnabled {return}

		print("✅ Success ⬇️ VGSCheckout request url: \(stringFromURL(response?.url))")
		print("✅ Success ⬇️ VGSCheckout response code: \(code)")

		if let httpResponse = response as? HTTPURLResponse {
			print("✅ Success ⬇️ VGSCheckout response headers:")
			print(normalizeHeadersForLogs(httpResponse.allHeaderFields))
		}

    if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
        print("✅ Success ⬇️ VGSCheckout response JSON:")
        print(stringifyJSONForLogs(jsonData))
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

	/// Limit string characters value to print.
	private static var maxTextCountToPrintLimit: Int = 50000

	/// Stringify `JSON` for logging.
	/// - Parameter vgsJSON: `VGSJSONData` object.
	/// - Returns: `String` object, pretty printed `JSON`.
	private static func stringifyJSONForLogs(_ vgsJSON: JsonData) -> String {
		if let json = try? JSONSerialization.data(withJSONObject: vgsJSON, options: .prettyPrinted) {
			let stringToPrint = String(decoding: json, as: UTF8.self)
			if stringToPrint.count > maxTextCountToPrintLimit {
				return "VGSCheckout response size is too big to print. Use debugger if needed."
			} else {
				return stringToPrint
			}
		} else {
				return ""
		}
	}

	/// Stringify payload of `Any` type for logging.
	/// - Parameter payload: `Any` paylod.
	/// - Returns: `String` object, formatted stringified payload.
	private static func stringifyRawRequestPayloadForLogs(_ payload: Any) -> String {
		if let json = payload as? JsonData {
			return stringifyJSONForLogs(json)
		}

		return ""
	}
}
