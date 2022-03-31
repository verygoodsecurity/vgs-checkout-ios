//
//  VGSCheckoutCustomBillingAddressLine2Options.swift
//  VGSCheckoutSDK

import Foundation

/// Holds billing address, address line 2 field options for custom configuration.
public struct VGSCheckoutCustomBillingAddressLine2Options: VGSCheckoutAddressOptionsProtocol {

	/// Field name in your route configuration.
	public var fieldName = ""

	/// Field visibility, default is `.visible`.
	public var visibility: VGSCheckoutFieldVisibility = .visible

	/// Field type.
	internal let fieldType: VGSAddCardFormFieldType = .addressLine2

	/// no:doc
	public init() {}
}
