//
//  VGSCollect+network.swift
//  VGSCheckoutSDK
//
//  Created by Vitalii Obertynskyi on 09.05.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation

// MARK: - Send data
extension VGSCollect {
    /**
     Send data from VGSTextFields to your organization vault.
     
     - Parameters:
        - path: Inbound rout path for your organization vault.
        - method: HTTPMethod, default is `.post`.
        - extraData: Any data you want to send together with data from VGSTextFields , default is `nil`.
	      - requestOptions: `VGSCollectRequestOptions` object, holds additional request options. Default options are `.nestedJSON`.
        - completion: response completion block, returns `VGSResponse`.
     
     - Note:
        Errors can be returned in the `NSURLErrorDomain` and `VGSCheckoutErrorDomain`.
    */
	internal func sendData(path: String, method: HTTPMethod = .post, extraData: [String: Any]? = nil, requestOptions: VGSCollectRequestOptions = VGSCollectRequestOptions(), completion block: @escaping (VGSResponse) -> Void) {
      
        // Content analytics.
				var content: [String] = contentForAnalytics(from: extraData)

				let fieldMappingPolicy = requestOptions.fieldNameMappingPolicy

				content.append(fieldMappingPolicy.analyticsName)
        if let error = validateStoredInputData() {

          block(.failure(error.code, nil, nil, error))
					return
        }

        let body = mapFieldsToBodyJSON(with: fieldMappingPolicy, extraData: extraData)

				let dateBeforeRequest = Date()

        // Send request.
        apiClient.sendRequest(path: path, method: method, value: body) { [weak self](response ) in

					var extraData: [String : Any] = [:]
					extraData["latency"] = Int(Date().timeIntervalSince(dateBeforeRequest) * 1000)

          // Analytics
          if let strongSelf = self {
            switch response {
            case .success(let code, _, _):
							extraData["statusCode"] = code
              VGSCheckoutAnalyticsClient.shared.trackFormEvent(strongSelf.formAnalyticsDetails, type: .submit, extraData: extraData)
            case .failure(let code, _, _, let error):
              let errorMessage =  (error as NSError?)?.localizedDescription ?? ""
							extraData["statusCode"] = code
							extraData["error"] = errorMessage
							VGSCheckoutAnalyticsClient.shared.trackFormEvent(strongSelf.formAnalyticsDetails, type: .submit, status: .failed, extraData: extraData)
            }
        }
        block(response)
      }
    }

	/// Track befre submit with invalid fields.
	/// - Parameter invalidFields: `[String]` object, array of invalid fieldTypes.
	internal func trackBeforeSubmit(with invalidFields: [String]) {
		// Content analytics.
		var extraAnalyticsInfo: [String : Any] = [:]
		let contentData = contentForAnalytics(from: [:])

		if let error = validateStoredInputData() {
			if !invalidFields.isEmpty  {
				extraAnalyticsInfo["fieldTypes"] = invalidFields
			}

			extraAnalyticsInfo["content"] = contentData
			extraAnalyticsInfo["statusCode"] = error.code
			VGSCheckoutAnalyticsClient.shared.trackFormEvent(self.formAnalyticsDetails, type: .beforeSubmit, status: .failed, extraData: extraAnalyticsInfo)
		} else {
			extraAnalyticsInfo["statusCode"] = 200
			extraAnalyticsInfo["content"] = contentData
			VGSCheckoutAnalyticsClient.shared.trackFormEvent(self.formAnalyticsDetails, type: .beforeSubmit, status: .success, extraData: extraAnalyticsInfo)
		}
	}

	/// Custom content for analytics from headers and payload.
	/// - Parameter payload: `[String: Any]` payload object.
	/// - Returns: `[String]` object.
	private func contentForAnalytics(from payload: [String: Any]?) -> [String] {
		var content: [String] = []
		if !(payload?.isEmpty ?? true) {
			content.append("custom_data")
		}
		if !(customHeaders?.isEmpty ?? true) {
			content.append("custom_header")
		}

		// Always track custom hostname feature regardless its resolving status.
		switch apiClient.hostURLPolicy {
		case .customHostURL:
			content.append("custom_hostname")
		default:
			break
		}

		return content
	}
}
