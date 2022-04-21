//
//  VGSAnalyticsClient.swift
//  VGSCheckoutSDK
//
//  Created by Dima on 03.09.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// :nodoc: VGS Analytics event type
internal enum VGSAnalyticsEventType: String {
  case hostnameValidation = "HostNameValidation"
  case beforeSubmit = "BeforeSubmit"
  case submit = "Submit"
	case formInit = "Init"
	case cancel = "Cancel"
	case jwtValidation = "JWTValidation"
  case finInstrument = "FinInstrument"
  case addCardPaymentMethod = "AddCardPaymentMethod"
}

/// Client responsably for managing and sending VGS Checkout SDK analytics events.
/// Note: we track only VGSCheckout usage and features statistics.
/// :nodoc:
public class VGSCheckoutAnalyticsClient {
  
  internal enum AnalyticEventStatus: String {
    case success = "Ok"
    case failed = "Failed"
    case cancel = "Cancel"
  }

	/// ISO8601 date formatter.
	internal lazy var dateFormatter: DateFormatter = {
		let dateFormatter = DateFormatter()
		let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
		dateFormatter.locale = enUSPosixLocale
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
		dateFormatter.calendar = Calendar(identifier: .gregorian)

		return dateFormatter
	}()
  
  /// Shared `VGSCheckoutAnalyticsClient` instance
  public static let shared = VGSCheckoutAnalyticsClient()
  
  /// Enable or disable VGS analytics tracking
  public var shouldCollectAnalytics = true
  
  /// Uniq id that should stay the same during application rintime
  public let vgsCheckoutSessionId = UUID().uuidString

	/// no:doc
  private init() {}

	/// Base URL.
  internal let baseURL = "https://vgs-collect-keeper.apps.verygood.systems/"

	/// Default headers.
  internal let defaultHttpHeaders: HTTPHeaders = {
    return ["Content-Type": "application/x-www-form-urlencoded" ]
  }()

	/// URL session object with `.ephemeral` configuration.
	internal let urlSession = URLSession(configuration: .ephemeral)
  
  internal static let userAgentData: [String: Any] = {
      let version = ProcessInfo.processInfo.operatingSystemVersion
      let osVersion = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

			var defaultUserAgentData = [
				"platform": UIDevice.current.systemName,
				"device": UIDevice.current.model,
				"deviceModel": UIDevice.current.modelIdentifier,
				"osVersion": osVersion,
				"dependencyManager": sdkIntegration]

				if let locale = Locale.preferredLanguages.first {
					defaultUserAgentData["deviceLocale"] = locale
				}

      return defaultUserAgentData
      }()

  /// :nodoc: Track events related to specific VGSCollect instance
  internal func trackFormEvent(_ form: VGSCheckoutFormAnanlyticsDetails, type: VGSAnalyticsEventType, status: AnalyticEventStatus = .success, extraData: [String: Any]? = nil) {
      let formDetails = ["formId": form.formId,
                         "tnt": form.tenantId,
                         "env": form.environment
                      ]
    var data: [String: Any]
    if let extraData = extraData {
      data = deepMerge(formDetails, extraData)
    } else {
      data = formDetails
    }

		// track only true or both?
		if form.isSatelliteMode == true {
			data["vgsSatellite"] = true
		}
    trackEvent(type, status: status, extraData: data)
  }

  /// :nodoc: Base function to Track analytics event
  internal func trackEvent(_ type: VGSAnalyticsEventType, status: AnalyticEventStatus = .success, extraData: [String: Any]? = nil) {
      var data = [String: Any]()
      if let extraData = extraData {
        data = extraData
      }
      data["type"] = type.rawValue
      data["status"] = status.rawValue
      data["ua"] = VGSCheckoutAnalyticsClient.userAgentData
      data["version"] = Utils.vgsCheckoutVersion
      data["source"] = "checkout-ios"
      data["localTimestamp"] = Int(Date().timeIntervalSince1970 * 1000)
      data["vgsCheckoutSessionId"] = vgsCheckoutSessionId
			data["clientTimestamp"] = dateFormatter.string(from: Date())
      sendAnalyticsRequest(data: data)
  }

	/// SDK integration tool.
	private static var sdkIntegration: String {
			#if COCOAPODS
				return "COCOAPODS"
			#elseif SWIFT_PACKAGE
				return "SPM"
			#else
				return "OTHER"
			#endif
	}
}

internal extension VGSCheckoutAnalyticsClient {
  
  // send events
  func sendAnalyticsRequest(method: HTTPMethod = .post, path: String = "vgs", data: [String: Any] ) {
    
      // Check if tracking events enabled
      guard shouldCollectAnalytics else {
        return
      }
    
      // Setup URLRequest
      guard let url = URL(string: baseURL)?.appendingPathComponent(path) else {
        return
      }
      var request = URLRequest(url: url)
      request.httpMethod = method.rawValue
      request.allHTTPHeaderFields = defaultHttpHeaders

      let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
			VGSNetworkRequestLogger.logAnalyticsRequest(request, payload: data)
      let encodedJSON = jsonData?.base64EncodedData()
      request.httpBody = encodedJSON

      // Send data
			urlSession.dataTask(with: request).resume()
  }
}
