//
//  VGSCheckoutMultiplexingBillingAddressOptions.swift
//  VGSCheckout

import Foundation

/// Holds multiplexing billing address options.
public struct VGSCheckoutMultiplexingBillingAddressOptions {

	/// Billing address mode. Default is `.fullAddress`.
	public var addressMode: VGSCheckoutBillingAddressMode = .fullAddress

	/// no:doc
	public init() {}
}
