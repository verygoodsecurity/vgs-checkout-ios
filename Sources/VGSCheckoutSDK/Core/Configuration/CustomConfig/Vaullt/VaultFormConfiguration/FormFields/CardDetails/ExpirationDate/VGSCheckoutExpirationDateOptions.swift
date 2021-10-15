//
//  VGSCheckoutSDKExpirationDateOptions.swift
//  VGSCheckoutSDK

import Foundation

/// Holds expiration date options.
public struct VGSCheckoutExpirationDateOptions {

	/// Field name in your route configuration.
	public var fieldName: String = ""

	/// Input date format to convert. Default is `.shortYear`.
  public var inputDateFormat: VGSCheckoutCardExpDateFormat = .shortYear

	/// Output date format. Default is `.shortYear`.
  public var outputDateFormat: VGSCheckoutCardExpDateFormat = .shortYear

	/// Output date format. Default is `[]`.
	public var serializers: [VGSCheckoutFormatSerializerProtocol] = []

	/// no:doc
	public init() {}
}
