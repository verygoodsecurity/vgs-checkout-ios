//
//  VGSCollectLoggingConfiguration.swift
//  VGSCollectSDK
//

import Foundation

/// Holds configuration for VGSCollectSDK logging.
internal struct VGSCollectLoggingConfiguration {

	/// Log level. Default is `.none`.
	internal var level: VGSLogLevel = .none

	/// `Bool` flag. Specify `true` to record VGSCollectSDK network session with success/failed requests. Default is `false`.
	internal var isNetworkDebugEnabled: Bool = false

	/// `Bool` flag. Specify `true` to enable extensive debugging. Default is `false`.
	internal var isExtensiveDebugEnabled: Bool = false
}
