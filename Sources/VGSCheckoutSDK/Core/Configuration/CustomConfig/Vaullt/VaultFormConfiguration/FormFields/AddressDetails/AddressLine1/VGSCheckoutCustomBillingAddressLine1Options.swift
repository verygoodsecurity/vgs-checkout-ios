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

	/// Field type.
	internal let fieldType: VGSAddCardFormFieldType = .addressLine1

	/// no:doc
	public init() {}
}

/// Holds billing address, address line 1 field options for payment orchestration.
public struct VGSCheckoutBillingAddressLine1Options: VGSCheckoutAddressOptionsProtocol {

	/// Field visibility, default is `.visible`.
	public var visibility: VGSCheckoutFieldVisibility = .visible

	/// Field type.
	internal let fieldType: VGSAddCardFormFieldType = .addressLine1

	/// no:doc
	public init() {}
}
