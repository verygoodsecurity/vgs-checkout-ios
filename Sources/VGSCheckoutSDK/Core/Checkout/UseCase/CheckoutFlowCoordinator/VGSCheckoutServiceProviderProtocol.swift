//
//  VGSCheckoutServiceProviderProtocol.swift
//  VGSCheckoutSDK
//

import Foundation
#if os(iOS)
import UIKit
#endif

/// Defines interface for service providers.
internal protocol VGSCheckoutServiceProviderProtocol {

	/// Checkout service
	var checkoutService: VGSCheckoutServiceProtocol {get}
}
