//
//  VGSCheckoutBillingAddressMode.swift
//  VGSCheckout

import Foundation

/// Defines billing address mode.
public enum VGSCheckoutBillingAddressMode {

	/// Don't display address
	case noAddress

	/// Displays all fields for billing address. 
	case fullAddress

	/// Displays required fields to minimize input.
	//case requiredOnly
}
