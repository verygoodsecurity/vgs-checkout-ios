//
//  VGSCheckoutCardHolderOptions.swift
//  VGSCheckout

import Foundation

/// Holds card holder options.
public struct VGSCheckoutCardHolderOptions {

	/// Field name type. Default is `.single.` with empty fieldName.
	public var fieldNameType: FieldNameType = .single("")

	/// Field visibiliby, default is `.visible`.
	public var fieldVisibility: VGSCheckoutFieldVisibility = .visible

	/// Defines field type.
	public enum FieldNameType {
		/**
		Display card holder as a single field.

		- Parameter: cardHolder: `String` object. Should be valid `fieldName` used in route configuration.
		*/
		case single(_ cardHolder: String)

//		/**
//		Display card holder as a single field.
//
//		- Parameter: firstName: `String` object. Should be valid `fieldName` for first name used in route configuration.
//		- Parameter: lastName: `String` object. Should be valid `fieldName` for last name used in route configuration.
//		*/
//		case splitted(_ firstName: String, lastName: String)
	}

	/// no:doc
	public init() {}
}
