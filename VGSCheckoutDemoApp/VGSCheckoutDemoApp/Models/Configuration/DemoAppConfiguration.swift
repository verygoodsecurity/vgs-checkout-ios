//
//  DemoAppConfiguration.swift
//  VGSCheckoutDemoApp
//

import Foundation

/// Setup your Vault configuration details here.
class DemoAppConfiguration {

	/// Shared instance.
	static let shared = DemoAppConfiguration()

	/// no:doc
	private init() {
		if let customVault = Bundle.main.object(forInfoDictionaryKey: "CUSTOM_VAULT") as? String {
			self.vaultId = customVault
		}

		if let multiplexingVault = Bundle.main.object(forInfoDictionaryKey: "MULTIPLEXING_VAULT") as? String {
			self.multiplexingVaultId = multiplexingVault
		}
	}

	/// Set your vault id here https://www.verygoodsecurity.com/terminology/nomenclature#vault
	var vaultId = "vaultId"

	var multiplexingVaultId = "vaultId"

	///  Set environment - `sandbox` for testing or `live` for production
	var environment = "sandbox"
}
