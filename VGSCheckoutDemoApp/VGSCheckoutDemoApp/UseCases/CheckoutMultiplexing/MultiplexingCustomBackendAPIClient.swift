//
//  MultiplexingCustomBackendAPIClient.swift
//  VGSCheckoutDemoApp

import Foundation
import VGSCheckoutSDK

// swiftlint:disable all

/// Your Custom API client for multiplexing.
final class MultiplexingCustomBackendAPIClient {

	/// Defines API client request result.
	private enum APIRequestResult {

		/// Request success.
		case success(_ json: [String: Any]?, _ data: Data?)

		/// Request fail.
		case fail(_ errorText: String)
	}

	/// API request completion.
	private typealias APIRequestCompletion = (_ result: APIRequestResult) -> Void

	/// Succcess completion for token fetch.
	typealias FetchTokenCompletionSuccess = (_ token: String) -> Void

	/// Fail completion for token fetch.
	typealias FetchTokenCompletionFail = (_ errorMessage: String) -> Void

	/// Success completion for transfer request.
	typealias SendTransferCompletionSuccess = (_ responseText: String?) -> Void

	/// Fail completion for transfer request.
	typealias SendTransferCompletionFail = (_ errorMessage: String) -> Void

	/// Success completion for create order request.
	typealias CreateOrderCompletionSuccess = (_ orderId: String) -> Void

	/// Fail completion for create order request.
	typealias CreateOrderCompletionFail = (_ errorMessage: String) -> Void

	/// Main url.
	private let mailURL = URL(string:  DemoAppConfiguration.shared.multiplexingServicePath)!

	/// Fetch multiplexing token from your own backend.
	/// - Parameters:
	///   - success: `FetchTokenCompletionSuccess` object, completion on success request with token.
	///   - failure: `FetchTokenCompletionFail` object, completion on failed request with error message.
	func fetchMultiplexingToken(with success: @escaping FetchTokenCompletionSuccess, failure: @escaping FetchTokenCompletionFail) {

		sendRequest("/get-auth-token", payload: nil, httpMethod: "POST", headers: nil) { result in
			switch result {
			case .success(let json, _):
				guard let tokenJSON = json, let accessToken = tokenJSON["access_token"] as? String else {
					failure("Cannot find access_token JSON!")
					return
				}
				success(accessToken)
			case .fail(let errorText):
				failure("Cannot fetch accessToken: \(errorText)")
			}
		}
	}

	/// Initiates transfer request on multiplexing from your custom backend.
	/// - Parameters:
	///   - financialInstrumentID: `String` object, id of financial instrument.
	///   - amount: `String` object, amount of transaction.
	///   - currency: `String` object, currency of transaction.
	///   - success: `SendTransferCompletionSuccess` object, completion on success transfers.
	///   - failure: `SendTransferCompletionFail` object, completion on failed request with error message.
	func initiateTransfer(with financialInstrumentID: String, amount: String, currency: String, success: @escaping SendTransferCompletionSuccess, failure: @escaping FetchTokenCompletionFail) {

		let transderPayload: [String: Any] = [
			"tnt": DemoAppConfiguration.shared.multiplexingTenantId,
			"amount": amount,
			"currency": currency,
			"fi_id": financialInstrumentID
		]

		sendRequest("/transfers", payload: transderPayload, httpMethod: "POST", headers: nil) { result in
			switch result {
			case .success(_, let data):
				success(DemoAppResponseParser.stringifySuccessResponse(from: data, rootJsonKey: "data"))
			case .fail(let errorText):
				failure("Cannot send payment: \(errorText)")
			}
		}
	}

	/// Creates order on multiplexing with your custom backend.
	/// - Parameters:
	///   - amount: `String` object, amount of order.
	///   - currency: `String` object, currency of transaction.
	///   - success: `CreateOrderCompletionSuccess` object, completion on success create order.
	///   - failure: `CreateOrderCompletionFail` object, completion on failed create order with error message.
	func createOrder(with amount: String, currency: String, success: @escaping CreateOrderCompletionSuccess, failure: @escaping CreateOrderCompletionFail) {

		let orderPayload: [String: Any] = [
			"amount": amount,
			"currency": currency
		]

		sendRequest("/orders", payload: orderPayload, httpMethod: "POST", headers: nil) { result in
			switch result {
			case .success(let json, _):
				guard let orderJSON = json else {
					return
				}

				var orderId: String?
				if let dataJSON = orderJSON["data"] as? [String: Any] {
					if let id = dataJSON["id"] as? String {
						orderId = id
					}
				}

				guard let order_id = orderId else {
					failure("Cannot create order: order id was not found!")
					return
				}
				success(order_id)
			case .fail(let errorText):
				failure("Cannot create order: \(errorText)")
			}
		}
	}

	/// Financial instrument id from success multiplexing save card response.
	/// - Parameter data: `Data?` object, response data.
	/// - Returns: `String?` object, multiplexing financial instrument id or `nil`.
	func multiplexingFinancialInstrumentID(from data: Data?) -> String? {
		if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
				if let dataJSON = jsonData["data"] as? [String: Any] {
					if let financialInstumentID = dataJSON["id"] as? String {
						return financialInstumentID
					}
				}
		}

		return nil
	}

	// MARK: - Private

	/// Sends API request.
	/// - Parameters:
	///   - path: `String` object, path to send data.
	///   - payload: `[String: Any]?` object, payload, should be valid JSON.
	///   - httpMethod: `String` object, should be valid HTTP Method.
	///   - headers: `[String : String]?` object, headers, default is `nil`.
	///   - completion: `APIRequestCompletion` object, api request completion.
	private func sendRequest(_ path: String, payload: [String: Any]?, httpMethod: String, headers: [String: String]? = nil, completion: @escaping (APIRequestCompletion)) {

		let url = mailURL.appendingPathComponent(path)

		var request = URLRequest(url: url)
		request.httpMethod = httpMethod

		var requestHeaders: [String:String] = [:]
		requestHeaders["Content-Type"] = "application/json"

		if let customerHeaders = headers, customerHeaders.count > 0 {
			customerHeaders.keys.forEach({ (key) in
				requestHeaders[key] = customerHeaders[key]
			})
		}

		request.allHTTPHeaderFields = requestHeaders

		if let bodyPayload = payload {
			request.httpBody = try? JSONSerialization.data(withJSONObject: bodyPayload)
			DemoAppResponseParser.logRequest(request, payload: bodyPayload)
		}

		let task = URLSession.shared.dataTask(
				with: request,
				completionHandler: {(data, response, error) in

					let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 1000

					switch statusCode {
					case 200..<300:
						DemoAppResponseParser.logSuccessResponse(response, data: data, code: statusCode)
					default:
						break
					}

					guard let data = data,
								let json = try? JSONSerialization.jsonObject(with: data, options: [])
										as? [String: Any] else {
								// Handle error
							DispatchQueue.main.async {
								DemoAppResponseParser.logErrorResponse(response, data: data, error: error)
								completion(APIRequestResult
									.fail("Cannot parse response"))
							}
							return
						}
					print("response json: \(json)")

					DispatchQueue.main.async {
						completion(APIRequestResult
							.success(json, data))
					}
				})
		task.resume()
	}
}

// swiftlint:enable all
