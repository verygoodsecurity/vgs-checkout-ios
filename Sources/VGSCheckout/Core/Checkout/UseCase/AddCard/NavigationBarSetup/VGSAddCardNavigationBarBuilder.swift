//
//  VGSAddCardNavigationBarBuilder.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal class VGSAddCardNavigationBarBuilder {

	internal static func setupNavigationBarTitle(in viewController: UIViewController) {

		viewController.navigationItem.title = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_add_card_navigation_bar_title")
	}
}
