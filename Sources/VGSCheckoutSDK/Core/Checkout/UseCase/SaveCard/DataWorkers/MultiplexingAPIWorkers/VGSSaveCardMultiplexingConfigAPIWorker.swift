import Foundation

/// Holds logic for sending data to multiplexing.
internal class VGSSaveCardMultiplexingConfigAPIWorker: VGSSaveCardAPIWorkerProtocol {

	// MARK: - Vars

	/// Collect instance.
	internal let vgsCollect: VGSCollect

	/// Multiplexing configuration.
	internal let multiplexingConfiguration: VGSCheckoutMultiplexingAddCardConfiguration

	// MARK: - Initialization

	/// Initializer.
	/// - Parameters:
	///   - vgsCollect: `VGSCollect` object, an instance of `VGSCollect`.
	///   - multiplexingConfiguration: `VGSCheckoutMultiplexingConfiguration` object, multiplexingConfiguration.
	internal init(vgsCollect: VGSCollect, multiplexingConfiguration: VGSCheckoutMultiplexingAddCardConfiguration) {
		self.vgsCollect = vgsCollect
		self.multiplexingConfiguration = multiplexingConfiguration
	}

	// MARK: - VGSAddCreditCardAPIWorkerProtocol

	/// Sends data.
	/// - Parameter completion: `VGSCheckoutRequestResultCompletion` object, completion block.
	internal func sendData(with completion: @escaping VGSCheckoutRequestResultCompletion) {

//		let paymentFlowType = multiplexingConfiguration.multiplexingFlowType
//		switch paymentFlowType {
//		case .saveCard:
//			saveCard(with: completion)
//		case .payment(let paymentFlow):
//			saveCard { [weak self] requestResult in
//				guard let strongSelf = self else {return}
//				switch requestResult {
//				case .success(let code, let data, let response, _):
//					if let id = VGSSaveCardMultiplexingConfigAPIWorker.multiplexingFinancialInstrumentID(from: data) {
////						strongSelf.initiateTransfer(with: id, payment: paymentFlow.payment, completion: completion)
//					} else {
//						let paymentFlowResult = VGSCheckoutPaymentFlowExtraData.saveCardFail
//						let requestResult: VGSCheckoutRequestResult = .failure(code, data, response, nil, paymentFlowResult)
//						completion(requestResult)
//					}
//				case .failure(let code, let data, let response, let error, _):
//					let paymentFlowResult = VGSCheckoutPaymentFlowExtraData.saveCardFail
//					let requestResult: VGSCheckoutRequestResult = .failure(code, data, response, error, paymentFlowResult)
//					completion(requestResult)
//				}
//			}
//		}

		vgsCollect.apiClient.customHeader = ["Authorization": "Bearer \(multiplexingConfiguration.accessToken)"]

		let multiplexingPath = "/financial_instruments"

		vgsCollect.sendData(path: multiplexingPath, method: .post) { response in
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
		vgsCollect.apiClient.customHeader = ["Authorization": "Bearer \(multiplexingConfiguration.accessToken)"]

		let multiplexingPath = "/financial_instruments"

		vgsCollect.sendData(path: multiplexingPath, method: .post) { response in
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
	///   - finInstrumentId: `String` object, financial instrument id from multipleximg.
	///   - payment: `VGSCheckoutMultiplexingPayment`, payment data.
	///   - completion: `VGSCheckoutRequestResultCompletion` object, completion block.
//	internal func initiateTransfer(with finInstrumentId: String, payment: VGSCheckoutMultiplexingPayment, completion: @escaping VGSCheckoutRequestResultCompletion) {
//
//		// FIXME: - remove hardcoded order_id
//		let transderPayload: [String: Any] = [
//			"order_id" : "orderId",
//			"financial_instrument_id": finInstrumentId
//		]
//
//		let multiplexingPath = "/transfers"
//
//		vgsCollect.sendData(path: multiplexingPath, method: .post) { response in
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

	/// Financial instrument id from success multiplexing financial instrument response.
	/// - Parameter data: `Data?` object, response data.
	/// - Returns: `String?` object, multiplexing financial instrument id or `nil`.
	private static func multiplexingFinancialInstrumentID(from data: Data?) -> String? {
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
