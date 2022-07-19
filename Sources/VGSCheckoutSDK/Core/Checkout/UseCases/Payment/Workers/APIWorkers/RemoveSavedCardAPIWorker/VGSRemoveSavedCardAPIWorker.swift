//
//  VGSRemoveSavedCardAPIWorker.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Remove saved card completion success.
internal typealias VGSRemoveSavedCardSuccessCompletion = (_ finID: String, _ result: VGSCheckoutRequestResult) -> Void

/// Remove saved card completion fail.
internal typealias VGSRemoveSavedCardFailCompletion = (_ finID: String, _ result: VGSCheckoutRequestResult) -> Void

/// Interface to remove saved card.
internal protocol VGSRemoveSavedCardAPIWorkerProtocol {

	/// Remove saved card with fin id.
	/// - Parameters:
	///   - finId: `String` object, saved card fin id.
	///   - success: `VGSRemoveSavedCardSuccessCompletion` object, success completion on remove card.
	///   - failure: `VGSRemoveSavedCardFailCompletion` object, failure completion on remove card.
	func removeSavedCard(with finId: String, success: @escaping VGSRemoveSavedCardSuccessCompletion, failure: @escaping VGSRemoveSavedCardFailCompletion)
}

/// API worker for removing saved card.
internal class VGSRemoveSavedCardAPIWorker: VGSRemoveSavedCardAPIWorkerProtocol {

	// MARK: - Vars

	/// VGSCollect instance.
	internal let vgsCollect: VGSCollect

	/// Configuration.
	internal let configuration: VGSCheckoutPayoptBasicConfiguration

	/// Path to remove card.
	internal let path: String = "/financial_instruments/"

	// MARK: - Initialization

	/// Initialization.
	/// - Parameter vgsCollect: `VGSCollect` object, vgs collect instance.
	/// - Parameter configuration: `VGSCheckoutPayoptBasicConfiguration` object, pay opt configuration instance.
	init(vgsCollect: VGSCollect, configuration: VGSCheckoutPayoptBasicConfiguration) {
		self.vgsCollect = vgsCollect
		self.configuration = configuration
	}

	// MARK: - VGSRemoveSavedCardAPIWorkerProtocol

	/// Remove saved card with fin id.
	/// - Parameters:
	///   - finId: `String` object, saved card fin id.
	///   - success: `VGSRemoveSavedCardSuccessCompletion` object, success completion on remove card.
	///   - failure: `VGSRemoveSavedCardFailCompletion` object, failure completion on remove card.
	func removeSavedCard(with finId: String, success: @escaping VGSRemoveSavedCardSuccessCompletion, failure: @escaping VGSRemoveSavedCardFailCompletion) {

		if UIApplication.isRunningUITest && UIApplication.shouldTriggerSuccessRemoveSavedCard {
			// Mock async success remove card.
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				success(finId, VGSCheckoutRequestResult.success(200, nil, nil, nil))
			}
			return
		}

		// Mock async failure remove card.
//		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//			failure(finId, nil)
//		}

		let requestPath = path + finId
    let formAnalyticsDetails = vgsCollect.formAnalyticsDetails

		vgsCollect.apiClient.customHeader = ["Authorization": "Bearer \(configuration.accessToken)"]
		vgsCollect.apiClient.sendRequest(path: requestPath, method: .delete, value: nil) { response in
      var extraData: [String: Any] = [:]
			extraData["config"] = "payopt"
			extraData["configType"] = "addCard"
      extraData["method"] = "DeleteFinInstrument"

			switch response {
			case .success(let code, let data, let response):
        extraData["statusCode"] = code
        VGSCheckoutAnalyticsClient.shared.trackFormEvent(formAnalyticsDetails, type: .finInstrument, status: .success, extraData: extraData)
				success(finId, VGSCheckoutRequestResult.success(code, data, response, nil))
			case .failure(let code, let data, let response, let error):
        let errorMessage =  (error as NSError?)?.localizedDescription ?? ""
        extraData["statusCode"] = code
        extraData["error"] = errorMessage
        VGSCheckoutAnalyticsClient.shared.trackFormEvent(formAnalyticsDetails, type: .finInstrument, status: .failed, extraData: extraData)
				failure(finId, VGSCheckoutRequestResult.failure(code, data, response, error, nil))
			}
		}
	}
}
