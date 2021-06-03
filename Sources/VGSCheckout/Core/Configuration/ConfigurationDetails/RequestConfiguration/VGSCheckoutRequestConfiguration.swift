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

/// Holds request options.
/// VGSCheckoutRequestOptions
public struct VGSCheckoutRequestConfiguration {
	/// HTTP Method. Default is `post`.
	public var method: VGSCheckoutHTTPMethod = .post

	/// Extra data, should be valid `JSON`. Default is `nil`.
	public var extraData: [String: Any]?

	/// Merge options, default is `flat`.

	/// Merge options or merge policy
	public var mergeOptions: VGSCheckoutDataMergePolicy = .flat

	/// Custom request headers.
	public var customHeaders: [String : String] = [:]

	/// no:doc
	public init() {}
}
