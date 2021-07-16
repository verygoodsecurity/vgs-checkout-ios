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
			case .processing:
				addCardSectionFormView.isUserInteractionEnabled = false
				addCardSectionFormView.headerBarView.closeButton?.isEnabled = false
				addCardSectionFormView.payButton.status = .processing
				addCardSectionFormView.cardDetailsView.updateUIForProcessingState()

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
	internal let addCardSectionFormView: VGSAddCardSectionFormView

	/// `VGSCollect` object.
	internal let vgsCollect: VGSCollect

	/// API worker, sends data with current payment instrument.
	internal let apiWorker: VGSAddCreditCardAPIWorkerProtocol
  
	// MARK: - Initialization

  init(paymentInstrument: VGSPaymentInstrument, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol) {
		VGSCollectLogger.shared.configuration.isNetworkDebugEnabled = true
		VGSCollectLogger.shared.configuration.level = .info

		self.paymentInstrument = paymentInstrument
		self.vgsCollect = vgsCollect

		let formValidationHelper = VGSFormValidationHelper(formItems: [], validationBehaviour: .onFocus)
		let autoFocusManager = VGSFormAutofocusManager(formItemsManager: VGSFormItemsManager(formItems: []))

		self.cardDataSectionViewModel = VGSCardDataSectionViewModel(paymentInstrument: paymentInstrument, vgsCollect: vgsCollect, validationBehavior: .onFocus, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)

		self.addressDataSectionViewModel = VGSAddressDataSectionViewModel(paymentInstrument: paymentInstrument, vgsCollect: vgsCollect, validationBehavior: .onFocus, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)

		self.addCardSectionFormView = VGSAddCardSectionFormView(paymentInstrument: paymentInstrument, cardDetailsView: cardDataSectionViewModel.cardFormView, billingAddressView: addressDataSectionViewModel.billingAddressFormView, viewLayoutStyle: .fullScreen, uiTheme: uiTheme)


		formValidationHelper.formItemsManager.appendFormItems(self.cardDataSectionViewModel.cardFormView.formItems)
		formValidationHelper.formItemsManager.appendFormItems(self.addressDataSectionViewModel.billingAddressFormView.formItems)

		formValidationHelper.formItemsManager.appendFormSectionViews([cardDataSectionViewModel.cardFormView, addressDataSectionViewModel.billingAddressFormView])

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

// MARK: - VGSFormItemControllerDelegate

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
