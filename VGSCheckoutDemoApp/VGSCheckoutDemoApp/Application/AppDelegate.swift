//
//  AppDelegate.swift
//  VGSCheckoutDemoApp
//
//  Created by Dima on 26.05.2021.
//

#if canImport(UIKit)
import UIKit
#endif
import VGSCheckoutSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

		// Enable loggers only for debug!
		// Enable loggers to check VGSCheckoutSDK warnings and network requests.
		#if DEBUG
		VGSCheckoutLogger.shared.configuration.isNetworkDebugEnabled = true
		VGSCheckoutLogger.shared.configuration.level = .warning
		#endif

    return true
  }
}
