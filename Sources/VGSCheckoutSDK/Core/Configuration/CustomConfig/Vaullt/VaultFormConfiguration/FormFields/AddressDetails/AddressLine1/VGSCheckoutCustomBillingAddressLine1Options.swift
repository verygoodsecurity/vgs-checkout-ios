//
//  VGSCheckoutCustomBillingAddressLine1Options.swift
//  VGSCheckoutSDK

import Foundation

/// Holds billing address, address line 1 field options.
public struct VGSCheckoutCustomBillingAddressLine1Options: VGSCheckoutAddressOptionsProtocol {

	/// Field name in your route configuration.
	public var fieldName = ""

	/// Field visibility, default is `.visible`.
	public var visibility: VGSCheckoutFieldVisibility = .visible

	/// A boolean flag, true if field is required for form, default is `true`. If field is not visible this value will be ignored.
	public var isRequired: Bool = true

	/// no:doc
	public init() {}
}
