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
		case processingTransfer

		/// Editing saved cards.
		case editingSavedCards

		/// A boolean flag, `true` if current state is editing saved cards.
		var isEditingSavedCard: Bool {
			switch self {
			case .editingSavedCards:
				return true
			default:
				return false
			}
		}
	}

	/// Close button title.
	fileprivate let closeTitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_cancel_button_title")

	/// Edit button title.
	fileprivate let editTitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_payment_options_edit_cards_button_title")

	/// View model.
	fileprivate let viewModel: VGSPaymentOptionsViewModel

	/// Main view.
	fileprivate let mainView: VGSPaymentOptionsMainView

	/// UI theme.
	fileprivate let uiTheme: VGSCheckoutThemeProtocol

	// Pay with card service.
	fileprivate weak var paymentService: VGSPayoptAddCardCheckoutService?

	/// Close bar button item.
	fileprivate lazy var closeBarButtomItem: UIBarButtonItem = {
		let item = UIBarButtonItem(title: closeTitle, style: .plain, target: self, action: #selector(closeButtonDidTap))

		return item
	}()

	/// Edit cards bar button item.
	fileprivate lazy var editCardsBarButtomItem: UIBarButtonItem = {
		let item = UIBarButtonItem(title: editTitle, style: .done, target: self, action: #selector(editCardsButtonDidTap))

		return item
	}()

	/// Screen state.
	fileprivate var screenState: ScreenState = .initial {
		didSet {
			switch screenState {
			case .initial:
				editCardsBarButtomItem.title = editTitle
				// Restore selection from the previous card if needed.
				viewModel.handleCancelEditSavedCardsTap()
				mainView.submitButton.status = .enabled
			case .processingTransfer:
				guard let cardInfo = viewModel.selectedPaymentCardInfo else {return}
				mainView.isUserInteractionEnabled = false
				closeBarButtomItem.isEnabled = false
				editCardsBarButtomItem.isEnabled = false
				mainView.submitButton.status = .processing
				mainView.alpha = VGSUIConstants.FormUI.formProcessingAlpha
				//				let info = VGSCheckoutPaymentResultInfo(paymentMethod: .savedCard(cardInfo))
				//				viewModel.apiWorker.sendTransfer(with: info, finId: cardInfo.id, completion: {[weak self] requestResult in
				//					guard let strongSelf = self else {return}
				//					let state = VGSAddCardFlowState.requestSubmitted(requestResult)
				//					guard let service = strongSelf.paymentService else {return}
				//					strongSelf.paymentService?.serviceDelegate?.checkoutServiceStateDidChange(with: state, in: service)
				//				})
			case .editingSavedCards:
				mainView.submitButton.status = .disabled
				editCardsBarButtomItem.title = closeTitle
				viewModel.handleEditModeTap()
			}
		}
	}

	// MARK: - Initialization

	/// Initializer
	/// - Parameter paymentService: `VGSSaveCardCheckoutService` object, pay opt  checkout transfer service.
	init(paymentService: VGSPayoptAddCardCheckoutService) {
		self.paymentService = paymentService
		self.viewModel = VGSPayoptTransfersViewModelFactory.buildPaymentOptionsViewModel(with: paymentService)
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

		viewModel.delegate = self
		view.backgroundColor = uiTheme.checkoutViewBackgroundColor
		title = viewModel.rootNavigationTitle
		navigationItem.leftBarButtonItem = closeBarButtomItem
		navigationItem.rightBarButtonItem = editCardsBarButtomItem

		setupMainView()
		setupSubmitButton()
		setupTableView()

		mainView.tableView.reloadData()
	}

	// MARK: - Helpers

	/// Main view setup.
	private func setupMainView() {
		mainView.translatesAutoresizingMaskIntoConstraints = false
		mainView.backgroundColor = uiTheme.checkoutViewBackgroundColor
		view.addSubview(mainView)
		mainView.checkout_constraintViewToSafeAreaLayoutGuideEdges()
	}

	/// Table view setup.
	private func setupTableView() {
		mainView.tableView.register(VGSPaymentOptionCardTableViewCell.self, forCellReuseIdentifier: VGSPaymentOptionCardTableViewCell.cellIdentifier)
		mainView.tableView.register(VGSPaymentOptionNewCardTableViewCell.self, forCellReuseIdentifier: VGSPaymentOptionNewCardTableViewCell.cellIdentifier)
		mainView.tableView.dataSource = self
		mainView.tableView.delegate = self
	}

	/// Submit button setup.
	private func setupSubmitButton() {
		mainView.submitButton.delegate = self
		mainView.submitButton.title = viewModel.submitButtonTitle
		mainView.submitButton.status = .enabled
		mainView.submitButton.addTarget(self, action: #selector(submitButtonDidTap), for: .touchUpInside)
	}

	/// Navigates to pay with new card screen.
	fileprivate func navigateToPayWithNewCardScreen() {
		guard let service = paymentService else {return}
//		let saveCardViewController = VGSSaveCardViewController(saveCardService: service)
//		navigationController?.pushViewController(saveCardViewController, animated: true)
	}

	// MARK: - Actions

	/// Handles tap on close button.
	@objc fileprivate func closeButtonDidTap() {
		guard let service = paymentService else {return}
		VGSCheckoutAnalyticsClient.shared.trackFormEvent(service.vgsCollect.formAnalyticsDetails, type: .cancel)
		paymentService?.serviceDelegate?.checkoutServiceStateDidChange(with: .cancelled, in: service)
	}

	/// Handles tap on edit cards button.
	@objc fileprivate func editCardsButtonDidTap() {
		if screenState.isEditingSavedCard {
			screenState = .initial
		} else {
			screenState = .editingSavedCards
		}
	}

	/// Handles tap on submit button.
	@objc fileprivate func submitButtonDidTap() {
		screenState = .processingTransfer
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
			cell.configure(with: card.paymentOptionCellViewModel, uiTheme: uiTheme, isEditing: screenState.isEditingSavedCard)
			cell.delegate = self

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
		viewModel.handlePaymentOptionTap(at: index)
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

// MARK: - VGSPaymentOptionCardTableViewCellDelegate

/// no:doc
extension VGSPaymentOptionsViewController: VGSPaymentOptionCardTableViewCellDelegate {

	/// no:doc
	func removeCardDidTap(in savedCardCell: VGSPaymentOptionCardTableViewCell) {
		guard let savedCardIndex = mainView.tableView.indexPath(for: savedCardCell)?.row, let savedCardModel = viewModel.savedCardModel(at: savedCardIndex) else {return}

		let constants = VGSPaymentOptionsViewModel.RemoveCardPopupConstants.self
		VGSDialogHelper.presentDescturctiveActionAlert(with: constants.title.localized, message: constants.messageText.localized + " \(savedCardModel.maskedLast4)?", in: self, cancelActionTitle: constants.cancelActionTitle.localized, actionTitle: constants.removeActionTitle.localized) {[weak self] in
			guard let strongSelf = self else {
				return
			}

			strongSelf.viewModel.hadleRemoveSavedCard(with: savedCardModel.id)
		}
	}
}

// MARK: - VGSPaymentOptionsViewModelDelegate

// no:doc
extension VGSPaymentOptionsViewController: VGSPaymentOptionsViewModelDelegate {

	// no:doc
	func savedCardSelectionDidUpdate() {
		mainView.tableView.reloadData()
	}

	// no:doc
	func savedCardDidRemove(with id: String) {
		mainView.tableView.reloadData()

		// Notify Checkout with remove saved card action.
		guard let service = paymentService else {return}
		service.serviceDelegate?.checkoutServiceStateDidChange(with: .savedCardDidRemove(id), in: service)
		if !viewModel.paymentOptions.hasSavedCards {
			navigationItem.rightBarButtonItem = nil
		}
	}

	// no:doc
	func payWithNewCardDidTap() {
		navigateToPayWithNewCardScreen()
	}

	// no:doc
	func savedCardDidUpdateBeforeEditing() {
		mainView.tableView.reloadData()
	}

	// no:doc
	func savedCardDidUpdateAfterEditing() {
		mainView.tableView.reloadData()
	}
}
