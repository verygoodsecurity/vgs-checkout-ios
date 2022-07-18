//
//  APIClient+Utils.swift
//  VGSCheckoutSDK
//
//  Created on 16.02.2021.
//  Copyright © 2021 VGS. All rights reserved.
//

import Foundation

internal extension APIClient {

	// MARK: - Vault Url

	/// Generates API URL with vault id, environment and data region.
	/// - Parameters:
	///   - tenantId: `String` object, should be valid vaultID.
	///   - regionalEnvironment: `String` object, should be valid  regionalEnvironment.
  ///   - routeId: `String?` object,  inbound route id could be nil or valid uuid string.
	/// - Returns: `URL?` object, url or `nil` for invalid configuration.
  static func buildVaultURL(tenantId: String, regionalEnvironment: String, routeId: String?) -> URL? {

		// Check environment is valid.
		if !VGSCollect.regionalEnironmentStringValid(regionalEnvironment) {
			logInvalidEnironmentEvent(regionalEnvironment)
		}

		// Check tenant is valid.
		if !VGSCollect.tenantIDValid(tenantId) {
			logInvalidVaultIDEvent(tenantId)
		}

    let strUrl: String
    // Check is routeId is set and valid.
    if let routeId = routeId, !routeId.isEmpty {
      // Validate routeId
      if !VGSCollect.routeIdStringValid(routeId) {
        logInvalidRouteIdEvent(routeId)
        return nil
      }
      // Build url with specifi route id.
      strUrl = "https://" + tenantId + "-" + "\(routeId)" + "." + regionalEnvironment + ".verygoodproxy.com"
    } else {
      // Build default url.
      strUrl = "https://" + tenantId + "." + regionalEnvironment + ".verygoodproxy.com"
    }
    
		// Check vault url is valid.
		guard let url = URL(string: strUrl) else {
			APIClient.logCannotBuildURLEvent(for: tenantId, regionalEnvironment: regionalEnvironment, routeId: routeId)

			return nil
		}
		return url
	}

	/// Logs invalid environment event.
	/// - Parameter regionalEnvironment: `String` object, invalid regionalEnvironment.
	static func logInvalidEnironmentEvent(_ regionalEnvironment: String) {
		let eventText = "CONFIGURATION ERROR: ENVIRONMENT STRING IS NOT VALID!!! region \(regionalEnvironment)"
		let event = VGSLogEvent(level: .warning, text: eventText, severityLevel: .error)
		VGSCheckoutLogger.shared.forwardLogEvent(event)
		assert(VGSCollect.regionalEnironmentStringValid(regionalEnvironment), "❗VGSCheckout CONFIGURATION ERROR: ENVIRONMENT STRING IS NOT VALID!!!")
	}

	/// Logs invalid vaultID event.
	/// - Parameters:
  /// - vaultID: `String` object, invalid vaultID.
	static func logInvalidVaultIDEvent(_ vaultID: String) {
		var degugText = vaultID
		if degugText.isEmpty {
			degugText = "*EMPTY ID*"
		}
		let eventText = "CONFIGURATION ERROR: ID IS NOT VALID OR NOT SET!!! ID: \(degugText)"
		let event = VGSLogEvent(level: .warning, text: eventText, severityLevel: .error)
		VGSCheckoutLogger.shared.forwardLogEvent(event)
		assert(VGSCollect.tenantIDValid(vaultID), "❗VGSCheckout CONFIGURATION ERROR: : ID IS NOT VALID!!!")
	}
  
  /// Logs invalid routeId event.
  /// - Parameter routeId: `String` object, invalid inbound routeId.
  static func logInvalidRouteIdEvent(_ routeId: String) {
    let eventText = "CONFIGURATION ERROR: ROUTE ID STRING IS NOT VALID!!! routeId \(routeId)"
    let event = VGSLogEvent(level: .warning, text: eventText, severityLevel: .error)
    VGSCheckoutLogger.shared.forwardLogEvent(event)
    assert(VGSCollect.routeIdStringValid(routeId), "❗VGSCheckout CONFIGURATION ERROR: ROUTE ID STRING IS NOT VALID!!!")
  }

	/// Logs invalid configuration for vault URL.
	/// - Parameters:
	///   - vaultID: `String` object, invalid vaultID.
	///   - regionalEnvironment: `String` object, invalid regionalEnvironment.
  ///   - routeId: `String?` object,  inbound route id could be nil or valid uuid string.
  static func logCannotBuildURLEvent(for vaultID: String, regionalEnvironment: String, routeId: String?) {
		assertionFailure("❗VGSCheckout CONFIGURATION ERROR: : NOT VALID ORGANIZATION PARAMETERS!!!")

    let eventText = "CONFIGURATION ERROR: NOT VALID ORGANIZATION PARAMETERS!!! ID: \(vaultID), environment: \(regionalEnvironment), routeId: \(String(describing: routeId))"
		let event = VGSLogEvent(level: .warning, text: eventText, severityLevel: .error)
		VGSCheckoutLogger.shared.forwardLogEvent(event)
	}
}
