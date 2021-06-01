//
//  VGSCheckoutCardHolderFieldType.swift
//  VGSCheckout

import Foundation

/// Defines how to display card holder name field.
public enum VGSCheckoutCardHolderFieldType {
	/**
	 Card holder name is hidden.
	*/
	case hidden

	/**
	 Card holder name is displayed as a single field.

	 - Parameters:
			- fieldName: `String` object, fieldName.
	*/
	case single(_ fieldName: String)

	/**
	 Card holder name is splitted to first and last name.

	 - Parameters:
			- firstFieldName: `String` object, first name fieldName.
			- lastFieldName: `String` object, last name firstName fieldName.
	*/
	case splitted(_ firstFieldName: String, _ lastFieldName: String)
}
