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
	private init() {}

	/// Set your vault id here https://www.verygoodsecurity.com/terminology/nomenclature#vault
	var vaultId = "vaultId"

	///  Set environment - `sandbox` for testing or `live` for production
	var environment = "sandxob"
}
