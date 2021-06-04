//
//  VGSCheckoutRouteConfiguration.swift
//  VGSCheckout

import Foundation

/// Route configuration.
public struct VGSCheckoutRouteConfiguration {

	/// Hostname policy (specifies different hosts how to send your data). Default is `vault`.
	public var hostnamePolicy: VGSCheckoutHostnamePolicy = .vault

	/// Request options.
	public var requestOptions = VGSCheckoutRequestConfiguration()

	/// no:doc
	public init() {}
}
