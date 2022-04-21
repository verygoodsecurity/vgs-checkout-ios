//
//  VGSCollect+network.swift
//  VGSCheckoutSDK
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

        if let error = validateStoredInputData() {

          block(.failure(error.code, nil, nil, error))
					return
        }

				let fieldMappingPolicy = requestOptions.fieldNameMappingPolicy
        let body = mapFieldsToBodyJSON(with: fieldMappingPolicy, extraData: extraData)

				let dateBeforeRequest = Date()

        // Send request.
        apiClient.sendRequest(path: path, method: method, value: body) { [weak self](response ) in

					var extraData: [String: Any] = [:]
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
  internal func trackBeforeSubmit(with invalidFields: [String], configurationAnalytics: VGSCheckoutConfigurationAnalyticsProtocol) {
    
    var extraAnalyticsInfo: [String: Any] = [:]

		// Content analytics.
    var contentAnalytics = configurationAnalytics.contentAnalytics()
    // Always track custom hostname feature regardless its resolving status.
    switch apiClient.hostURLPolicy {
    case .customHostURL:
      contentAnalytics.append("custom_hostname")
    default:
      break
    }
    extraAnalyticsInfo["content"] = contentAnalytics
    
		if let error = validateStoredInputData() {
			if !invalidFields.isEmpty {
				extraAnalyticsInfo["fieldTypes"] = Array(Set(invalidFields))
			}

			extraAnalyticsInfo["statusCode"] = error.code
			VGSCheckoutAnalyticsClient.shared.trackFormEvent(self.formAnalyticsDetails, type: .beforeSubmit, status: .failed, extraData: extraAnalyticsInfo)
		} else {
			extraAnalyticsInfo["statusCode"] = 200
			VGSCheckoutAnalyticsClient.shared.trackFormEvent(self.formAnalyticsDetails, type: .beforeSubmit, status: .success, extraData: extraAnalyticsInfo)
		}
	}
}
