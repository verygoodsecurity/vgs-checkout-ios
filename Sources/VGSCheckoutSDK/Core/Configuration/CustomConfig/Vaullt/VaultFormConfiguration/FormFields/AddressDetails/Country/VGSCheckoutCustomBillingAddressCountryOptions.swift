//
//  VGSCheckoutCustomBillingAddressCountryOptions.swift
//  VGSCheckoutSDK

import Foundation

/// Holds billing address country field options for custom configuration.
public struct VGSCheckoutCustomBillingAddressCountryOptions: VGSCheckoutAddressOptionsProtocol {

	/// Field name in your route configuration.
	public var fieldName = ""
  
  /// List of valid country codes in ISO-3166-1-alpha-2 format.
  /// - NOTE: Countries order in array will match countries order in country picker view.
  /// - NOTE: Check valid country ISO codes here: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2 .
  public var validCountries: [String]?

	/// Field visibility, default is `.visible`.
	public var visibility: VGSCheckoutFieldVisibility = .visible

	/// Field type.
	internal let fieldType: VGSAddCardFormFieldType = .country

	/// no:doc
	public init() {}
}

/// Holds billing address country field options for payment orchestration.
public struct VGSCheckoutBillingAddressCountryOptions: VGSCheckoutAddressOptionsProtocol {
  
  //// List of valid country codes in ISO-3166-1-alpha-2 format.
  /// - NOTE: Countries order in array will match countries order in country picker view.
  /// - NOTE: Check valid country ISO codes here: https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2 .
  public var validCountries: [String]?

	/// Field visibility, default is `.visible`.
	public var visibility: VGSCheckoutFieldVisibility = .visible

	/// Field type.
	internal let fieldType: VGSAddCardFormFieldType = .country

  /// no:doc
  public init() {}
}
