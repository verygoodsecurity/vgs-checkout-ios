//
//  VGSAddCreditCardAPIWorker.swift
//  VGSCheckout

import Foundation
import VGSCollectSDK

/// Request result completion.
internal typealias VGSCheckoutRequestResultCompletion = (VGSCheckoutRequestResult) -> Void

/// Interface to send data.
internal protocol VGSAddCreditCardAPIWorkerProtocol {
	func sendData(with completion: @escaping VGSCheckoutRequestResultCompletion)
}

/// Holds logic for sending data to vault (non-multiplexing flow).
internal class VGSAddCreditCardVaultAPIWorker: VGSAddCreditCardAPIWorkerProtocol {

	// MARK: - Vars

	/// Collect instance.
	internal let vgsCollect: VGSCollect

	/// Custom vault configuration.
	internal let vaultConfiguration: VGSCheckoutConfiguration

	// MARK: - Initialization

	init(vgsCollect: VGSCollect, vaultConfiguration: VGSCheckoutConfiguration) {
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
		let extraData = requestOptions.extraData

		let mergePolicy = requestOptions.mergePolicy

		var collectRequestOptions = VGSCollectRequestOptions()
		collectRequestOptions.fieldNameMappingPolicy = VGSCollectFieldNameMappingPolicy(mappingPolicy: mergePolicy)

		vgsCollect.sendData(path: path, method: httpMethod, extraData: extraData, requestOptions: collectRequestOptions) { response in
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

internal extension VGSCollectFieldNameMappingPolicy {
	init(mappingPolicy: VGSCheckoutDataMergePolicy) {
		switch mappingPolicy {
		case .flat:
			self = .flatJSON
		case .nestedJSON:
			self = .nestedJSON
		case .nestedWithArrayMerge:
			self = .nestedJSONWithArrayMerge
		case .nestedWithArrayOverwrite:
			self = .nestedJSONWithArrayOverwrite
		}
	}
}

internal extension HTTPMethod {
	init(checkoutHTTPMethod: VGSCheckoutHTTPMethod) {
		switch checkoutHTTPMethod {
		case .post:
			self = .post
		case .put:
			self = .put
		case .patch:
			self = .patch
		case .delete:
			self = .delete
		case .get:
			self = .get
		}
	}
}
