//
//  VGSCheckoutCVCOptions.swift
//  VGSCheckout

import Foundation

/// Holds CVC options.
public struct VGSCheckoutCVCOptions {

	/// Field name in your route configuration.
	public var fieldName: String = ""

	/// Field visibiliby, default is `.visible`.
	public var fieldVisibility: VGSCheckoutFieldVisibility = .visible

	/// no:doc
	public init() {}
}
