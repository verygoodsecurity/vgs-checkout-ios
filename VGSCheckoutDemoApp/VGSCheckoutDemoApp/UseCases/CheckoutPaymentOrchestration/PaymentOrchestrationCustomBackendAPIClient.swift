//
//  PaymentOrchestrationCustomBackendAPIClient.swift
//  VGSCheckoutDemoApp

import Foundation

/// Your Custom API client for payment orchestration.
final class PaymentOrchestrationCustomBackendAPIClient {

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
				guard let orderJSON = json, let orderId = orderJSON["order_id"] as? String else {
					failure("Cannot create order: no order_id in response!")
					return
				}
				success(orderId)
			case .fail(let errorText):
				failure("Cannot create order: \(errorText)")
			}
		}
	}
}
