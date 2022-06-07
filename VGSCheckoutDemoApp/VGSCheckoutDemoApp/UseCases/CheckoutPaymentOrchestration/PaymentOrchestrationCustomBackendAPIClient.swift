//
//  PaymentOrchestrationCustomBackendAPIClient.swift
//  VGSCheckoutDemoApp

import Foundation

// swiftlint:disable all

/// Your Custom API client for payment orchestration.
final class PaymentOrchestrationCustomBackendAPIClient {

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

	/// Success completion for create order request.
	typealias CreateOrderCompletionSuccess = (_ orderId: String) -> Void

	/// Fail completion for create order request.
	typealias CreateOrderCompletionFail = (_ errorMessage: String) -> Void

	// Use your own backend to fetch access_token token.
	fileprivate let yourCustomBackendTokenURL = URL(string:  DemoAppConfiguration.shared.paymentOrchestrationServicePath + "/get-auth-token")!

	/// Main url.
	private let mainURL = URL(string:  DemoAppConfiguration.shared.paymentOrchestrationServicePath)!

	/// Fetch payment orchestration token from your own backend.
	/// - Parameters:
	///   - success: `FetchTokenCompletionSuccess` object, completion on success request with token.
	///   - failure: `FetchTokenCompletionFail` object, completion on failed request with error message.
	func fetchToken(with success: @escaping FetchTokenCompletionSuccess, failure: @escaping FetchTokenCompletionFail) {

		var request = URLRequest(url: yourCustomBackendTokenURL)
		request.httpMethod = "POST"
		let task = URLSession.shared.dataTask(
			with: request,
			completionHandler: { (data, response, error) in
				guard let data = data,
							let json = try? JSONSerialization.jsonObject(with: data, options: [])
								as? [String: Any],
							let token = json["access_token"] as? String else {
								// Handle error
								DispatchQueue.main.async {
									DemoAppResponseParser.logErrorResponse(response, data: data, error: error)
									failure("Cannot fetch token")
								}
								return
							}

				let multipexingToken = token
				print("access_token: \(token)")
				DispatchQueue.main.async {
					success(multipexingToken)
				}
			})
		task.resume()
	}

	/// Financial instrument id from success payment orchestration save card response.
	/// - Parameter data: `Data?` object, response data.
	/// - Returns: `String?` object, financial instrument id or `nil`.
	func financialInstrumentID(from data: Data?) -> String? {
		if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
			if let dataJSON = jsonData["data"] as? [String: Any] {
				if let financialInstumentID = dataJSON["id"] as? String {
					return financialInstumentID
				}
			}
		}

		return nil
	}
	
	/// Creates order for payment orchestration with your custom backend.
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
				guard let orderJSON = json,
								let dataJSON = orderJSON["data"] as? [String: Any],
								let orderId = dataJSON["id"] as? String else {
					failure("Cannot create order: no order_id in response!")
					return
				}
				success(orderId)
			case .fail(let errorText):
				failure("Cannot create order: \(errorText)")
			}
		}
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

		let url = mainURL.appendingPathComponent(path)

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
