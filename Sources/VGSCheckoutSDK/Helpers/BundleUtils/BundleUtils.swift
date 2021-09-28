//
//  BundleUtils.swift
//  VGSCheckoutSDK

import Foundation

/// Helper class to identify resources bundle.
internal class BundleUtils {

	/// Resources name in CocoaPods podspec.
	private let cocoaPodsResourcesName = "CheckoutResources"

	/// Shared insance.
	static var shared = BundleUtils()

	/// Resources bundle.
	fileprivate (set) internal var resourcesBundle: Bundle?

	/// Initialization.
	private init() {
		// Identify bundle for SPM.
		#if SWIFT_PACKAGE
		resourcesBundle = Bundle.module
		#endif

		// Return if bundle is found.
		guard resourcesBundle == nil else {
			return
		}

		let containingBundle = Bundle(for: BundleUtils.self)

		// Look for Resources bundle (handle CocoaPods integration).
		if let bundleURL = containingBundle.url(forResource: cocoaPodsResourcesName, withExtension: "bundle") {
			resourcesBundle = Bundle(url: bundleURL)
		} else {
			// Resources bundle matches containing bundle (Carthage integration).
			resourcesBundle = containingBundle
		}
	}
}
