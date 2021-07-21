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
  
  /// CVC Icon visibility configuration.
  public var isIconHidden: Bool = false

	/// no:doc
	public init() {}
}
