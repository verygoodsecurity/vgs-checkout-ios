//
//  VGSPayoptAddCardViewModel.swift
//  VGSCheckoutSDK

import Foundation

/// Add card component view model for payopt add card configuration.
internal class VGSPayoptAddCardViewModel: VGSSaveCardViewModelProtocol {

	internal init(configuration: VGSCheckoutAddCardConfiguration, vgsCollect: VGSCollect) {
		self.configuration = configuration
		self.payoptAPIWorker = VGSSaveCardPayoptAddCardAPIWorker(vgsCollect: vgsCollect, configuration: configuration)
	}

	// MARK: - Vars

	/// Configuration.
	private let configuration: VGSCheckoutAddCardConfiguration

	/// Add card api worker for payopt configuration.
	private let payoptAPIWorker: VGSSaveCardPayoptAddCardAPIWorker

	// MARK: - VGSAddCardViewModelProtocol

	/// API worker.
	internal var apiWorker: VGSSaveCardAPIWorkerProtocol {
		return payoptAPIWorker
	}

	/// Payment button title.
	internal var submitButtonTitle: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_save_card_button_title")
	}

	/// Root navigation bar title.
	internal var rootNavigationTitle: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_add_card_navigation_bar_title")
	}
}
