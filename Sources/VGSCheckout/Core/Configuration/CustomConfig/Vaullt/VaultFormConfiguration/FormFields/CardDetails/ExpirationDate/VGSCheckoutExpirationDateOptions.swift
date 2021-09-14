//
//  VGSCheckoutExpirationDateOptions.swift
//  VGSCheckout

import Foundation

/// Holds expiration date options.
public struct VGSCheckoutExpirationDateOptions {

	/// Field name in your route configuration.
	public var fieldName: String = ""

	/// Input date format to convert. Default is `nil`.
	public var inputDateFormat: VGSCheckoutCardExpDateFormat?

	/// Output date format. Default is `nil`.
	public var outputDateFormat: VGSCheckoutCardExpDateFormat?

	/// Output date format. Default is `[]`.
	public var serializers: [VGSCheckoutFormatSerializerProtocol] = []

	/// no:doc
	public init() {}
}
