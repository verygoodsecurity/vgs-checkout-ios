//
//  VGSCheckoutPostalCodeFieldType.swift
//  VGSCheckout

import Foundation

/// Defines how to display card holder name field.
public enum VGSCheckoutPostalCodeFieldType {
	/**
	 Hide postal code.
	*/
	case hidden

	/**
	 Show postal code.

	 - Parameters:
			- fieldName: `String` object, .
	*/
	case displayed(_ fieldName: String)
}
