//
//  DemoAppConfiguration.swift
//  VGSCheckoutDemoApp
//

import Foundation
import UIKit

/// Setup your configuration details here.
class DemoAppConfiguration {

	/// Shared instance.
	static let shared = DemoAppConfiguration()

	/// no:doc
	private init() {
		guard !UIApplication.isRunningUITest else {
			setupMockedTestDataIfNeeded()
			return
		}
	}

	/// Set your vault id here. https://www.verygoodsecurity.com/terminology/nomenclature#vault
	var vaultId = "vaultId"

	/// Set tenant id matching your payment orchestration configuration.
	var paymentOrchestrationTenantId = "tenantId"

	/// Set environment - `sandbox` for testing or `live` for production.
	var environment = "sandbox"

	/// Path to backend URL to fetch token for payment orchestration.
	var paymentOrchestrationServicePath = ""

	/// Setup mocked data.
	private func setupMockedTestDataIfNeeded() {
		if UIApplication.isRunningUITest {
			guard let path = Bundle.main.path(forResource: "UITestsMockedData", ofType: "plist") else {
					print("Path not found")
					return
			}

			guard let dictionary = NSDictionary(contentsOfFile: path) else {
					print("Unable to get dictionary from path")
					return
			}

			self.vaultId = dictionary["vaultID"] as? String ?? ""
			self.paymentOrchestrationTenantId = dictionary["tenantID"] as? String ?? ""
			self.paymentOrchestrationServicePath = dictionary["payoptMockedAPIPath"] as? String ?? ""
		}
	}
}
