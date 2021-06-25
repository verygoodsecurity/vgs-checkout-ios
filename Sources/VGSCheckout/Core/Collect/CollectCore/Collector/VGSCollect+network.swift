//
//  VGSCollect+network.swift
//  VGSCheckout
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
        var content: [String] = ["textField"]
        if !(extraData?.isEmpty ?? true) {
          content.append("custom_data")
        }
        if !(customHeaders?.isEmpty ?? true) {
          content.append("custom_header")
        }

				let fieldMappingPolicy = requestOptions.fieldNameMappingPolicy

				content.append(fieldMappingPolicy.analyticsName)
        if let error = validateStoredInputData() {
          
          VGSCheckoutAnalyticsClient.shared.trackFormEvent(self.formAnalyticsDetails, type: .beforeSubmit, status: .failed, extraData: [ "statusCode": error.code, "content": content])
          
          block(.failure(error.code, nil, nil, error))
            return
        }

        let body = mapFieldsToBodyJSON(with: fieldMappingPolicy, extraData: extraData)

        VGSCheckoutAnalyticsClient.shared.trackFormEvent(self.formAnalyticsDetails, type: .beforeSubmit, status: .success, extraData: [ "statusCode": 200, "content": content])
      
        // Send request.
        apiClient.sendRequest(path: path, method: method, value: body) { [weak self](response ) in
          
          // Analytics
          if let strongSelf = self {
            switch response {
            case .success(let code, _, _):
              VGSCheckoutAnalyticsClient.shared.trackFormEvent(strongSelf.formAnalyticsDetails, type: .submit, extraData: ["statusCode": code, "content": content])
            case .failure(let code, _, _, let error):
              let errorMessage =  (error as NSError?)?.localizedDescription ?? ""
              VGSCheckoutAnalyticsClient.shared.trackFormEvent(strongSelf.formAnalyticsDetails, type: .submit, status: .failed, extraData: ["statusCode": code, "error": errorMessage])
            }
        }
        block(response)
      }
    }
}
