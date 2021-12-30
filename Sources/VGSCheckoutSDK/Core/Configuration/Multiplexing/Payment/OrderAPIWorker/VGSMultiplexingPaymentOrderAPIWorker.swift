//
//  VGSMultiplexingPaymentOrderAPIWorker.swift
//  VGSCheckoutSDK

import Foundation

/// Holds payment info.
internal struct VGSMultiplexingPaymentInfo {
	
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
internal class VGSMultiplexingPaymentOrderAPIWorker {

	typealias FetchOrderInfoCompletionSuccess = (_ paymentInfo: VGSMultiplexingPaymentInfo) -> Void
	typealias FetchOrderInfoCompletionFail = (_ error: Error) -> Void

	/// VGSCollect.
	private let vgsCollect: VGSCollect

	/// Access token.
	private let accessToken: String

	internal init(vgsCollect: VGSCollect, accessToken: String) {
		self.vgsCollect = vgsCollect
		self.accessToken = accessToken
	}

	/// Fetches order info for multiplexing payment configuration.
	/// - Parameters:
	///   - orderId: `String` object, order id.
	///   - success: `FetchOrderInfoCompletionSuccess` object, success completion.
	///   - failure: `FetchOrderInfoCompletionFail` object, fail completion.
	internal func fetchPaymentConfiguration(for orderId: String, success: @escaping FetchOrderInfoCompletionSuccess, failure: @escaping FetchOrderInfoCompletionFail) {

		let mockedPaymentInfo = VGSMultiplexingPaymentInfo(amount: 5300, currency: "USD")
		success(mockedPaymentInfo)
		return

//		vgsCollect.apiClient.customHeader = ["Authorization": "Bearer \(accessToken)"]
//
//		let multiplexingPath = "orders/\(orderId)"
//
//		vgsCollect.sendData(path: multiplexingPath, method: .post) { response in
//			switch response {
//			case .success(let code, let data, let response):
//				guard let jsonData = data, let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any], let dataJSON = json["data"] as? [String: Any], let paymentInfo = VGSMultiplexingPaymentInfo(json: dataJSON) else {
//					let fetchOrderError = NSError(domain: VGSCheckoutErrorDomain, code: 1476, userInfo: [
//						NSLocalizedDescriptionKey: "Cannot fetch order id info",
//						"statusCode": code
//					])
//					failure(fetchOrderError as Error)
//					return
//				 }
//
//				print("Fetched order info success!")
//				success(paymentInfo)
//			case .failure(let code, let data, let response, let error):
//				// TODO: - add cannot fetch order info error code.
//				let fetchOrderError = NSError(domain: VGSCheckoutErrorDomain, code: 1476, userInfo: [
//					NSLocalizedDescriptionKey: "Cannot fetch order id info",
//					"statusCode": code,
//					"extraError": error
//				])
//
//				failure(fetchOrderError as Error)
//			}
//		}
	}
}


