//
//  VGSCheckoutCustomConfigurationRequestOptions.swift
//  VGSCheckoutSDK

import Foundation

/// Holds request options.
public struct VGSCheckoutCustomConfigurationRequestOptions {

	/// HTTP Method. Default is `post`.
	public var method: VGSCheckoutHTTPMethod = .post

	/// Extra data, should be valid `JSON`. Default is `nil`.
	public var extraData: [String: Any]?

	/// Merge options or merge policy, default is `flat`.
	public var mergePolicy: VGSCheckoutDataMergePolicy = .flat

	/// Custom request headers.
	public var customHeaders: [String: String] = [:]

	/// no:doc
	public init() {}
}
