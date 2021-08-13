//
//  APIClient+Utils.swift
//  VGSCheckout
//
//  Created on 16.02.2021.
//  Copyright © 2021 VGS. All rights reserved.
//

import Foundation

internal extension APIClient {

	// MARK: - Vault Url

	/// Generates API URL with vault id, environment and data region.
	static func buildVaultURL(tenantId: String, regionalEnvironment: String) -> URL? {

		// Check environment is valid.
		if !VGSCollect.regionalEnironmentStringValid(regionalEnvironment) {
			logInvalidEnironmentEvent(regionalEnvironment)
		}

		// Check tenant is valid.
		if !VGSCollect.tenantIDValid(tenantId) {
			logInvalidVaultIDEvent(tenantId)
		}

		let strUrl = "https://" + tenantId + "." + regionalEnvironment + ".verygoodproxy.com"

		// Check vault url is valid.
		guard let url = URL(string: strUrl) else {
			assertionFailure("❗VGSCheckout CONFIGURATION ERROR: : NOT VALID ORGANIZATION PARAMETERS!!!")

			let eventText = "CONFIGURATION ERROR: NOT VALID ORGANIZATION PARAMETERS!!! tenantID: \(tenantId), environment: \(regionalEnvironment)"
			let event = VGSLogEvent(level: .warning, text: eventText, severityLevel: .error)
			VGSCollectLogger.shared.forwardLogEvent(event)

			return nil
		}
		return url
	}

	static func logInvalidEnironmentEvent(_ regionalEnvironment: String) {
		let eventText = "CONFIGURATION ERROR: ENVIRONMENT STRING IS NOT VALID!!! region \(regionalEnvironment)"
		let event = VGSLogEvent(level: .warning, text: eventText, severityLevel: .error)
		VGSCollectLogger.shared.forwardLogEvent(event)
		assert(VGSCollect.regionalEnironmentStringValid(regionalEnvironment), "❗VGSCheckout CONFIGURATION ERROR: ENVIRONMENT STRING IS NOT VALID!!!")
	}

	static func logInvalidVaultIDEvent(_ vaultID: String) {
		let eventText = "CONFIGURATION ERROR: VAULT ID IS NOT VALID OR NOT SET!!! vaultID: \(vaultID)"
		let event = VGSLogEvent(level: .warning, text: eventText, severityLevel: .error)
		VGSCollectLogger.shared.forwardLogEvent(event)
		assert(VGSCollect.tenantIDValid(vaultID), "❗VGSCheckout CONFIGURATION ERROR: : VAULT ID IS NOT VALID!!!")
	}
}

internal final class VGSCheckoutVaultURLBuilder {

	internal static func buildVaultURL(for paymentInstrument: VGSPaymentInstrument, tenantId: String, regionalEnvironment: String) -> URL? {

		switch paymentInstrument {
		case .vault(let configuration):
			return APIClient.buildVaultURL(tenantId: tenantId, regionalEnvironment: regionalEnvironment)
		case .multiplexing(let configuration):
			return nil
		}
	}
}
