//
//  VGSSavedCardsAPIWorker.swift
//  VGSCheckoutSDK

import Foundation

/// Holds API logic for fetchings saved payment methods.
internal final class VGSSavedPaymentMethodsAPIWorker {

	internal typealias FetchSavedCardsCompletionSuccess = ( _ savedCards: [VGSSavedCardModel]) -> Void
	internal typealias FetchSavedCardsCompletionFailure = ( _ error: Error?) -> Void

	internal typealias FetchFinInstrumentCompletionSuccess = ( _ savedCard: VGSSavedCardModel) -> Void
	internal typealias FetchFinInstrumentCompletionFailure = ( _ error: Error?) -> Void


	init(vgsCollect: VGSCollect, accessToken: String) {
		self.vgsCollect = vgsCollect
		self.accessToken = accessToken
	}

	internal let vgsCollect: VGSCollect
	internal let accessToken: String

	internal func fetchSavedPaymentMethods(_ methods: VGSCheckoutSavedPaymentMethods, success: @escaping FetchSavedCardsCompletionSuccess, failure: @escaping FetchSavedCardsCompletionFailure) {
		switch methods {
		case .savedCards(var savedCardIds):
			let maxCount = VGSCheckoutPaymentConfiguration.maxSavedCardsCount
			if savedCardIds.count > maxCount {
				let event = VGSLogEvent(level: .warning, text: "Max saved cards limit to fetch is \(maxCount)! Current saved cards count is: \(savedCardIds.count)!", severityLevel: .warning)
				VGSCheckoutLogger.shared.forwardCriticalLogEvent(event)
				savedCardIds = Array(savedCardIds[0..<maxCount])
			}
      
			var fetchedSavedCards = [VGSSavedCardModel]()
      var failedCount = 0
			let dispatchGroup = DispatchGroup()
			for idx in 0..<savedCardIds.count {
					dispatchGroup.enter()
          fetchPaymentInstrument(with: savedCardIds[idx]) { savedCard in
            fetchedSavedCards.append(savedCard)
            dispatchGroup.leave()
          } failure: { error in
            failedCount += 1
            dispatchGroup.leave()
          }
			}

      let formDetails = vgsCollect.formAnalyticsDetails
			dispatchGroup.notify(queue: .main) {
        var extraData = [String: Any]()
        extraData["method"] = "LoadFinInstruments"
        extraData["statusCode"] = 200
        extraData["failedCount"] = failedCount
        extraData["totalCount"] = savedCardIds.count
        VGSCheckoutAnalyticsClient.shared.trackFormEvent(formDetails, type: .finInstrument, status: .success, extraData: extraData)
        
				// Reorder fetched by ids since it can be different depending on API request.
				fetchedSavedCards = fetchedSavedCards.reorderByIds(savedCardIds)
				success(fetchedSavedCards)
			}

		default:
			fatalError("not implemented")
		}
	}

	internal func fetchPaymentInstrument(with id: String, success: @escaping FetchFinInstrumentCompletionSuccess, failure: @escaping FetchFinInstrumentCompletionFailure) {

		let path = "financial_instruments/\(id)"

		vgsCollect.apiClient.customHeader = ["Authorization": "Bearer \(accessToken)"]

		vgsCollect.apiClient.sendRequest(path: path, method: .get, value: nil) { response in
			switch response {
			case .success(let code, let data, let response):
				guard let jsonData = data, let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any], let savedCard = VGSSavedCardModel(json: json) else {
					failure(nil)
					return
				 }

				print("Fetched order info success!")
				success(savedCard)
			case .failure(let code, let data, let response, let error):
				failure(nil)
			}
		}
	}
}
