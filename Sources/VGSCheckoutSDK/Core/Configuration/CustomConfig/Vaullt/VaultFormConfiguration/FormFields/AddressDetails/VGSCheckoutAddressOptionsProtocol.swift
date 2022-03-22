//
//  VGSCheckoutAddressOptionsProtocol.swift
//  VGSCheckoutSDK

import Foundation

/// Defines an interface for billing address options.
internal protocol VGSCheckoutAddressOptionsProtocol {
	/// Field visibility.
	var visibility: VGSCheckoutFieldVisibility {get set}

	/// A boolean flag, true if field is required for form. If field is not visible this value will be ignored.
	var isRequired: Bool {get set}

	/// Field type.
	var fieldType: VGSAddCardFormFieldType {get}
}
