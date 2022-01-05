//
//  VGSPayWithCardViewController.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Holds UI for pay with card flow.
internal class VGSPayWithCardViewController: VGSBaseCardViewController {

	// MARK: - Vars

	// Pay with card service.
	fileprivate weak var paymentService: VGSCheckoutPaymentService?

	// View model.
	fileprivate let viewModel: VGSMultiplexingPayWithCardViewModel

	// Checkbox button.
	internal let checkboxButton: VGSCheckboxButton

	// MARK: - Initialization

	init(paymentService: VGSCheckoutPaymentService) {
		self.paymentService = paymentService
		self.viewModel = VGSPayWithCardViewModelFactory.buildAddCardViewModel(with: paymentService.checkoutConfigurationType, vgsCollect: paymentService.vgsCollect)
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

	override func setupUI() {
		super.setupUI()

		navigationItem.title = viewModel.rootNavigationTitle
		addCardSectionFormView.submitButton.title = viewModel.submitButtonTitle

		// Add checkbox button.
    if viewModel.multiplexingConfiguration.saveCardOptionEnabled {
      checkboxButton.isSelected = viewModel.saveCardCheckboxSelected
      let containerView = VGSAddCardFormViewBuilder.buildChecboxButtonContainerView()
      containerView.addContentView(checkboxButton)
      if let indexOfButton = addCardSectionFormView.backgroundStackView.arrangedSubviews.firstIndex(of: addCardSectionFormView.payButtonContainerView) {
        addCardSectionFormView.backgroundStackView.insertArrangedSubview(containerView, at: indexOfButton)
      }
      
      checkboxButton.onTap = { [weak self] in
        self?.viewModel.saveCardCheckboxSelected = self?.checkboxButton.isSelected ?? true
      }
    }
  }
}

// MARK: - VGSCheckoutBaseCardViewControllerDelegate

extension VGSPayWithCardViewController: VGSCheckoutBaseCardViewControllerDelegate {
	func submitButtonDidTap(in formState: VGSBaseCardViewController.FormState, viewController: VGSBaseCardViewController) {
		switch formState {
		case .processing:
    // TODO: handle other payment methods after save card flow implemented
      let cardInfo = VGSCheckoutNewPaymentCardInfo(shouldSave: viewModel.saveCardCheckboxSelected)
      viewModel.apiWorker.createFinIDAndSendTransfer(with: .newCard(cardInfo)){[weak self] requestResult in
				guard let strongSelf = self else {return}
				let state = VGSAddCardFlowState.requestSubmitted(requestResult)
				guard let service = strongSelf.paymentService else {return}
				strongSelf.paymentService?.serviceDelegate?.checkoutServiceStateDidChange(with: state, in: service)
			}
		default:
			break
		}
	}

	func closeButtonDidTap(in viewController: VGSBaseCardViewController) {
		guard let service = paymentService else {return}
		paymentService?.serviceDelegate?.checkoutServiceStateDidChange(with: .cancelled, in: service)
	}
}
