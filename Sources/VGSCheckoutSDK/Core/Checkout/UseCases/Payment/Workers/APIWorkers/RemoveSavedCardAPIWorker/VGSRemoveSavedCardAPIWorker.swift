//
//  VGSRemoveSavedCardAPIWorker.swift
//  VGSCheckoutSDK

import Foundation

/// Remove saved card completion success.
internal typealias VGSRemoveSavedCardSuccessCompletion = (_ finID: String) -> Void

/// Remove saved card completion fail.
internal typealias VGSRemoveSavedCardFailCompletion = (_ finID: String, _ error: Error?) -> Void

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

	/// Path to remove card.
	internal let path: String = "/"

	// MARK: - Initialization

	/// Initialization.
	/// - Parameter vgsCollect: `VGSCollect` object, vgs collect instance.
	init(vgsCollect: VGSCollect) {
		self.vgsCollect = vgsCollect
	}

	// MARK: - VGSRemoveSavedCardAPIWorkerProtocol

	/// Remove saved card with fin id.
	/// - Parameters:
	///   - finId: `String` object, saved card fin id.
	///   - success: `VGSRemoveSavedCardSuccessCompletion` object, success completion on remove card.
	///   - failure: `VGSRemoveSavedCardFailCompletion` object, failure completion on remove card.
	func removeSavedCard(with finId: String, success: @escaping VGSRemoveSavedCardSuccessCompletion, failure: @escaping VGSRemoveSavedCardFailCompletion) {

		// Mock async success remove card.
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			success(finId)
		}

		// Mock async failure remove card.
//		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//			failure(finId, nil)
//		}

//		vgsCollect.apiClient.sendRequest(path: path, method: .post, value: nil) { response in
//			switch response {
//			case .success(let code, let data, let response):
//				success(finId)
//			case .failure(let code, let data, let response, let error):
//				failure(finId, error)
//			}
//		}
	}
}
