//
//  VGSCheckoutSDKBillingAddressCityOptions.swift
//  VGSCheckoutSDK

import Foundation

/// Holds billing address city field options.
public struct VGSCheckoutCustomBillingAddressCityOptions: VGSCheckoutAddressOptionsProtocol {

	/// Field name in your route configuration.
	public var fieldName = ""

	/// Field visibility, default is `.visible`.
	public var visibility: VGSCheckoutFieldVisibility = .visible

	/// Field type.
	internal let fieldType: VGSAddCardFormFieldType = .city

	/// no:doc
	public init() {}
}

/// Holds billing address city field options for payment orchestration.
public struct VGSCheckoutBillingAddressCityOptions: VGSCheckoutAddressOptionsProtocol {

	/// Field visibility, default is `.visible`.
	public var visibility: VGSCheckoutFieldVisibility = .visible

	/// Field type.
	internal let fieldType: VGSAddCardFormFieldType = .city

	/// no:doc
	public init() {}
}
