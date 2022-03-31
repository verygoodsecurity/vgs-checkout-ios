//
//  VGSCheckoutAddressOptionsProtocol.swift
//  VGSCheckoutSDK

import Foundation

/// Defines an interface for billing address options.
internal protocol VGSCheckoutAddressOptionsProtocol {
	/// Field visibility.
	var visibility: VGSCheckoutFieldVisibility {get set}

	/// Field type.
	var fieldType: VGSAddCardFormFieldType {get}
}
