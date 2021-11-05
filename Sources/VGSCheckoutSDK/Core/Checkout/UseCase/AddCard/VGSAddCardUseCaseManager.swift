//
//  VGSAddCardUseCaseManager.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Defines Add Card use case states.
internal enum VGSAddCardFlowState {

	/**
	 Request was sumitted with result.

	 - Parameters:
			- result: request result of checkout save card flow.
	*/
	case requestSubmitted(_ result: VGSCheckoutRequestResult)

	/// User cancelled checkout flow.
	case cancelled
}

/// A set of methods to notify about changes in `Save Card` form.
internal protocol VGSAddCardUseCaseManagerDelegate: AnyObject {
	func addCardFlowDidChange(with state: VGSAddCardFlowState, in useCaseManager: VGSAddCardUseCaseManager)
}

/// Handles `Add card` use case logic.
internal class VGSAddCardUseCaseManager: NSObject {

	/// Delegate object.
	internal weak var delegate: VGSAddCardUseCaseManagerDelegate?

	/// Defines form state.
	enum FormState {

		/// Form has invalid data.
		case invalid

		/// Form has valid data and ready for precessing.
		case valid

		/// Payment processing is in progress.
		case processing
	}

	/// Holds the entire form state.
	var state = FormState.invalid {
		didSet {
			switch state {
			case .invalid:
				updateCloseBarButtonItem(true)
				addCardSectionFormView.saveCardButton.status = .enabled

			case .valid:
				addCardSectionFormView.billingAddressSectionView.alpha = VGSUIConstants.FormUI.formEnabledAlpha
				addCardSectionFormView.cardDetailsSectionView.alpha = VGSUIConstants.FormUI.formEnabledAlpha
				addCardSectionFormView.isUserInteractionEnabled = true
				updateCloseBarButtonItem(true)
				addCardSectionFormView.saveCardButton.status = .enabled
			case .processing:
				addCardSectionFormView.isUserInteractionEnabled = false
				updateCloseBarButtonItem(false)
				addCardSectionFormView.saveCardButton.status = .processing
				addCardSectionFormView.billingAddressSectionView.alpha = VGSUIConstants.FormUI.formProcessingAlpha
				addCardSectionFormView.cardDetailsSectionView.alpha =  VGSUIConstants.FormUI.formProcessingAlpha

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

	/// Validation bevaior, default is `.onSubmit`.
	internal var validationBehavior: VGSCheckoutFormValidationBehaviour = .onSubmit
  
	// MARK: - Initialization

	init(paymentInstrument: VGSPaymentInstrument, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol) {
		self.paymentInstrument = paymentInstrument
		self.vgsCollect = vgsCollect
		self.uiTheme = uiTheme

		switch paymentInstrument {
		case .vault(let config):
			self.validationBehavior = config.formValidationBehaviour
		case .multiplexing(let config):
			break
			// FIXME - add validation behavior to multiplexing.
			//self.validationBehavior = config.formValidationBehaviour
		}

		let formValidationHelper = VGSFormValidationHelper(fieldViews: [], validationBehaviour: self.validationBehavior)
		let autoFocusManager = VGSFieldAutofocusManager(fieldViewsManager: VGSFieldViewsManager(fieldViews: []))

		self.cardDataSectionViewModel = VGSCardDataSectionViewModel(paymentInstrument: paymentInstrument, vgsCollect: vgsCollect, validationBehavior: self.validationBehavior, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)

    switch paymentInstrument {
    case .vault(let configuration):
			self.addressDataSectionViewModel = VGSAddressDataSectionViewModel(vgsCollect: vgsCollect, configuration: configuration, validationBehavior: self.validationBehavior, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)
			VGSCheckoutAnalyticsClient.shared.trackFormEvent(vgsCollect.formAnalyticsDetails, type: .formInit, extraData: ["config": "custom"])
    case .multiplexing(let configuration):
			self.addressDataSectionViewModel = VGSAddressDataSectionViewModel(vgsCollect: vgsCollect, configuration: configuration, validationBehavior: self.validationBehavior, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)
			VGSCheckoutAnalyticsClient.shared.trackFormEvent(vgsCollect.formAnalyticsDetails, type: .formInit, extraData: ["config": "multiplexing"])
    }

		self.addCardSectionFormView = VGSAddCardFormView(cardDetailsView: cardDataSectionViewModel.cardDetailsSectionView, billingAddressView: addressDataSectionViewModel.billingAddressFormView, viewLayoutStyle: .fullScreen, uiTheme: uiTheme)

		formValidationHelper.fieldViewsManager.appendFieldViews(self.cardDataSectionViewModel.cardDetailsSectionView.fieldViews)

		switch paymentInstrument {
		case .vault(let vaultConfiguration):
			switch vaultConfiguration.billingAddressVisibility {
			case .visible:
				formValidationHelper.fieldViewsManager.appendFieldViews(self.addressDataSectionViewModel.billingAddressFormView.fieldViews)
				addressDataSectionViewModel.updateInitialPostalCodeUI()
			case .hidden:
				break
			}
		case .multiplexing:
			// Always display address section for multiplexing.
			formValidationHelper.fieldViewsManager.appendFieldViews(self.addressDataSectionViewModel.billingAddressFormView.fieldViews)
			addressDataSectionViewModel.updateInitialPostalCodeUI()
		}

		self.apiWorker = VGSAddCardAPIWorkerFactory.buildAPIWorker(for: paymentInstrument, vgsCollect: vgsCollect)

		super.init()

		switch self.validationBehavior {
			case .onSubmit:
				// Initally pay button is always enabled.
				self.addCardSectionFormView.saveCardButton.status = .enabled
			case .onEdit:
				// Initally pay button is disabled.
				self.addCardSectionFormView.saveCardButton.status = .disabled
		}
	}

	/// Builds view controller for save card flow.
	/// - Returns: `UIViewController` object, view controller with save card form.
	internal func buildCheckoutViewController() -> UIViewController {
		let viewController = VGSFormViewController(formView: addCardSectionFormView)
		addCardSectionFormView.saveCardButton.addTarget(self, action: #selector(saveCardDidTap), for: .touchUpInside)
		cardDataSectionViewModel.delegate = self
		addressDataSectionViewModel.delegate = self

		viewController.view.backgroundColor = uiTheme.checkoutViewBackgroundColor

		let navigationController = UINavigationController(rootViewController: viewController)
		viewController.navigationItem.title = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_add_card_navigation_bar_title")

		let closeTitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_cancel_button_title")
		closeBarButtomItem = UIBarButtonItem(title: closeTitle, style: .plain, target: self, action: #selector(closeButtonDidTap))

		viewController.navigationItem.leftBarButtonItem = closeBarButtomItem

		return navigationController
	}

	// MARK: - Helpers

	/// Handles tap on close button.
	@objc fileprivate func closeButtonDidTap() {
		VGSCheckoutAnalyticsClient.shared.trackFormEvent(vgsCollect.formAnalyticsDetails, type: .cancel)

		switch paymentInstrument {
		case .vault:
			delegate?.addCardFlowDidChange(with: .cancelled, in: self)
		case .multiplexing:
			delegate?.addCardFlowDidChange(with: .cancelled, in: self)
		}
	}

	/// Handles tap on the save card button.
	@objc fileprivate func saveCardDidTap() {
				let invalidFieldNames = cardDataSectionViewModel.formValidationHelper.analyticsInvalidFieldNames
		// Explicitly set payload and custom headers to analytics event content since we track beforeSubmit regardless sending API request.
    vgsCollect.trackBeforeSubmit(with: invalidFieldNames, configurationAnalytics: paymentInstrument.configuration)
        switch state {
        case .valid:
            state = .processing
        case .invalid:
            showFormValidationErrors()
        default:
            return
        }
	}

	/// Displays all form validation errors.
	private func showFormValidationErrors() {
		cardDataSectionViewModel.formValidationHelper.updateFormSectionViewOnSubmit()
		addressDataSectionViewModel.formValidationHelper.updateFormSectionViewOnSubmit()
		if let firstInvalidField = cardDataSectionViewModel.formValidationHelper.fieldViewsWithValidationErrors.first {
			let visibleRect = firstInvalidField.placeholderView.convert(firstInvalidField.placeholderView.frame, to: addCardSectionFormView.scrollView)
			addCardSectionFormView.scrollView.scrollRectToVisible(visibleRect, animated: true)
		}
	}

	/// Updates `.isEnabled` state for left bar button item if checkout is dislayed in viewController.
	/// - Parameter isEnabled: `Bool` object, indicates `isEbabled` state for close left bar button item.
	private func updateCloseBarButtonItem(_ isEnabled: Bool) {
		if let viewController = self.addCardSectionFormView.vgsParentViewController, let leftItem = viewController.navigationItem.leftBarButtonItem {
			leftItem.isEnabled = isEnabled
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
		updateSubmitButtonUI(with: state)
	}

	internal func updateSubmitButtonUI(with formState: VGSFormSectionState) {
		switch validationBehavior {
		case .onSubmit:
			break
		case .onEdit:
			switch formState {
			case .invalid:
				addCardSectionFormView.saveCardButton.status = .disabled
			case .valid:
				addCardSectionFormView.saveCardButton.status = .enabled
			}
		}
	}
}
