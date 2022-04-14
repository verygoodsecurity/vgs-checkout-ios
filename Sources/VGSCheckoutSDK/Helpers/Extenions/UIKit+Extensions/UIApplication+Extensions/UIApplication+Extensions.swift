//
//  UIApplication+Extensions.swift
//  VGSCheckoutSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// no:doc
internal extension UIApplication {

		/// A boolean flag, true if app is running for UITests.
		static var isRunningUITest: Bool {
				return ProcessInfo().arguments.contains("VGSCheckoutDemoAppUITests")
		}

		/// A boolean flag, true if app has saved card for UITests.
		static var hasSavedCardInUITest: Bool {
				return ProcessInfo().arguments.contains("savedCards")
		}

		/// A boolean flag, true if app should success remove saved card for UITests.
		static var shouldTriggerSuccessRemoveSavedCard: Bool {
			return ProcessInfo().arguments.contains("successRemoveSavedCard")
		}
}
