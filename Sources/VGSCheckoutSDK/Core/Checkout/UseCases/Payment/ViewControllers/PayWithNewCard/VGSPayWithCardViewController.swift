//
//  VGSPayWithCardViewController.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Holds UI for pay with new card flow.
internal class VGSPayWithCardViewController: VGSBaseCardViewController {

	/// Initial screen.
	fileprivate let initialScreen: VGSPayoptAddCardCheckoutService.InitialScreen

	// MARK: - Vars

	// Pay with card service.
	fileprivate weak var paymentService: VGSCheckoutBasicPayoptServiceProtocol?

	// View model.
	fileprivate let viewModel: VGSPayoptTransfersPayWithNewCardViewModel

	// Checkbox button.
	internal let checkboxButton: VGSCheckboxButton

	// MARK: - Initialization

	init(paymentService: VGSCheckoutBasicPayoptServiceProtocol, initialScreen: VGSPayoptAddCardCheckoutService.InitialScreen) {
		self.paymentService = paymentService
		self.initialScreen = initialScreen
		self.viewModel = VGSPayoptTransfersViewModelFactory.buildPayWithNewCardViewModel(with: paymentService)
		self.checkboxButton = VGSCheckboxButton(text: VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_pay_with_card_save_card_checkbox_hint"), theme: paymentService.configuration.uiTheme)
		super.init(checkoutConfigurationType: paymentService.checkoutConfigurationType, vgsCollect: paymentService.configuration.vgsCollect, uiTheme: paymentService.configuration.uiTheme)

		if initialScreen == .payWithNewCard {
			VGSCheckoutAnalyticsClient.shared.trackFormEvent(paymentService.configuration.vgsCollect.formAnalyticsDetails, type: .formInit, extraData: ["config": "payopt", "configType": "addCard"])
		}
	}

	/// no:doc
	internal required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	/// no:doc
	override func viewDidLoad() {
		super.viewDidLoad()

		delegate = self
	}

	// MARK: - Override

	/// Setups UI.
	override func setupUI() {
		super.setupUI()

		navigationItem.title = viewModel.rootNavigationTitle
		addCardSectionFormView.submitButton.title = viewModel.submitButtonTitle

		// Add checkbox button.
		checkboxButton.translatesAutoresizingMaskIntoConstraints = false
		if viewModel.configuration.isSaveCardOptionEnabled {
			// Preselect checkbox by default.
			checkboxButton.isSelected = true
			viewModel.saveCardCheckboxSelected = true

			// Insert checkbox button.
			let containerView = VGSAddCardFormViewBuilder.buildChecboxButtonContainerView()
			containerView.addContentView(checkboxButton)
			if let indexOfButton = addCardSectionFormView.backgroundStackView.arrangedSubviews.firstIndex(of: addCardSectionFormView.payButtonContainerView) {
				addCardSectionFormView.backgroundStackView.insertArrangedSubview(containerView, at: indexOfButton)
			}

			// Bind view model to checkbox button action.
			checkboxButton.onTap = { [weak self] in
				guard let strongSelf = self else {return}
				strongSelf.viewModel.saveCardCheckboxSelected = strongSelf.checkboxButton.isSelected

				if let isSelected = strongSelf.viewModel.saveCardCheckboxSelected {
					strongSelf.extraAnalyticsContent.removeAll()
					if isSelected {
						strongSelf.extraAnalyticsContent.append("save_card_checkbox_selected")
					} else {
						strongSelf.extraAnalyticsContent.append("save_card_checkbox_unselected")
					}
				}
			}
		}
	}
}

// MARK: - VGSCheckoutBaseCardViewControllerDelegate

// no:doc
extension VGSPayWithCardViewController: VGSCheckoutBaseCardViewControllerDelegate {

	// no:doc
	func submitButtonDidTap(in formState: VGSBaseCardViewController.FormState, viewController: VGSBaseCardViewController) {
		switch formState {
		case .processing:
			let cardInfo = VGSCheckoutNewPaymentCardInfo(shouldSave: viewModel.saveCardCheckboxSelected)
			viewModel.apiWorker.createFinID(with: cardInfo) {[weak self] requestResult in
				guard let strongSelf = self else {return}

				guard let service = strongSelf.paymentService else {return}
				// Trigger different callbacks with checkout state change for add card and transfer flow.
				let state: VGSAddCardFlowState
				switch strongSelf.viewModel.configuration.payoptFlow {
				case .addCard:
					state = VGSAddCardFlowState.checkoutDidFinish(.newCard(requestResult, cardInfo))
				case .transfers:
					state = VGSAddCardFlowState.checkoutTransferDidFinish(requestResult)
				}
				strongSelf.paymentService?.serviceDelegate?.checkoutServiceStateDidChange(with: state, in: service)
			}
		default:
			break
		}
	}

	/// Handles tap on close button.
	internal func closeButtonDidTap(in viewController: VGSBaseCardViewController) {
		guard let service = paymentService else {return}
		switch initialScreen {
		case .paymentOptions:
			navigationController?.popViewController(animated: true)
		case .payWithNewCard:
			paymentService?.serviceDelegate?.checkoutServiceStateDidChange(with: .cancelled, in: service)
		}
	}
}
