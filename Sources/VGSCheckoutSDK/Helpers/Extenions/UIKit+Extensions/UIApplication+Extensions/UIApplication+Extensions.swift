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
}
