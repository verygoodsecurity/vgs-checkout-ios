//
//  VGSCheckoutBasicConfigurationProtocol.swift
//  VGSCheckout
//

import Foundation

/// VGSCheckout basic configuration.
public protocol VGSCheckoutBasicConfigurationProtocol {}

/// Internal protocol for VGSCheckout configuration.
internal protocol VGSCheckoutConfigurationProtocol: VGSCheckoutBasicConfigurationProtocol {

	/// Vauld ID.
	var vaultID: String {get}

	/// Environment.
	var environment: String {get}
}
