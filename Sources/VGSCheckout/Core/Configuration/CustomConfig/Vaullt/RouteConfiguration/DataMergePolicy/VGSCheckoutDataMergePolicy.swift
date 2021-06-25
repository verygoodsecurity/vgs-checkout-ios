//
//  VGSCheckoutDataMergePolicy.swift
//  VGSCheckout

import Foundation

/// Defines policy how to merge data.
public enum VGSCheckoutDataMergePolicy {
	/// FieldName will be treated as a flat key without any nested levels.
	/// data.cardNumber -> ["data.cardNumber" : "4111111111111111"]
	case flat

	/// Map data to the nested JSON.
	/// data.cardNumber -> ["data" : ["cardNumber" : "4111111111111111"]].
	case nestedJSON

	/**
	Map field name to nested JSON and array if array index is specified.
	Example:
	card_data[1].number => nested JSON with array

		{
			"card_data" :
				[
					null,

					{ "number" : "4111111111111111" }
				]
		}

	Completely overwrite extra data array with Checkout Array data.

				// Checkout fields JSON:
				[
				 { "cvc" : "555" }
				]

				// Extra data JSON:
				[
				 { "number" : "4111111111111111" },
				 { "id" : "1111" }
				]

				// JSON to submit:
				[
				 {
					"cvc" : "555",
				 }
				]
	*/
	case nestedWithArrayOverwrite

	/**
	Map field name to nested JSON and array if array index is specified.
	Example:
	card_data[1].number => nested JSON with array

		{
			"card_data" :
				[
					null,

					{ "number" : "4111111111111111" }
				]
		}

	Merge arrays content at the same nested level if possible.

				// Checkout fields JSON:
				[
				 { "cvc" : "555" }
				]

				// Extra data JSON:
				[
				 { "number" : "4111111111111111" }
				]

				// JSON to submit:
				[
				 {
					"cvc" : "555",
					"number" : "4111111111111111"
				 }
				]
	*/
	case nestedWithArrayMerge
}
