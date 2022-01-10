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
	internal let paymentOrchestrationConfiguration:  VGSCheckoutAddCardConfiguration

	// MARK: - Initialization

	init(vgsCollect: VGSCollect, multiplexingConfiguration:  VGSCheckoutAddCardConfiguration) {
		self.vgsCollect = vgsCollect
		self.paymentOrchestrationConfiguration = multiplexingConfiguration
	}

	// MARK: - VGSAddCreditCardAPIWorkerProtocol

	func sendData(with completion: @escaping VGSCheckoutRequestResultCompletion) {

		vgsCollect.apiClient.customHeader = ["Authorization": "Bearer \(paymentOrchestrationConfiguration.accessToken)"]

		let multiplexingPath = "/financial_instruments"

		vgsCollect.sendData(path: multiplexingPath, method: .post) { response in
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
