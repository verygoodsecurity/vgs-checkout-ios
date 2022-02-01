import Foundation

/// Holds logic for sending data to payopt.
internal class VGSSaveCardPayoptAddCardAPIWorker: VGSSaveCardAPIWorkerProtocol {

	// MARK: - Vars

	/// Collect instance.
	internal let vgsCollect: VGSCollect

	/// Configuration.
	internal let configuration: VGSCheckoutAddCardConfiguration

	// MARK: - Initialization

	/// Initializer.
	/// - Parameters:
	///   - vgsCollect: `VGSCollect` object, an instance of `VGSCollect`.
	///   - configuration: `VGSCheckoutAddCardConfiguration` object, payopt add card configuration.
	internal init(vgsCollect: VGSCollect, configuration: VGSCheckoutAddCardConfiguration) {
		self.vgsCollect = vgsCollect
		self.configuration = configuration
	}

	// MARK: - VGSAddCreditCardAPIWorkerProtocol

	/// Sends data.
	/// - Parameter completion: `VGSCheckoutRequestResultCompletion` object, completion block.
	internal func sendData(with completion: @escaping VGSCheckoutRequestResultCompletion) {

		vgsCollect.apiClient.customHeader = ["Authorization": "Bearer \(configuration.accessToken)"]

		let path = "/financial_instruments"

		vgsCollect.sendData(path: path, method: .post) { response in
			switch response {
			case .success(let code, let data, let response):
				let requestResult: VGSCheckoutRequestResult = .success(code, data, response, nil)
				completion(requestResult)
			case .failure(let code, let data, let response, let error):
				let requestResult: VGSCheckoutRequestResult = .failure(code, data, response, error, nil)
				completion(requestResult)
			}
		}
	}

	/// Saves card to create financial instrument.
	/// - Parameter completion: `VGSCheckoutRequestResultCompletion` object, completion block.
	internal func saveCard(with completion: @escaping VGSCheckoutRequestResultCompletion) {
		vgsCollect.apiClient.customHeader = ["Authorization": "Bearer \(configuration.accessToken)"]

		let path = "/financial_instruments"

		vgsCollect.sendData(path: path, method: .post) { response in
			switch response {
			case .success(let code, let data, let response):
				let requestResult: VGSCheckoutRequestResult = .success(code, data, response, nil)
				completion(requestResult)
			case .failure(let code, let data, let response, let error):
				let requestResult: VGSCheckoutRequestResult = .failure(code, data, response, error, nil)
				completion(requestResult)
			}
		}
	}

	/// Initiates transfer with fin instrument id and order.
	/// - Parameters:
	///   - finInstrumentId: `String` object, financial instrument id from payopt.
	///   - payment: `VGSCheckoutPayment`, payment data.
	///   - completion: `VGSCheckoutRequestResultCompletion` object, completion block.
//	internal func initiateTransfer(with finInstrumentId: String, payment: VGSCheckoutPayment, completion: @escaping VGSCheckoutRequestResultCompletion) {
//
//		// FIXME: - remove hardcoded order_id
//		let transderPayload: [String: Any] = [
//			"order_id" : "orderId",
//			"financial_instrument_id": finInstrumentId
//		]
//
//		let path = "/transfers"
//
//		vgsCollect.sendData(path: path, method: .post) { response in
//			switch response {
//			case .success(let code, let data, let response):
//				let requestResult: VGSCheckoutRequestResult = .success(code, data, response, nil)
//				completion(requestResult)
//			case .failure(let code, let data, let response, let error):
//				let requestResult: VGSCheckoutRequestResult = .failure(code, data, response, error, nil)
//				completion(requestResult)
//			}
//		}
//	}

	/// Financial instrument id from success payopt financial instrument response.
	/// - Parameter data: `Data?` object, response data.
	/// - Returns: `String?` object, financial instrument id or `nil`.
	private static func financialInstrumentID(from data: Data?) -> String? {
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
