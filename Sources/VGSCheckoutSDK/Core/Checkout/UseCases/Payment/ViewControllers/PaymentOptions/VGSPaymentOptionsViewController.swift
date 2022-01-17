//
//  VGSPaymentOptionsViewController.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Holds UI and view model for payment options screen.
internal class VGSPaymentOptionsViewController: UIViewController {

	/// Defines screen state.
	internal enum ScreenState {

		/// Initial screen state.
		case initial

		/// Processing state.
		case processing
	}

	/// View model.
	fileprivate let viewModel: VGSPaymentOptionsViewModel

	/// Main view.
	fileprivate let mainView: VGSPaymentOptionsMainView

	/// UI theme.
	fileprivate let uiTheme: VGSCheckoutThemeProtocol

	// Pay with card service.
	fileprivate weak var paymentService: VGSCheckoutPayoptTransfersService?

	/// Close bar button item.
	fileprivate var closeBarButtomItem: UIBarButtonItem?

	/// Screen state.
	fileprivate var screenState: ScreenState = .initial {
		didSet {
			switch screenState {
			case .initial:
				break
			case .processing:
				guard let cardInfo = viewModel.selectedPaymentCardInfo else {return}
				mainView.isUserInteractionEnabled = false
				closeBarButtomItem?.isEnabled = false
				mainView.submitButton.status = .processing
				mainView.alpha = VGSUIConstants.FormUI.formProcessingAlpha
				let info = VGSCheckoutPaymentFlowInfo(paymentMethod: .savedCard(cardInfo))
				viewModel.apiWorker.sendTransfer(with: info, finId: cardInfo.id, completion: {[weak self] requestResult in
					guard let strongSelf = self else {return}
					let state = VGSAddCardFlowState.requestSubmitted(requestResult)
					guard let service = strongSelf.paymentService else {return}
					strongSelf.paymentService?.serviceDelegate?.checkoutServiceStateDidChange(with: state, in: service)
				})
			}
		}
	}

	// MARK: - Initialization

	/// Initializer
	/// - Parameter paymentService: `VGSCheckoutPayoptTransfersService` object, pay opt  checkout transfer service.
	init(paymentService: VGSCheckoutPayoptTransfersService) {
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

		view.backgroundColor = uiTheme.checkoutViewBackgroundColor
		title = viewModel.rootNavigationTitle

		setupMainView()
		setupSubmitButton()
		setupCloseButton()
		setupTableView()

		mainView.tableView.reloadData()
	}

	// MARK: - Helpers

	/// Main view setup.
	private func setupMainView() {
		mainView.translatesAutoresizingMaskIntoConstraints = false
		mainView.backgroundColor = uiTheme.checkoutViewBackgroundColor
		view.addSubview(mainView)
		mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
		mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
		mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
	}

	/// Table view setup.
	private func setupTableView() {
		mainView.tableView.backgroundColor = .clear
		mainView.tableView.register(VGSPaymentOptionCardTableViewCell.self, forCellReuseIdentifier: VGSPaymentOptionCardTableViewCell.cellIdentifier)
		mainView.tableView.register(VGSPaymentOptionNewCardTableViewCell.self, forCellReuseIdentifier: VGSPaymentOptionNewCardTableViewCell.cellIdentifier)
		mainView.tableView.dataSource = self
		mainView.tableView.delegate = self
	}

	/// Left close bar button item setup.
	private func setupCloseButton() {
		let closeTitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_cancel_button_title")
		closeBarButtomItem = UIBarButtonItem(title: closeTitle, style: .plain, target: self, action: #selector(closeButtonDidTap))
		navigationItem.leftBarButtonItem = closeBarButtomItem
	}

	/// Submit button setup.
	private func setupSubmitButton() {
		mainView.submitButton.delegate = self
		mainView.submitButton.title = viewModel.submitButtonTitle
		mainView.submitButton.status = .enabled
		mainView.submitButton.addTarget(self, action: #selector(submitButtonDidTap), for: .touchUpInside)
	}

	/// Navigates to new card screen.
	fileprivate func navigateToNewCardScreen() {
		guard let service = paymentService else {return}
		let vc = VGSPayWithCardViewController(paymentService: service, initialScreen: .paymentOptions)
		navigationController?.pushViewController(vc, animated: true)
	}

	// MARK: - Actions

	/// Handles tap on close button.
	@objc fileprivate func closeButtonDidTap() {
		guard let service = paymentService else {return}
		VGSCheckoutAnalyticsClient.shared.trackFormEvent(service.vgsCollect.formAnalyticsDetails, type: .cancel)
		paymentService?.serviceDelegate?.checkoutServiceStateDidChange(with: .cancelled, in: service)
	}

	/// Handles tap on submit button.
	@objc fileprivate func submitButtonDidTap() {
		screenState = .processing
	}
}

// MARK: - UITableViewDataSource

/// no:doc
extension VGSPaymentOptionsViewController: UITableViewDataSource {

	/// no:doc
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.paymentOptions.count
	}

	/// no:doc
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let option = viewModel.paymentOptions[indexPath.row]
		switch option {
		case .savedCard(let card):
			let cell: VGSPaymentOptionCardTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
			cell.configure(with: card.paymentOptionCellViewModel, uiTheme: uiTheme)

			return cell
		case .newCard:
			let cell: VGSPaymentOptionNewCardTableViewCell = tableView.dequeue(cellForRowAt: indexPath)
			cell.configure(with: uiTheme)

			return cell
		}
	}
}

// MARK: - UITableViewDelegate

/// no:doc
extension VGSPaymentOptionsViewController: UITableViewDelegate {

	/// no:doc
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let index = indexPath.row
		let paymentOption = viewModel.paymentOptions[index]

		switch paymentOption {
		case.savedCard(var savedCard):
			guard let lastSelectedId = viewModel.previsouslySelectedID else {return}

			/// Ignore same card selection.
			if savedCard.id == lastSelectedId {
				return
			} else {
				// Select new card.
				savedCard.isSelected = true
				viewModel.paymentOptions[index] = .savedCard(savedCard)

				// Remove selection from the previous card
				for i in 0..<viewModel.paymentOptions.count {
					let option = viewModel.paymentOptions[i]
					switch option {
					case .savedCard(var card):
						if card.id == lastSelectedId {
							card.isSelected = false
							viewModel.paymentOptions[i] = .savedCard(card)
						}
					case .newCard:
						continue
					}
				}
			}

			// Save new selected id.
			viewModel.previsouslySelectedID = savedCard.id
			tableView.reloadData()
		case .newCard:
			navigateToNewCardScreen()
		}
	}
}

// MARK: - VGSSubmitButtonDelegateProtocol

/// no:doc
extension VGSPaymentOptionsViewController: VGSSubmitButtonDelegateProtocol {

	/// no:doc
	func statusDidChange(in button: VGSSubmitButton) {
		mainView.submitButton.updateUI(with: uiTheme)
	}
}