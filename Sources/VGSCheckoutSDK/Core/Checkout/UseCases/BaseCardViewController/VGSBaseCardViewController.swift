//
//  VGSBaseCardViewController.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Interface to notify about changes/actions in `VGSCheckoutBaseCardViewController`.
internal protocol VGSCheckoutBaseCardViewControllerDelegate: AnyObject {
	func submitButtonDidTap(in formState: VGSBaseCardViewController.FormState, viewController: VGSBaseCardViewController)
	func closeButtonDidTap(in viewController: VGSBaseCardViewController)
}

/// Base view controller that holds UI for entering card data.
internal class VGSBaseCardViewController: VGSFormViewController {

	/// An objec that acts as a view controller delegate.
	internal weak var delegate: VGSCheckoutBaseCardViewControllerDelegate?

	/// Defines form state.
	internal enum FormState {

		/// Form has invalid data.
		case invalid

		/// Form has valid data and ready for precessing.
		case valid

		/// Form is in processing state.
		case processing
	}

	// MARK: - Vars

	/// Manager for card data logic.
	internal let cardDataSectionViewModel: VGSCardDataSectionViewModel

	/// Manager for billing address logic.
	internal let addressDataSectionViewModel: VGSAddressDataSectionViewModel

	/// Main view.
	internal let addCardSectionFormView: VGSSaveCardFormView

	/// Checkout configuration type.
	internal let checkoutConfigurationType: VGSCheckoutConfigurationType

	/// `VGSCollect` object.
	fileprivate let vgsCollect: VGSCollect

	/// UI Theme.
	fileprivate let uiTheme: VGSCheckoutThemeProtocol

	/// Close bar button item.
	fileprivate var closeBarButtomItem: UIBarButtonItem?

	/// Validation bevaior, default is `.onSubmit`.
	fileprivate var validationBehavior: VGSCheckoutFormValidationBehaviour

	/// Holds the entire form state.
	var formState = FormState.invalid {
		didSet {
			switch formState {
			case .invalid:
				updateCloseBarButtonItem(true)
				addCardSectionFormView.submitButton.status = .enabled

			case .valid:
				addCardSectionFormView.billingAddressSectionView.alpha = VGSUIConstants.FormUI.formEnabledAlpha
				addCardSectionFormView.cardDetailsSectionView.alpha = VGSUIConstants.FormUI.formEnabledAlpha
				addCardSectionFormView.isUserInteractionEnabled = true
				updateCloseBarButtonItem(true)
				addCardSectionFormView.submitButton.status = .enabled
			case .processing:
				addCardSectionFormView.isUserInteractionEnabled = false
				updateCloseBarButtonItem(false)
				addCardSectionFormView.submitButton.status = .processing
				addCardSectionFormView.billingAddressSectionView.alpha = VGSUIConstants.FormUI.formProcessingAlpha
				addCardSectionFormView.cardDetailsSectionView.alpha =  VGSUIConstants.FormUI.formProcessingAlpha
			}
			delegate?.submitButtonDidTap(in: formState, viewController: self)
		}
	}

	// MARK: - Initializer

	internal init(checkoutConfigurationType: VGSCheckoutConfigurationType, vgsCollect: VGSCollect, uiTheme: VGSCheckoutThemeProtocol) {
		self.checkoutConfigurationType = checkoutConfigurationType
		self.vgsCollect = vgsCollect
		self.uiTheme = uiTheme
		self.validationBehavior = checkoutConfigurationType.formValidationBehaviour

		let formValidationHelper = VGSFormValidationHelper(fieldViews: [], validationBehaviour: self.validationBehavior)
		let autoFocusManager = VGSFieldAutofocusManager(fieldViewsManager: VGSFieldViewsManager(fieldViews: []))

		self.cardDataSectionViewModel = VGSCardDataSectionViewModel(checkoutConfigurationType: checkoutConfigurationType, vgsCollect: vgsCollect, validationBehavior: self.validationBehavior, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)

		switch checkoutConfigurationType {
		case .custom(let configuration):
			self.addressDataSectionViewModel = VGSAddressDataSectionViewModel(vgsCollect: vgsCollect, configuration: configuration, validationBehavior: self.validationBehavior, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)
			VGSCheckoutAnalyticsClient.shared.trackFormEvent(vgsCollect.formAnalyticsDetails, type: .formInit, extraData: ["config": "custom"])
		case .payoptAddCard(let configuration):
			self.addressDataSectionViewModel = VGSAddressDataSectionViewModel(vgsCollect: vgsCollect, configuration: configuration, validationBehavior: self.validationBehavior, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)
		case .payoptTransfers(let configuration):
			self.addressDataSectionViewModel = VGSAddressDataSectionViewModel(vgsCollect: vgsCollect, configuration: configuration, validationBehavior: self.validationBehavior, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager)
			VGSCheckoutAnalyticsClient.shared.trackFormEvent(vgsCollect.formAnalyticsDetails, type: .formInit, extraData: ["config": "payopt", "configType": "transfers"])
		}

		self.addCardSectionFormView = VGSSaveCardFormView(cardDetailsView: cardDataSectionViewModel.cardDetailsSectionView, billingAddressView: addressDataSectionViewModel.billingAddressFormView, viewLayoutStyle: .fullScreen, uiTheme: uiTheme)

		formValidationHelper.fieldViewsManager.appendFieldViews(self.cardDataSectionViewModel.cardDetailsSectionView.fieldViews)

		if checkoutConfigurationType.isAddressVisible {
			formValidationHelper.fieldViewsManager.appendFieldViews(self.addressDataSectionViewModel.billingAddressFormView.fieldViews)
			addressDataSectionViewModel.updateInitialPostalCodeUI()
		}

		super.init(formView: addCardSectionFormView)
	}

	internal required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	/// Extra analytics content.
	internal var extraAnalyticsContent: [String] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		setupDelegates()
		setupMainUI()
	}

	// MARK: - Helpers

	private func setupDelegates() {
		addCardSectionFormView.submitButton.addTarget(self, action: #selector(submitButtonDidTap), for: .touchUpInside)
		cardDataSectionViewModel.delegate = self
		addressDataSectionViewModel.delegate = self
	}

	private func setupMainUI() {
		view.backgroundColor = uiTheme.checkoutViewBackgroundColor
		let closeTitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_cancel_button_title")
		closeBarButtomItem = UIBarButtonItem(title: closeTitle, style: .plain, target: self, action: #selector(closeButtonDidTap))
		navigationItem.leftBarButtonItem = closeBarButtomItem
	}

	// MARK: - Helpers

	/// Handles tap on close button.
	@objc fileprivate func closeButtonDidTap() {
		VGSCheckoutAnalyticsClient.shared.trackFormEvent(vgsCollect.formAnalyticsDetails, type: .cancel)
		delegate?.closeButtonDidTap(in: self)
	}

	/// Handles tap on the submit button.
	@objc fileprivate func submitButtonDidTap() {
				let invalidFieldNames = cardDataSectionViewModel.formValidationHelper.analyticsInvalidFieldNames
		// Explicitly set payload and custom headers to analytics event content since we track beforeSubmit regardless sending API request.
		vgsCollect.trackBeforeSubmit(with: invalidFieldNames, configurationAnalytics: checkoutConfigurationType.configuration, extraContent: extraAnalyticsContent)
				switch formState {
				case .valid:
						formState = .processing
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
		navigationItem.leftBarButtonItem?.isEnabled = isEnabled
	}
}

// MARK: - VGSFormSectionPresenterDelegate

extension VGSBaseCardViewController: VGSFormSectionPresenterDelegate {
	func stateDidChange(_ state: VGSFormSectionState) {
		switch state {
		case .invalid:
			formState = .invalid
		case .valid:
			formState = .valid
		}
		updateSubmitButtonUI(with: state)
	}

	internal func updateSubmitButtonUI(with formState: VGSFormSectionState) {
		switch validationBehavior {
		case .onSubmit:
			break
		case .onFocus:
			break
		}
	}
}
