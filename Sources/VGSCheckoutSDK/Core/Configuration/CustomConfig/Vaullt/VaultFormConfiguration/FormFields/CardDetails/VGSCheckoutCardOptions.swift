//
//  VGSCheckoutSDKCardOptions.swift
//  VGSCheckoutSDK
//

import Foundation

/// Holds options for card details.
public struct VGSCheckoutCardOptions {

	/// Card number setup.
	public var cardNumberOptions = VGSCheckoutCardNumberOptions()

	/// Expiration date setup.
	public var expirationDateOptions = VGSCheckoutExpirationDateOptions()

	/// Card holder setup.
	public var cardHolderOptions = VGSCheckoutCardHolderOptions()

	/// CVC setup.
	public var cvcOptions = VGSCheckoutCVCOptions()

	/// no:doc
	public init() {}
}
