//
//  UIApplication+Extensions.swift
//  VGSCheckoutDemoApp
//

import Foundation
import UIKit

extension UIApplication {

	  /// A boolean flag, true if app is running for UITests.
		static var isRunningUITest: Bool {
				return ProcessInfo().arguments.contains("VGSCheckoutDemoAppUITests")
		}
}
