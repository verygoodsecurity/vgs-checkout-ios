//
//  VGSAddCardCustomViewModel.swift
//  VGSCheckoutSDK

import Foundation

internal class VGSSaveCardCustomViewModel: VGSSaveCardViewModelProtocol {

	internal init(customConfiguration: VGSCheckoutCustomConfiguration, vgsCollect: VGSCollect) {
		self.customConfiguration = customConfiguration
		self.customAddCardAPIWorker = VGSSaveCardCustomConfigAPIWorker(vgsCollect: vgsCollect, vaultConfiguration: customConfiguration)
	}

	// MARK: - Vars

	/// Configuration.
	private let customConfiguration: VGSCheckoutCustomConfiguration

	/// Add card api worker for custom configuration.
	private let customAddCardAPIWorker: VGSSaveCardCustomConfigAPIWorker

	// MARK: - VGSAddCardViewModelProtocol

	/// API worker.
	internal var apiWorker: VGSSaveCardAPIWorkerProtocol {
		return customAddCardAPIWorker
	}

	/// Payment button title.
	internal var submitButtonTitle: String {
		return  VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_save_card_button_title")
	}

	/// Root navigation title.
	internal var rootNavigationTitle: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_add_card_navigation_bar_title")
	}
}
