//
//  VGSPaymentOptionsViewController.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Holds UI and view model for payment options screen.
internal class VGSPaymentOptionsViewController: UIViewController {

	/// View model.
	fileprivate let viewModel: VGSPaymentOptionsViewModel

	/// Main view.
	fileprivate let mainView: VGSPaymentOptionsMainView

	/// UI theme.
	fileprivate let uiTheme: VGSCheckoutThemeProtocol

	// Pay with card service.
	fileprivate weak var paymentService: VGSCheckoutPaymentService?

	/// Close bar button item.
	fileprivate var closeBarButtomItem: UIBarButtonItem?

	// MARK: - Initialization

	init(paymentService: VGSCheckoutPaymentService) {
		self.paymentService = paymentService
		self.viewModel = VGSPayWithCardViewModelFactory.buildPaymentOptionsViewModel(with: paymentService.checkoutConfigurationType, vgsCollect: paymentService.vgsCollect)
		self.mainView = VGSPaymentOptionsMainView(uiTheme: paymentService.uiTheme)
		self.uiTheme = paymentService.uiTheme

		super.init(nibName: nil, bundle: nil)
	}

	/// no:doc
	internal required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	/// no:doc
	override func viewDidLoad() {
		super.viewDidLoad()

		mainView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(mainView)
		mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
		mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
		mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

		mainView.submitButton.title = viewModel.submitButtonTitle
		mainView.submitButton.status = .enabled
		title = viewModel.rootNavigationTitle

		view.backgroundColor = uiTheme.checkoutViewBackgroundColor
		let closeTitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_cancel_button_title")
		closeBarButtomItem = UIBarButtonItem(title: closeTitle, style: .plain, target: self, action: #selector(closeButtonDidTap))
		navigationItem.leftBarButtonItem = closeBarButtomItem

		mainView.backgroundColor = .yellow
	}

	/// Handles tap on close button.
	@objc fileprivate func closeButtonDidTap() {
//		VGSCheckoutAnalyticsClient.shared.trackFormEvent(vgsCollect.formAnalyticsDetails, type: .cancel)
		guard let service = paymentService else {return}
		paymentService?.serviceDelegate?.checkoutServiceStateDidChange(with: .cancelled, in: service)
	}
}
