//
//  VGSAddCardUseCaseManager.swift
//  VGSCheckout

import Foundation
#if os(iOS)
import UIKit
#endif

internal enum VGSAddCardFlowState {
	case requestSubmitted(_ result: VGSCheckoutRequestResult)
	case cancelled
}

internal protocol VGSAddCardUseCaseManagerDelegate: AnyObject {
	func addCardFlowDidChange(with state: VGSAddCardFlowState, in useCaseManager: VGSAddCardUseCaseManager)
}

/// Handle add card form logic.
internal class VGSAddCardUseCaseManager: NSObject {

	internal weak var delegate: VGSAddCardUseCaseManagerDelegate?
  
	enum FormState {
		case invalid
		case valid
		case processing
	}

	var state = FormState.invalid {
		didSet {
			switch state {
			case .invalid:
				addCardSectionFormView.payButton.status = .disabled
			case .valid:
				addCardSectionFormView.payButton.status = .enabled

				addCardSectionFormView.isUserInteractionEnabled = true
				addCardSectionFormView.headerBarView.closeButton?.isEnabled = true
				addCardSectionFormView.payButton.status = .enabled

				addCardSectionFormView.cardDetailsSectionView.updateSectionBlock(.cardDetails, isValid: true)
				addCardSectionFormView.billingAddressSectionView.updateSectionBlock(.addressInfo, isValid: true)
			case .processing:
				addCardSectionFormView.isUserInteractionEnabled = false
				addCardSectionFormView.headerBarView.closeButton?.isEnabled = false
				addCardSectionFormView.payButton.status = .processing
				addCardSectionFormView.cardDetailsSectionView.updateUIForProcessingState()

				apiWorker.sendData {[weak self] requestResult in
					guard let strongSelf = self else {return}
					let state = VGSAddCardFlowState.requestSubmitted(requestResult)
					strongSelf.delegate?.addCardFlowDidChange(with: state, in: strongSelf)
				}
			}
		}
	}
 
	/// Payment instrument.
	internal let paymentInstrument: VGSPaymentInstrument

	/// Manager for card data logic.
	internal let cardDataSectionViewModel: VGSCardDataSectionViewModel

	/// Manager for billing address logic.
	internal let addressDataSectionViewModel: VGSAddressDataSectionViewModel

	/// Add card main view.
	internal let addCardSectionFormView: VGSAddCardFormView

	/// `VGSCollect` object.
	internal let vgsCollect: VGSCollect

	/// API worker, sends data with current payment instrument.
	internal let apiWorker: VGSAddCreditCardAPIWorkerProtocol

	/// UI Theme.
	internal let uiTheme: VGSCheckoutThemeProtocol
  
	// MARK: - Initialization

  init(paymentInstrument: VGSPaymentInstrument, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol) {
		VGSCollectLogger.shared.configuration.isNetworkDebugEnabled = true
		VGSCollectLogger.shared.configuration.level = .info

		self.paymentInstrument = paymentInstrument
		self.vgsCollect = vgsCollect
		self.uiTheme = uiTheme

		let formValidationHelper = VGSFormValidationHelper(fieldViews: [], validationBehaviour: .onFocus)
		let autoFocusManager = VGSFieldAutofocusManager(fieldViewsManager: VGSFieldViewsManager(fieldViews: []))

		self.cardDataSectionViewModel = VGSCardDataSectionViewModel(paymentInstrument: paymentInstrument, vgsCollect: vgsCollect, validationBehavior: .onFocus, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)

    switch paymentInstrument {
    case .vault(let configuration):
      self.addressDataSectionViewModel = VGSAddressDataSectionViewModel(vgsCollect: vgsCollect, configuration: configuration, validationBehavior: .onFocus, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)
    case .multiplexing(let configuration):
      self.addressDataSectionViewModel = VGSAddressDataSectionViewModel(vgsCollect: vgsCollect, configuration: configuration, validationBehavior: .onFocus, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)
    }

		self.addCardSectionFormView = VGSAddCardFormView(cardDetailsView: cardDataSectionViewModel.cardDetailsSectionView, billingAddressView: addressDataSectionViewModel.billingAddressFormView, viewLayoutStyle: .fullScreen, uiTheme: uiTheme)

		// TODO: - move form validation setup to a separate func?

		formValidationHelper.fieldViewsManager.appendFieldViews(self.cardDataSectionViewModel.cardDetailsSectionView.fieldViews)
		formValidationHelper.fieldViewsManager.appendFormSectionViews([cardDataSectionViewModel.cardDetailsSectionView])

		switch paymentInstrument {
		case .vault(let vaultConfiguration):
			switch vaultConfiguration.billingAddressVisibility {
			case .visible:
				formValidationHelper.fieldViewsManager.appendFieldViews(self.addressDataSectionViewModel.billingAddressFormView.fieldViews)
				formValidationHelper.fieldViewsManager.appendFormSectionViews([ addressDataSectionViewModel.billingAddressFormView])
			case .hidden:
				break
			}
		case .multiplexing:
			// Always display address section for multiplexing.
			formValidationHelper.fieldViewsManager.appendFieldViews(self.addressDataSectionViewModel.billingAddressFormView.fieldViews)
			formValidationHelper.fieldViewsManager.appendFormSectionViews([ addressDataSectionViewModel.billingAddressFormView])
		}

		self.apiWorker = VGSAddCardAPIWorkerFactory.buildAPIWorker(for: paymentInstrument, vgsCollect: vgsCollect)

		super.init()
		self.addCardSectionFormView.payButton.status = .disabled
	}

	internal func buildCheckoutViewController() -> UIViewController {

		addCardSectionFormView.headerBarView.delegate = self
		let viewController = VGSFormViewController(formView: addCardSectionFormView)

		addCardSectionFormView.payButton.addTarget(self, action: #selector(payDidTap), for: .touchUpInside)
		cardDataSectionViewModel.delegate = self
		addressDataSectionViewModel.delegate = self

		viewController.view.backgroundColor = uiTheme.checkoutViewBackgroundColor

		return viewController
	}

	// MARK: - Helpers

	@objc fileprivate func payDidTap() {
		state = .processing
	}
}

// MARK: - VGSHeaderBarViewDelegate

extension VGSAddCardUseCaseManager: VGSHeaderBarViewDelegate {
	func buttonDidTap(in header: VGSHeaderBarView) {
		switch paymentInstrument {
		case .vault:
			delegate?.addCardFlowDidChange(with: .cancelled, in: self)
		case .multiplexing:
			delegate?.addCardFlowDidChange(with: .cancelled, in: self)
		}
	}
}

// MARK: - VGSFormSectionPresenterDelegate

extension VGSAddCardUseCaseManager: VGSFormSectionPresenterDelegate {
	func stateDidChange(_ state: VGSFormSectionState) {
		switch state {
		case .invalid:
			self.state = .invalid
		case .valid:
			self.state = .valid
		}
	}
}
