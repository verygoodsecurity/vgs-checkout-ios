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
				updateCloseBarButtonItem(true)
				addCardSectionFormView.saveCardButton.status = .enabled

			case .valid:
				addCardSectionFormView.isUserInteractionEnabled = true
				updateCloseBarButtonItem(true)
				addCardSectionFormView.saveCardButton.status = .enabled

				addCardSectionFormView.cardDetailsSectionView.updateSectionBlock(.cardDetails, isValid: true)
				addCardSectionFormView.billingAddressSectionView.updateSectionBlock(.addressInfo, isValid: true)
			case .processing:
				addCardSectionFormView.isUserInteractionEnabled = false
				updateCloseBarButtonItem(false)
				addCardSectionFormView.saveCardButton.status = .processing
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

	/// Close bar button item.
	internal var closeBarButtomItem: UIBarButtonItem?
  
	// MARK: - Initialization

  init(paymentInstrument: VGSPaymentInstrument, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol) {
		VGSCollectLogger.shared.configuration.isNetworkDebugEnabled = true
		VGSCollectLogger.shared.configuration.level = .info

		self.paymentInstrument = paymentInstrument
		self.vgsCollect = vgsCollect
		self.uiTheme = uiTheme

		let formValidationHelper = VGSFormValidationHelper(fieldViews: [], validationBehaviour: .onSubmit)
		let autoFocusManager = VGSFieldAutofocusManager(fieldViewsManager: VGSFieldViewsManager(fieldViews: []))

		self.cardDataSectionViewModel = VGSCardDataSectionViewModel(paymentInstrument: paymentInstrument, vgsCollect: vgsCollect, validationBehavior: .onSubmit, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)

    switch paymentInstrument {
    case .vault(let configuration):
      self.addressDataSectionViewModel = VGSAddressDataSectionViewModel(vgsCollect: vgsCollect, configuration: configuration, validationBehavior: .onSubmit, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)
    case .multiplexing(let configuration):
      self.addressDataSectionViewModel = VGSAddressDataSectionViewModel(vgsCollect: vgsCollect, configuration: configuration, validationBehavior: .onSubmit, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)
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

		// Initally pay button is always enabled.
		self.addCardSectionFormView.saveCardButton.status = .enabled
	}

	internal func buildCheckoutViewController() -> UIViewController {
		let viewController = VGSFormViewController(formView: addCardSectionFormView)
		addCardSectionFormView.saveCardButton.addTarget(self, action: #selector(payDidTap), for: .touchUpInside)
		cardDataSectionViewModel.delegate = self
		addressDataSectionViewModel.delegate = self

		viewController.view.backgroundColor = uiTheme.checkoutViewBackgroundColor

		let navigationController = UINavigationController(rootViewController: viewController)
		VGSAddCardNavigationBarBuilder.setupNavigationBarTitle(in: viewController)

		let closeTitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_cancel_button_title")
		closeBarButtomItem = UIBarButtonItem(title: closeTitle, style: .plain, target: self, action: #selector(closeButtonDidTap))

		viewController.navigationItem.leftBarButtonItem = closeBarButtomItem

		return navigationController
	}

	// MARK: - Helpers

	/// Handles tap on close button.
	@objc fileprivate func closeButtonDidTap() {
		switch paymentInstrument {
		case .vault:
			delegate?.addCardFlowDidChange(with: .cancelled, in: self)
		case .multiplexing:
			delegate?.addCardFlowDidChange(with: .cancelled, in: self)
		}
	}

	@objc fileprivate func payDidTap() {
        switch state {
        case .valid:
            state = .processing
        case .invalid:
            showFormValidationErrors()
        default:
            return
        }
	}
    
    private func showFormValidationErrors() {
        cardDataSectionViewModel.formValidationHelper.updateFormSectionViewOnSubmit()
        addressDataSectionViewModel.formValidationHelper.updateFormSectionViewOnSubmit()
    }

	/// Updates `.isEnabled` state for left bar button item if checkout is dislayed in viewController.
	/// - Parameter isEnabled: `Bool` object, indicates `isEbabled` state for close left bar button item.
	private func updateCloseBarButtonItem(_ isEnabled: Bool) {
		if let viewController = self.addCardSectionFormView.vgsParentViewController, let leftItem = viewController.navigationItem.leftBarButtonItem {
			leftItem.isEnabled = isEnabled
		}
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
