//
//  VGSCheckoutVaultRouteConfiguration.swift
//  VGSCheckout

import Foundation

/// Route configuration for Vault.
public struct VGSCheckoutVaultRouteConfiguration {

	/// Inbound rout path for your organization vault.
	public var path = ""

	/// Hostname policy (specifies different hosts how to send your data). Default is `vault`.
	public var hostnamePolicy: VGSCheckoutHostnamePolicy = .vault

	/// Request options.
	public var requestOptions = VGSCheckoutRequestOptions()

	/// no:doc
	public init() {}
}
