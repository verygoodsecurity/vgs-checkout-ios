//
//  VGSPaymentOptionsViewModel.swift
//  VGSCheckoutSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Payment options component view model for payopt transfers configuration.
internal class VGSPaymentOptionsViewModel {

	/// An object that acts as a view model delegate.
	internal weak var delegate: VGSPaymentOptionsViewModelDelegate?

	/// Initializer.
	/// - Parameters:
	///   - configuration: `VGSCheckoutPayoptBasicConfiguration`, payment configuration.
	///   - vgsCollect: `VGSCollect` object, vgs collect.
	///   - checkoutService: `VGSPayoptAddCardCheckoutService` object, payopt add card service.
	internal init(configuration: VGSCheckoutPayoptBasicConfiguration, vgsCollect: VGSCollect, checkoutService: VGSCheckoutBasicPayoptServiceProtocol) {
		self.configuration = configuration
		self.removeSavedCardAPIWorker =  VGSRemoveSavedCardAPIWorker(vgsCollect: vgsCollect, configuration: configuration)
		self.apiWorker = VGSPayoptAddCardAPIWorker(configuration: configuration, vgsCollect: vgsCollect, checkoutService: checkoutService)

		self.paymentOptions = configuration.savedCards.map({return .savedCard($0)})
		self.paymentOptions.append(.newCard)

		/// Preselect first card by default.
		paymentOptions.preselectFirstSavedCard()
	}

	// MARK: - Vars

	/// An array of payment options.
	internal var paymentOptions: [VGSPaymentOption] = []

	/// Configuration.
	private(set) var configuration: VGSCheckoutPayoptBasicConfiguration

	/// Transfers API worker.
	internal let apiWorker: VGSPayoptAddCardAPIWorker

	/// API worker for removing cards.
	internal let removeSavedCardAPIWorker: VGSRemoveSavedCardAPIWorkerProtocol

	/// Payment button title.
	internal var submitButtonTitle: String {
		switch configuration.payoptFlow {
		case .addCard:
			return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_pay_with_card_button_title")
		case .transfers:
			return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_transfers_pay_with_card_button_title") + " \(formattedAmount)"
		}
	}

	/// New card cell title.
	internal var newCardCellTitle: String {
		switch configuration.payoptFlow {
		case .addCard:
			return 	VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_payment_options_add_new_card_title")
		case .transfers:
			return 	VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_transfer_payment_options_pay_with_new_card_title")
		}
	}

	/// Navigation bar title.
	internal var rootNavigationTitle: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_payment_options_navigation_bar_title")
	}

	/// Formatted amount.
	internal var formattedAmount: String {
		guard let config = configuration as? VGSCheckoutPaymentConfiguration else {
			fatalError("Configuration doesn't match transfers flow")
		}
		let paymentInfo = config.paymentInfo
		guard let text = VGSFormatAmountUtils.formatted(amount: paymentInfo.amount, currencyCode: paymentInfo.currency) else {
			let event = VGSLogEvent(level: .warning, text: "Cannot format amount: \(paymentInfo.amount) currency: \(paymentInfo.currency)", severityLevel: .warning)
			VGSCheckoutLogger.shared.forwardLogEvent(event)
			return ""
		}

		return text
	}

	/// Handles tap on payment option. Updates selection state if needed.
	/// - Parameter index: `Int` object, index.
	internal func handlePaymentOptionTap(at index: Int) {
		guard let paymentOption = paymentOptions[safe: index] else {
			assertionFailure("payment option not found at index: \(index)")
			return
		}

		switch paymentOption {
		case.savedCard(let savedCard):
			// Ignore deselect current card.
			if savedCard.isSelected {
				//print("ignore current selection")
				return
			} else {
				savedCard.isSelected = true

				// Remove selection from the previous card.
				for savedCardIndex in 0..<paymentOptions.count {
					let option = paymentOptions[savedCardIndex]
					switch option {
					case .savedCard(let previousCard):
						//print("savedCardIndex: \(savedCardIndex), index: \(index)")
						if savedCardIndex != index {
							//print("unmard card!")
							previousCard.isSelected = false
						}
					case .newCard:
						continue
					}
				}
			}
			//print("current new savedCard.id: \(savedCard.id)")
			delegate?.savedCardSelectionDidUpdate()
		case .newCard:
			delegate?.payWithNewCardDidTap()
		}
	}

	/// Provides saved card model for specified index.
	/// - Parameter index: `Int` object, index.
	/// - Returns: `VGSSavedCardModel?` object, saved card model.
	internal func savedCardModel(at index: Int) -> VGSSavedCardModel? {
		return paymentOptions[safe: index]?.savedCardModel
	}

	/// Handled tap on edit saved cards button - removes selection state.
	internal func handleEditModeTap() {
		delegate?.savedCardDidUpdateBeforeEditing()
	}

	internal func handleCancelEditSavedCardsTap() {
		guard let savedCard = paymentOptions.first?.savedCardModel else {
			// No saved cards.
			delegate?.savedCardDidUpdateAfterEditing()
			return
		}

		// If no preselected card - preselect the first one.
		if !paymentOptions.hasSelectedCard {
			paymentOptions.preselectFirstSavedCard()
		}
		delegate?.savedCardDidUpdateAfterEditing()
	}

	/// Handles remove saved card action.
	/// - Parameter cardIdToRemove: `String` object, card fin instrument id to remove.
	internal func hadleRemoveSavedCard(with cardIdToRemove: String, requestResult: VGSCheckoutRequestResult) {
		paymentOptions.removeSavedCard(with: cardIdToRemove)
		if !paymentOptions.hasSelectedCard {
			paymentOptions.preselectFirstSavedCard()
		}

		delegate?.savedCardDidRemove(with: cardIdToRemove, requestResult: requestResult)
	}

	/// Selected payment card info.
	internal var selectedPaymentCardInfo: VGSCheckoutPaymentCardInfo? {
		guard let selectedId = paymentOptions.selectedCardId else {return nil}
		let savedCardModels = paymentOptions.compactMap { paymentOption -> VGSSavedCardModel? in
			switch paymentOption {
			case .savedCard(let card):
				return card
			case .newCard:
				return nil
			}
		}
		guard savedCardModels.first(where: {$0.id == selectedId}) != nil else {return nil}
		return VGSCheckoutPaymentCardInfo(id: selectedId)
	}
}
