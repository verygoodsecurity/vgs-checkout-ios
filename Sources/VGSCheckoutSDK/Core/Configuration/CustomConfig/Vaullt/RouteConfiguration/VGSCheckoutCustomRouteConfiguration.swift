//
//  VGSCheckoutCustomRouteConfiguration.swift
//  VGSCheckoutSDK

import Foundation

/// Checkout route configuration.
public struct VGSCheckoutCustomRouteConfiguration {

	/// Inbound route path for your organization vault.
	public var path = ""
  
  /// `String?`, organization vault inbound route id, could be `nil` when vault has only one route.
  public var routeId: String? = nil

	/// Hostname policy (specifies different hosts how to send your data). Default is `vault`.
	public var hostnamePolicy: VGSCheckoutHostnamePolicy = .vault

	/// Request options.
	public var requestOptions = VGSCheckoutCustomConfigurationRequestOptions()

	/// no:doc
	public init() {}
}
