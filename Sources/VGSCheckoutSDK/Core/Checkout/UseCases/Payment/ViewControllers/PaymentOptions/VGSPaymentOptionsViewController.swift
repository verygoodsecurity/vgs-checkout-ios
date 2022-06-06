//
//  VGSPaymentOptionsViewController.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Holds UI and view model for payment options screen.
internal class VGSPaymentOptionsViewController: UIViewController {

	/// Defines deleting card state.
	internal enum RemoveCardState {

		/// Deleting card request is in progress.
		case processingRemoveCard(_ finID: String)

		/// Remove card request did succeed.
		case success(_ finID: String, _ requestResult: VGSCheckoutRequestResult)

		/// Remove card request did fail.
		case failure(_ finID: String, _ requestResult: VGSCheckoutRequestResult)
	}

	/// Defines screen state.
	internal enum ScreenState {

		/// Initial screen state.
		case initial

		/// Processing state.
		case processingTransfer

		/// Editing saved cards.
		case editingSavedCards

		/// Remove card.
		case removeCard(_ state: RemoveCardState)

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

	/// Cancel edit button title.
	fileprivate let cancelEditTitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_payment_options_cancel_edit_cards_button_title")

	/// View model.
	fileprivate let viewModel: VGSPaymentOptionsViewModel

	/// Main view.
	fileprivate let mainView: VGSPaymentOptionsMainView

	/// UI theme.
	fileprivate let uiTheme: VGSCheckoutThemeProtocol

	// Pay with card service.
	fileprivate weak var paymentService: VGSCheckoutBasicPayoptServiceProtocol?

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

				/// Notifies delegate that user pressed pay with selected card id and close checkout.
				guard let service = paymentService else {return}
				switch service.configuration.payoptFlow {
				case .addCard:
					service.serviceDelegate?.checkoutServiceStateDidChange(with: .checkoutDidFinish(.savedCard(VGSCheckoutPaymentCardInfo(id: cardInfo.id))), in: service)
				case .transfers:
					mainView.isUserInteractionEnabled = false
					closeBarButtomItem.isEnabled = false
					editCardsBarButtomItem.isEnabled = false
					mainView.submitButton.status = .processing
					mainView.alpha = VGSUIConstants.FormUI.formProcessingAlpha
//					let info = VGSCheckoutPaymentResultInfo(paymentMethod: .savedCard(cardInfo))
					viewModel.apiWorker.sendTransfer(with:cardInfo.id, completion: {[weak self] requestResult in
						guard let strongSelf = self else {return}
						let state = VGSAddCardFlowState.requestSubmitted(requestResult)
						guard let service = strongSelf.paymentService else {return}
						strongSelf.paymentService?.serviceDelegate?.checkoutServiceStateDidChange(with: state, in: service)
					})
				}
			case .editingSavedCards:
				mainView.submitButton.status = .disabled
				editCardsBarButtomItem.title = cancelEditTitle
				viewModel.handleEditModeTap()
			case .removeCard(let removeCardState):
				switch removeCardState {
				case .processingRemoveCard(let finID):
					navigationItem.leftBarButtonItem?.isEnabled = false
					navigationItem.rightBarButtonItem?.isEnabled = false
					mainView.submitButton.status = .disabled
					mainView.tableView.isUserInteractionEnabled = false
					displayLoader()
					viewModel.removeSavedCardAPIWorker.removeSavedCard(with: finID) {[weak self] finID, requestResult in
						self?.screenState = .removeCard(.success(finID, requestResult))
					} failure: { [weak self] finID, requestResult in
						self?.screenState = .removeCard(.failure(finID, requestResult))
					}
				case .success(let finID, let requestResult):
					// Update UI.
					navigationItem.leftBarButtonItem?.isEnabled = true
					navigationItem.rightBarButtonItem?.isEnabled = true
					mainView.submitButton.status = .enabled
					mainView.tableView.isUserInteractionEnabled = true

					// Remove card in view model.
					viewModel.hadleRemoveSavedCard(with: finID, requestResult: requestResult)
					hideLoader()
				case .failure(let finID, let requestResult):
					// Display error dialog.
					VGSDialogHelper.presentAlertDialog(with: VGSPaymentOptionsViewModel.RemoveCardErrorPopupConstants.title.localized, message: VGSPaymentOptionsViewModel.RemoveCardErrorPopupConstants.messageText.localized, okActionTitle: "Ok", in: self) {[weak self] in
						guard let strongSelf = self else {return}
						// Update UI.
						strongSelf.navigationItem.leftBarButtonItem?.isEnabled = true
						strongSelf.navigationItem.rightBarButtonItem?.isEnabled = true
						strongSelf.mainView.submitButton.status = .enabled
						strongSelf.mainView.tableView.isUserInteractionEnabled = true
						strongSelf.screenState = .editingSavedCards

						strongSelf.hideLoader()

						// Notify delegate with remove card error.
						guard let service = strongSelf.paymentService else {return}
						service.serviceDelegate?.checkoutServiceStateDidChange(with: .removeSaveCardDidFinish(finID, requestResult), in: service)
						// Send analytics error.
					}
				}
			}
		}
	}

	// MARK: - Initialization

	/// Initializer
	/// - Parameter paymentService: `VGSSaveCardCheckoutService` object, pay opt  checkout transfer service.
	init(paymentService: VGSCheckoutBasicPayoptServiceProtocol) {
		self.paymentService = paymentService
		self.viewModel = VGSPayoptTransfersViewModelFactory.buildPaymentOptionsViewModel(with: paymentService)
		self.mainView = VGSPaymentOptionsMainView(uiTheme: paymentService.configuration.uiTheme)
		self.uiTheme = paymentService.configuration.uiTheme

		VGSCheckoutAnalyticsClient.shared.trackFormEvent(paymentService.configuration.vgsCollect.formAnalyticsDetails, type: .formInit, extraData: ["config": "payopt", "configType": "addCard"])

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

		// Enable editing saved cards.
		if let service = paymentService {
			if service.configuration.isRemoveCardOptionEnabled {
				navigationItem.rightBarButtonItem = editCardsBarButtomItem
			}
		}

		setupMainView()
		setupSubmitButton()
		setupTableView()

		mainView.tableView.reloadData()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		//displayLoader()
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
		let saveCardViewController = VGSPayWithCardViewController(paymentService: service, initialScreen: service.initialScreen)
		navigationController?.pushViewController(saveCardViewController, animated: true)
	}

	// MARK: - Actions

	/// Handles tap on close button.
	@objc fileprivate func closeButtonDidTap() {
		guard let service = paymentService else {return}
		VGSCheckoutAnalyticsClient.shared.trackFormEvent(service.configuration.vgsCollect.formAnalyticsDetails, type: .cancel, extraData: ["config": "payopt", "configType": "addCard"])
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

			// Start remove card.
			strongSelf.screenState = .removeCard(.processingRemoveCard(savedCardModel.id))
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
	func savedCardDidRemove(with id: String, requestResult: VGSCheckoutRequestResult) {
		mainView.tableView.reloadData()

		// Notify Checkout with remove saved card action.
		guard let service = paymentService else {return}
		service.serviceDelegate?.checkoutServiceStateDidChange(with: .removeSaveCardDidFinish(id, requestResult), in: service)
		if !viewModel.paymentOptions.hasSavedCards {
			navigationItem.rightBarButtonItem = nil
			mainView.submitButton.status = .disabled
		} else {
			editCardsBarButtomItem.title = editTitle
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
