//
//  VGSCheckoutSDKLoggingConfiguration.swift
//  VGSCheckoutSDK
//

import Foundation

/// Holds configuration for VGSCheckout logging.
public struct VGSCheckoutLoggingConfiguration {

	/// Log level. Default is `.none`.
	public var level: VGSCheckoutLogLevel = .none

	/// `Bool` flag. Specify `true` to record VGSCheckout network session with success/failed requests. Default is `false`.
	public var isNetworkDebugEnabled: Bool = false

	/// `Bool` flag. Specify `true` to enable extensive debugging. Default is `false`.
	public var isExtensiveDebugEnabled: Bool = false
}
