//
//  VGSAddCreditCardPaymentOrchestrationAPIWorker.swift
//  VGSCheckoutSDK

import Foundation

/// Holds logic for sending data to payment orchestration flow.
internal class VGSAddCreditCardPaymentOrchestrationAPIWorker: VGSAddCreditCardAPIWorkerProtocol {

	// MARK: - Vars

	/// Collect instance.
	internal let vgsCollect: VGSCollect

	/// Configuration.
	internal let paymentOrchestrationConfiguration: VGSCheckoutAddCardConfiguration

	// MARK: - Initialization

	init(vgsCollect: VGSCollect, paymentOrchestrationConfiguration: VGSCheckoutAddCardConfiguration) {
		self.vgsCollect = vgsCollect
		self.paymentOrchestrationConfiguration = paymentOrchestrationConfiguration
	}

	// MARK: - VGSAddCreditCardAPIWorkerProtocol

	func sendData(with completion: @escaping VGSCheckoutRequestResultCompletion) {

		vgsCollect.apiClient.customHeader = ["Authorization": "Bearer \(paymentOrchestrationConfiguration.accessToken)"]

		let paymentOrchestration = "/financial_instruments"

		vgsCollect.sendData(path: paymentOrchestration, method: .post) { response in
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
