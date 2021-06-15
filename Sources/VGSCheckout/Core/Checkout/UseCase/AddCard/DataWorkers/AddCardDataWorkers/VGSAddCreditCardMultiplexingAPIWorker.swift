//
//  VGSAddCreditCardMultiplexingAPIWorker.swift
//  VGSCheckout

import Foundation
import VGSCollectSDK

/// Holds logic for sending data to vault (non-multiplexing flow).
internal class VGSAddCreditCardMultiplexingAPIWorker: VGSAddCreditCardAPIWorkerProtocol {

	// MARK: - Vars

	/// Collect instance.
	internal let vgsCollect: VGSCollect

	/// Multiplexing configuration.
	internal let multiplexingConfiguration: VGSCheckoutMultiplexingConfiguration

	// MARK: - Initialization

	init(vgsCollect: VGSCollect, multiplexingConfiguration: VGSCheckoutMultiplexingConfiguration) {
		self.vgsCollect = vgsCollect
		self.multiplexingConfiguration = multiplexingConfiguration
	}

	// MARK: - VGSAddCreditCardAPIWorkerProtocol

	func sendData(with completion: @escaping VGSCheckoutRequestResultCompletion) {

		let extraMultiplexingData: [String: Any] = [
			"data": [
				"type": "financial_instruments",
				"attributes": [
					"instrument_type": "card"
				]
		]]

		let multiplexingPath = "/api/financial_instruments"

		vgsCollect.sendData(path: multiplexingPath, method: .post, extraData: extraMultiplexingData) { response in
			switch response {
			case .success(let code, let data, let response):
				let requestResult: VGSCheckoutRequestResult = .success(code, data, response)
				completion(requestResult)
			case .failure(let code, let data, let response, let error):
				let requestResult: VGSCheckoutRequestResult = .failure(code, data, response, error)
				completion(requestResult)
			}
		}
	}
}
