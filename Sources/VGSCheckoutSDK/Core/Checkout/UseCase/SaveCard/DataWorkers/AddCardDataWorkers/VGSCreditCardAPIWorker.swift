//
//  VGSAddCreditCardAPIWorker.swift
//  VGSCheckoutSDK

import Foundation

/// Request result completion.
internal typealias VGSCheckoutRequestResultCompletion = (VGSCheckoutRequestResult) -> Void

/// Interface to send data.
internal protocol VGSSaveCardAPIWorkerProtocol {
	func sendData(with completion: @escaping VGSCheckoutRequestResultCompletion)
}

/// Holds logic for sending data to vault (non-multiplexing flow).
internal class VGSSaveCardCustomConfigAPIWorker: VGSSaveCardAPIWorkerProtocol {

	// MARK: - Vars

	/// Collect instance.
	internal let vgsCollect: VGSCollect

	/// Custom vault configuration.
	internal let vaultConfiguration: VGSCheckoutCustomConfiguration

	// MARK: - Initialization

	init(vgsCollect: VGSCollect, vaultConfiguration: VGSCheckoutCustomConfiguration) {
		self.vgsCollect = vgsCollect
		self.vaultConfiguration = vaultConfiguration
	}

	// MARK: - VGSAddCreditCardAPIWorkerProtocol

	func sendData(with completion: @escaping VGSCheckoutRequestResultCompletion) {
		let routeConfiguration = vaultConfiguration.routeConfiguration
		let requestOptions = routeConfiguration.requestOptions

		let path = routeConfiguration.path

		let httpMethod = HTTPMethod(checkoutHTTPMethod: requestOptions.method)
		let customHeaders = requestOptions.customHeaders

		vgsCollect.customHeaders = customHeaders
		let extraData = requestOptions.extraData

		let mergePolicy = requestOptions.mergePolicy

		var collectRequestOptions = VGSCollectRequestOptions()
		collectRequestOptions.fieldNameMappingPolicy = VGSCollectFieldNameMappingPolicy(mappingPolicy: mergePolicy)

		vgsCollect.sendData(path: path, method: httpMethod, extraData: extraData, requestOptions: collectRequestOptions) { response in
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
}
