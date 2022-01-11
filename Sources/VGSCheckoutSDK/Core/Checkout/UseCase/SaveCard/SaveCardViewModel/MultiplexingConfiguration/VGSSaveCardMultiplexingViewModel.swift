//
//  VGSAddCardMultiplexingViewModel.swift
//  VGSCheckoutSDK

import Foundation

/// Add card component view model for multiplexing configuration.
internal class VGSSaveCardMultiplexingViewModel: VGSSaveCardViewModelProtocol {

	internal init(multiplexingConfiguration: VGSCheckoutMultiplexingAddCardConfiguration, vgsCollect: VGSCollect) {
		self.multiplexingConfiguration = multiplexingConfiguration
		self.multiplexingAPIWorker = VGSSaveCardMultiplexingConfigAPIWorker(vgsCollect: vgsCollect, multiplexingConfiguration: multiplexingConfiguration)
	}

	// MARK: - Vars

	/// Configuration.
	private let multiplexingConfiguration: VGSCheckoutMultiplexingAddCardConfiguration

	/// Add card api worker for custom configuration.
	private let multiplexingAPIWorker: VGSSaveCardMultiplexingConfigAPIWorker

	// MARK: - VGSAddCardViewModelProtocol

	/// API worker.
	internal var apiWorker: VGSSaveCardAPIWorkerProtocol {
		return multiplexingAPIWorker
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
