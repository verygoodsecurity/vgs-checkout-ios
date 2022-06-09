//
//  VGSPayoptTransfersOrderAPIWorker.swift
//  VGSCheckoutSDK

import Foundation

/// Holds payment info about order for payopt transfers flow.
internal struct VGSPayoptTransfersOrderInfo {
	
	/// Payment amount in decinals.
	let amount: Int64

	/// Curency.
	let currency: String

	init?(json: JsonData) {
		guard let amount = json["amount"] as? Int64, let currency = json["currency"] as? String else {
			return nil
		}
		self.amount = amount
		self.currency = currency
	}

	init(amount: Int64, currency: String) {
		self.amount = amount
		self.currency = currency
	}
}

/// Holds logic for fetching order info.
internal class VGSPayoptTransfersOrderAPIWorker {

	typealias FetchOrderInfoCompletionSuccess = (_ paymentInfo: VGSPayoptTransfersOrderInfo) -> Void
	typealias FetchOrderInfoCompletionFail = (_ error: Error) -> Void

	/// VGSCollect.
	private let vgsCollect: VGSCollect

	/// Access token.
	private let accessToken: String

	internal init(vgsCollect: VGSCollect, accessToken: String) {
		self.vgsCollect = vgsCollect
		self.accessToken = accessToken
	}

	/// Fetches order info for payopt transfers configuration.
	/// - Parameters:
	///   - orderId: `String` object, order id.
	///   - success: `FetchOrderInfoCompletionSuccess` object, success completion.
	///   - failure: `FetchOrderInfoCompletionFail` object, fail completion.
	internal func fetchPaymentConfiguration(for orderId: String, success: @escaping FetchOrderInfoCompletionSuccess, failure: @escaping FetchOrderInfoCompletionFail) {

//		let mockedPaymentInfo = VGSPayoptTransfersOrderInfo(amount: 5300, currency: "USD")
//		success(mockedPaymentInfo)
//		return
//		return

		vgsCollect.apiClient.customHeader = ["Authorization": "Bearer \(accessToken)"]

		let path = "orders/\(orderId)"

		vgsCollect.apiClient.sendRequest(path: path, method: .get, value: nil) { response in
			switch response {
			case .success(let code, let data, let response):
				guard let jsonData = data, let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any], let dataJSON = json["data"] as? [String: Any], let paymentInfo = VGSPayoptTransfersOrderInfo(json: dataJSON) else {
					let fetchOrderError = NSError(domain: VGSCheckoutErrorDomain, code: VGSErrorType.orderInfoNotFound.rawValue, userInfo: [
						NSLocalizedDescriptionKey: "Cannot fetch order info from id: \(orderId)",
						"statusCode": code
					])
					failure(fetchOrderError as Error)
					return
				 }

				print("Fetched order info success!")
				success(paymentInfo)
			case .failure(let code, let data, let response, let error):
				break
				// TODO: - add cannot fetch order info error code.
				let fetchOrderError = NSError(domain: VGSCheckoutErrorDomain, code: VGSErrorType.orderInfoNotFound.rawValue, userInfo: [
					NSLocalizedDescriptionKey: "Cannot fetch order info from id: \(orderId)",
					"statusCode": code,
					"extraError": error
				])

				failure(fetchOrderError as Error)
			}
		}
	}
}
