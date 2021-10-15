//
//  DemoAppConfiguration.swift
//  VGSCheckoutDemoApp
//

import Foundation
import UIKit

/// Setup your Vault configuration details here.
class DemoAppConfiguration {

	/// Shared instance.
	static let shared = DemoAppConfiguration()

	/// no:doc
	private init() {
		guard !UIApplication.isRunningUITest else {
			setupMockedTestDataIfNeeded()
			return
		}

		/* Uncomment to use *xconfig file.
		// Fill data from *.xconfig for test and etc if *.xconfig is available. 
		if let customVault = Bundle.main.object(forInfoDictionaryKey: "CUSTOM_VAULT") as? String {
			self.vaultId = customVault
		}

		if let multiplexingVault = Bundle.main.object(forInfoDictionaryKey: "MULTIPLEXING_VAULT") as? String {
			self.multiplexingVaultId = multiplexingVault
		}

		if let multiplexingServicePath = Bundle.main.object(forInfoDictionaryKey: "MULTIPLEXING_SERVICE_URL") as? String {
			self.multiplexingServicePath = "https://" + multiplexingServicePath
		}
		*/
	}

	/// Set your vault id here https://www.verygoodsecurity.com/terminology/nomenclature#vault
	var vaultId = "vaultId"

	/// Set vault id matching your multiplexing configuration.
	var multiplexingVaultId = "vaultId"

	/// Set environment - `sandbox` for testing or `live` for production.
	var environment = "sandbox"

	/// Path to backend URL to fetch token for multipexing.
	var multiplexingServicePath = ""

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
		}
	}
}
