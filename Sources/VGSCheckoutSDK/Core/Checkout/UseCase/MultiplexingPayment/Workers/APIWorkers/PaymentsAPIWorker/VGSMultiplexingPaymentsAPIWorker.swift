//
//  VGSMultiplexingPaymentsAPIWorker.swift
//  VGSCheckoutSDK

import Foundation
import UIKit

/// Multiplexing payment API Worker.
internal final class VGSMultiplexingPaymentsAPIWorker {

	/// VGS Collect object.
	private let vgsCollect: VGSCollect

	/// Configuration.
	private let multiplexingConfiguration: VGSCheckoutMultiplexingPaymentConfiguration

	init(multiplexingConfiguration: VGSCheckoutMultiplexingPaymentConfiguration, vgsCollect: VGSCollect) {
		self.multiplexingConfiguration = multiplexingConfiguration
		self.vgsCollect = vgsCollect
	}

	internal func createFinIDAndSendTransfer(with completion: @escaping VGSCheckoutRequestResultCompletion) {
		vgsCollect.apiClient.customHeader = ["Authorization": "Bearer \(multiplexingConfiguration.accessToken)"]

		let multiplexingPath = "/financial_instruments"

		vgsCollect.sendData(path: multiplexingPath, method: .post) {[weak self] response in
			guard let strongSelf = self else {return}
			switch response {
			case .success(let code, let data, let response):
				guard let id = VGSMultiplexingPaymentsAPIWorker.multiplexingFinancialInstrumentID(from: data) else {
					let error = NSError(domain: VGSCheckoutErrorDomain, code: VGSErrorType.finIdNotFound.rawValue, userInfo: [NSLocalizedDescriptionKey: "Request to multiplexing succeed, cannot find fin id in response"])
					let requestResult: VGSCheckoutRequestResult = .failure(code, data, response, error, nil)
					completion(requestResult)
					return
				}

				strongSelf.sendTransfer(with: id, completion: completion)
			case .failure(let code, let data, let response, let error):
				let requestResult: VGSCheckoutRequestResult = .failure(code, data, response, error, nil)
				completion(requestResult)
			}
		}
	}

	internal func sendTransfer(with finId: String, completion: @escaping VGSCheckoutRequestResultCompletion) {
		let transderPayload: [String: Any] = [
			"order_id": multiplexingConfiguration.orderId,
			"financial_instrument_id": finId
		]

		let multiplexingPath = "/transfers"

		// Use API client sendRequest since we don't need to send collected data again.
		vgsCollect.apiClient.sendRequest(path: multiplexingPath, method: .post, value: transderPayload) { response in
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
