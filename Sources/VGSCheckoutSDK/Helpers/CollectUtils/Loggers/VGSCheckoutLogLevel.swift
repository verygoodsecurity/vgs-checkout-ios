//
//  VGSCheckoutSDKLogLevel.swift
//  VGSCheckoutSDK
//

import Foundation

/// Defines levels of logging.
public enum VGSCheckoutLogLevel: String {
		/// Log *all* events including errors and warnings.
		case info

		/// Log *only* events indicating warnings and errors.
		case warning

		/// Log *no* events.
		case none
}
