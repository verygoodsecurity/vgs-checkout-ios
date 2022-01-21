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

//		case removeSaveCardsRequestState

		var isEditingSavedCard: Bool {
			switch self {
			case .editingSavedCards:
				return true
			default:
				return false
			}
		}

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

	/// Edit cards bar button item.
	fileprivate var editCardsBarButtomItem: UIBarButtonItem?

	/// Screen state.
	fileprivate var screenState: ScreenState = .initial {
		didSet {
			switch screenState {
			case .initial:
				editCardsBarButtomItem?.title = "Edit"
				// Restore selection from the previous card.
				for index in 0..<viewModel.paymentOptions.count {
					let option = viewModel.paymentOptions[index]
					switch option {
					case .savedCard(var card):
						if card.id == viewModel.lastSelectedSavedCardId {
							card.isSelected = true
							viewModel.paymentOptions[index] = .savedCard(card)
						}
					case .newCard:
						continue
					}
				}
				mainView.tableView.reloadData()
			case .processingTransfer:
				guard let cardInfo = viewModel.selectedPaymentCardInfo else {return}
				mainView.isUserInteractionEnabled = false
				closeBarButtomItem?.isEnabled = false
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
				editCardsBarButtomItem?.title = "Cancel"
				// Remove selection from all cards.
				for index in 0..<viewModel.paymentOptions.count {
					let option = viewModel.paymentOptions[index]
					switch option {
					case .savedCard(var card):
							card.isSelected = false
							viewModel.paymentOptions[index] = .savedCard(card)
					case .newCard:
						continue
					}
				}
				mainView.tableView.reloadData()

//				viewModel.previsouslySelectedID = nil

				// Reload cards with remove options.
			}
		}
	}

	// MARK: - Initialization

	/// Initializer
	/// - Parameter paymentService: `VGSCheckoutPayoptTransfersService` object, pay opt  checkout transfer service.
	init(paymentService: VGSCheckoutPayoptTransfersService) {
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

		view.backgroundColor = uiTheme.checkoutViewBackgroundColor
		title = viewModel.rootNavigationTitle

		setupMainView()
		setupSubmitButton()
		setupCloseButton()
		setupEditCardsBarButton()
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

	/// Left close bar button item setup.
	private func setupCloseButton() {
		let closeTitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_cancel_button_title")
		closeBarButtomItem = UIBarButtonItem(title: closeTitle, style: .plain, target: self, action: #selector(closeButtonDidTap))
		navigationItem.leftBarButtonItem = closeBarButtomItem
	}

	/// Right bar button item setup.
	private func setupEditCardsBarButton() {
		let editTitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_cancel_button_title")
		editCardsBarButtomItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editCardsButtonDidTap))
		navigationItem.rightBarButtonItem = editCardsBarButtomItem
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
		let paymentOption = viewModel.paymentOptions[index]

		switch paymentOption {
		case.savedCard(var savedCard):
			guard let lastSelectedId = viewModel.lastSelectedSavedCardId else {return}

			/// Ignore same card selection.
			if savedCard.id == lastSelectedId {
				return
			} else {
				// Select new card.
				savedCard.isSelected = true
				viewModel.paymentOptions[index] = .savedCard(savedCard)

				// Remove selection from the previous card
				for index in 0..<viewModel.paymentOptions.count {
					let option = viewModel.paymentOptions[index]
					switch option {
					case .savedCard(var card):
						if card.id == lastSelectedId {
							card.isSelected = false
							viewModel.paymentOptions[index] = .savedCard(card)
						}
					case .newCard:
						continue
					}
				}
			}

			// Save new selected id.
			viewModel.lastSelectedSavedCardId = savedCard.id
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

// MARK: - VGSPaymentOptionCardTableViewCellDelegate

/// no:doc
extension VGSPaymentOptionsViewController: VGSPaymentOptionCardTableViewCellDelegate {

	/// no:doc
	func removeCardDidTap(in savedCardCell: VGSPaymentOptionCardTableViewCell) {
		guard let savedCardIndex = mainView.tableView.indexPath(for: savedCardCell)?.row, let savedCardModel = viewModel.paymentOptions[savedCardIndex].savedCardModel else {
			return
		}

		let cardIdToRemove = savedCardModel.id

		let constants = VGSPaymentOptionsViewModel.RemoveCardPopupConstants.self
		VGSDialogHelper.presentDescturctiveActionAlert(with: constants.title.localized, message: constants.messageText.localized + "(\(savedCardModel.last4)", in: self, cancelActionTitle: constants.cancelActionTitle.localized, actionTitle: constants.removeActionTitle.localized) {[weak self] in
			guard let strongSelf = self else {
				return
			}
			strongSelf.viewModel.paymentOptions = strongSelf.viewModel.paymentOptions.filter({ option in
				guard let card = option.savedCardModel else {
					return true
				}

				return card.id != cardIdToRemove
			})
			strongSelf.mainView.tableView.reloadData()
		}
	}
}
