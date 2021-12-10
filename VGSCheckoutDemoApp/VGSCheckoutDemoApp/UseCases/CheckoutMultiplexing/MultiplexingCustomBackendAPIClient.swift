//
//  MultiplexingCustomBackendAPIClient.swift
//  VGSCheckoutDemoApp

import Foundation

/// Your Custom API client for multiplexing.
final class MultiplexingCustomBackendAPIClient {

	/// Succcess completion for token fetch.
	typealias FetchTokenCompletionSuccess = (_ token: String) -> Void

	/// Fail completion for token fetch.
	typealias FetchTokenCompletionFail = (_ errorMessage: String) -> Void

	/// Success completion for transfer request.
	typealias SendTransferCompletionSuccess = (_ responseText: String?) -> Void

	/// Fail completion for transfer request.
	typealias SendTransferCompletionFail = (_ errorMessage: String) -> Void

	// Use your own backend to fetch access_token token.
	fileprivate let yourCustomBackendTokenURL = URL(string:  DemoAppConfiguration.shared.multiplexingServicePath + "/get-auth-token")!

	// Use your own backend to send payment to multiplexing.
	fileprivate let yourCustomBackendSendPaymentURL = URL(string:  DemoAppConfiguration.shared.multiplexingServicePath + "/transfers")!

	/// Fetch multiplexing token from your own backend.
	/// - Parameters:
	///   - success: `FetchTokenCompletionSuccess` object, completion on success request with token.
	///   - failure: `FetchTokenCompletionFail` object, completion on failed request with error message.
	func fetchMultiplexingToken(with success: @escaping FetchTokenCompletionSuccess, failure: @escaping FetchTokenCompletionFail) {

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

	/// Initiate transfer request on multiplexing from your custom backend.
	/// - Parameters:
	///   - financialInstrumentID: `String` object, id of financial instrument.
	///   - amount: `String` object, amount of transaction.
	///   - currency: `String` object, currency of transaction.
	///   - success: `SendTransferCompletionSuccess` object, completion on success transfers.
	///   - failure: `SendTransferCompletionFail` object, completion on failed request with error message.
	func initiateTransfer(with financialInstrumentID: String, amount: String, currency: String, success: @escaping SendTransferCompletionSuccess, failure: @escaping FetchTokenCompletionFail) {

		var request = URLRequest(url: yourCustomBackendSendPaymentURL)
		request.httpMethod = "POST"

		let transderPayload: [String: Any] = [
			"tnt": DemoAppConfiguration.shared.multiplexingTenantId,
			"amount": amount,
			"currency": currency,
			"fi_id": financialInstrumentID
		]

		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = try? JSONSerialization.data(withJSONObject: transderPayload)
		DemoAppResponseParser.logRequest(request, payload: transderPayload)

		let task = URLSession.shared.dataTask(
				with: request,
				completionHandler: {(data, response, error) in
						guard let data = data,
								let json = try? JSONSerialization.jsonObject(with: data, options: [])
										as? [String: Any] else {
								// Handle error
							DispatchQueue.main.async {
								DemoAppResponseParser.logErrorResponse(response, data: data, error: error)
								failure("Cannot send payment")
							}
							return
						}
					print("response json: \(json)")

					DispatchQueue.main.async {
						success(DemoAppResponseParser.stringifySuccessResponse(from: data, rootJsonKey: "data"))
					}
				})
		task.resume()
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
}
