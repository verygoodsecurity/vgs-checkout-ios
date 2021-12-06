//
//  VGSCheckoutSDKCardNumberOptions.swift
//  VGSCheckoutSDK

import Foundation

/// Holds card number options.
public struct VGSCheckoutCardNumberOptions {

	/// Field name in your route configuration.
	public var fieldName: String = ""
  
  /// Card Brand Icon visibility configuration.
  public var isIconHidden: Bool = false

	/// no:doc
	public init() {}
}
