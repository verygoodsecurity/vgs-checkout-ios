//
//  VGSCheckoutRequestOptions.swift
//  VGSCheckout

import Foundation

/// Additional options for request.
public struct VGSCheckoutRequestOptions {

	/// HTTP Method. Default is `post`.
	public var method: VGSCheckoutHTTPMethod = .post

	/// Extra data, should be valid `JSON`. Default is `nil`.
	public var extraData: [String: Any]?

	/// Merge options, default is `flat`.
	public var mergeOptions: VGSCheckoutDataMergePolicy = .flat

	/// no:doc
	public init() {}
}
