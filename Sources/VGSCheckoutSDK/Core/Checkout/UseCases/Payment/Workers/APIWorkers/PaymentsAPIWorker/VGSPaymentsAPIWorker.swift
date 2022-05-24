//
//  VGSPayoptTransfersAPIWorker.swift
//  VGSCheckoutSDK

import Foundation

/// Additional Payment Flow info.
public struct VGSCheckoutPaymentResultInfo: VGSCheckoutInfo {

	/// Payment method choosen by user.
	public let paymentMethod: VGSCheckoutPaymentMethod
}

/// Payopt transfers api Worker.
internal final class VGSPayoptAddCardAPIWorker {

	/// VGS Collect object.
	private let vgsCollect: VGSCollect

	/// Configuration.
	private let configuration: VGSCheckoutPayoptBasicConfiguration

  /// Financial instruments path.
  private let finInstrumentsPath = "/financial_instruments"

  /// Transfers path.
  private let transfersPath = "/transfers"

	/// Checkout service.
	private weak var checkoutService: VGSCheckoutBasicPayoptServiceProtocol?

	init(configuration: VGSCheckoutPayoptBasicConfiguration, vgsCollect: VGSCollect, checkoutService: VGSCheckoutBasicPayoptServiceProtocol) {

		self.configuration = configuration
		self.vgsCollect = vgsCollect
		self.checkoutService = checkoutService
		vgsCollect.apiClient.customHeader = ["Authorization": "Bearer \(configuration.accessToken)"]
	}

	internal func createFinID(with newCardInfo: VGSCheckoutNewPaymentCardInfo, completion: @escaping VGSCheckoutRequestResultCompletion) {

		vgsCollect.sendData(path: finInstrumentsPath, method: .post) {[weak self] response in
			guard let strongSelf = self else {return}
      
      var extraData = [String: Any]()
			extraData["config"] = "payopt"
			extraData["configType"] = "addCard"
      extraData["method"] = "CreateFinInstrument"
      
			switch response {
			case .success(let code, let data, let response):
        extraData["statusCode"] = code
        VGSCheckoutAnalyticsClient.shared.trackFormEvent(strongSelf.vgsCollect.formAnalyticsDetails, type: .finInstrument, status: .success, extraData: extraData)


				switch strongSelf.configuration.payoptFlow {
				case .addCard:
					/// Notifies delegate with checkout did finish request result success event.
					if let service = strongSelf.checkoutService {
						service.serviceDelegate?.checkoutServiceStateDidChange(with: .checkoutDidFinish(.newCard(.success(code, data, response, nil), newCardInfo)), in: service)
					}
				case .transfers:
					break
					//				guard let id = VGSPayoptTransfersAPIWorker.financialInstrumentID(from: data) else {
					//					let error = NSError(domain: VGSCheckoutErrorDomain, code: VGSErrorType.finIdNotFound.rawValue, userInfo: [NSLocalizedDescriptionKey: "Request to payopt service succeed, cannot find fin_id in response"])
					//					let requestResult: VGSCheckoutRequestResult = .failure(code, data, response, error, nil)
					//					completion(requestResult)
					//					return
					//				}



					//        strongSelf.sendTransfer(with: paymentInfo, finId: id, completion: completion)
				}
			case .failure(let code, let data, let response, let error):
        let errorMessage =  (error as NSError?)?.localizedDescription ?? ""
        extraData["statusCode"] = code
        extraData["error"] = errorMessage
        VGSCheckoutAnalyticsClient.shared.trackFormEvent(strongSelf.vgsCollect.formAnalyticsDetails, type: .finInstrument, status: .failed, extraData: extraData)
//				var paymentInfo = VGSCheckoutPaymentResultInfo(paymentMethod: .newCard(newCardInfo))
				let requestResult: VGSCheckoutRequestResult = .failure(code, data, response, error, nil)
				completion(requestResult)
			}
		}
	}

	/*
	internal func sendTransfer(with paymentInfo: VGSCheckoutPaymentResultInfo, finId: String, completion: @escaping VGSCheckoutRequestResultCompletion) {
		let transderPayload: [String: Any] = [
			"order_id": configuration.orderId,
			"financial_instrument_id": finId
		]
		// Use API client sendRequest since we don't need to send collected data again.
		vgsCollect.apiClient.sendRequest(path: transfersPath, method: .post, value: transderPayload) { response in
			switch response {
			case .success(let code, let data, let response):
        /// Additional checkout flow info.
        let info = paymentInfo
				let requestResult: VGSCheckoutRequestResult = .success(code, data, response, info)
				completion(requestResult)
			case .failure(let code, let data, let response, let error):
				let requestResult: VGSCheckoutRequestResult = .failure(code, data, response, error, paymentInfo)
				completion(requestResult)
			}
		}
	}
	*/

	/// Financial instrument id from success financial instrument response.
	/// - Parameter data: `Data?` object, response data.
	/// - Returns: `String?` object, financial instrument id or `nil`.
	private static func financialInstrumentID(from data: Data?) -> String? {
		if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
			if let dataJSON = jsonData["data"] as? [String: Any] {
				if let financialInstumentID = dataJSON["id"] as? String {
					return financialInstumentID
				}
			}
		}

		return nil
	}
}
