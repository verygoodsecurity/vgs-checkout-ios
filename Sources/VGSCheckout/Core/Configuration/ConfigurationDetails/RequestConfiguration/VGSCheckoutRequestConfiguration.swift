//
//  VGSCheckoutRequestConfiguration.swift
//  VGSCheckout

import Foundation

/// Request configuration
public struct VGSCheckoutRequestConfiguration {

	/// Hostname policy (specifies different hosts how to send your data). Default is `vault`.
	public var hostnamePolicy: VGSCheckoutHostnamePolicy = .vault

	/// Request options, default `VGSCheckoutRequestOptions`.
	public var requestOptions = VGSCheckoutRequestOptions()

	/// no:doc
	public init() {}
}
