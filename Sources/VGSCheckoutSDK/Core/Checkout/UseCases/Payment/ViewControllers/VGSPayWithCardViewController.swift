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
	fileprivate let initialScreen: VGSCheckoutPayoptTransfersService.InitialScreen

	// MARK: - Vars

	// Pay with card service.
	fileprivate weak var paymentService: VGSCheckoutPayoptTransfersService?

	// View model.
	fileprivate let viewModel: VGSPayoptTransfersPayWithNewCardViewModel

	// Checkbox button.
	internal let checkboxButton: VGSCheckboxButton

	// MARK: - Initialization

	init(paymentService: VGSCheckoutPayoptTransfersService, initialScreen: VGSCheckoutPayoptTransfersService.InitialScreen) {
		self.paymentService = paymentService
		self.initialScreen = initialScreen
		self.viewModel = VGSPayWithCardViewModelFactory.buildAddCardViewModel(with: paymentService.checkoutConfigurationType, vgsCollect: paymentService.vgsCollect, checkoutService: paymentService)
		self.checkboxButton = VGSCheckboxButton(text: VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_pay_with_card_save_card_checkbox_hint"), theme: paymentService.uiTheme)
		super.init(checkoutConfigurationType: paymentService.checkoutConfigurationType, vgsCollect: paymentService.vgsCollect, uiTheme: paymentService.uiTheme)
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
    if viewModel.configuration.saveCardOptionEnabled {
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
      viewModel.apiWorker.createFinIDAndSendTransfer(with: cardInfo) {[weak self] requestResult in
				guard let strongSelf = self else {return}
				let state = VGSAddCardFlowState.requestSubmitted(requestResult)
				guard let service = strongSelf.paymentService else {return}
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
