//
//  VGSCheckoutSDKBillingAddressPostalCodeOptions.swift
//  VGSCheckoutSDK

import Foundation

/// Holds billing address postal code (zip in US) field options.
public struct VGSCheckoutCustomBillingAddressPostalCodeOptions: VGSCheckoutAddressOptionsProtocol {

	/// Field name in your route configuration.
	public var fieldName = ""

	/// Field visibility, default is `.visible`.
	public var visibility: VGSCheckoutFieldVisibility = .visible

	/// Field type.
	internal let fieldType: VGSAddCardFormFieldType = .postalCode

	/// no:doc
	public init() {}
}

/// Holds billing address postal code (zip in US) field options for payment orchestration.
public struct VGSCheckoutBillingAddressPostalCodeOptions: VGSCheckoutAddressOptionsProtocol {

	/// Field visibility, default is `.visible`.
	public var visibility: VGSCheckoutFieldVisibility = .visible

	/// Field type.
	internal let fieldType: VGSAddCardFormFieldType = .postalCode

	/// no:doc
	public init() {}
}
