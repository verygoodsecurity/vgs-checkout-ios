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

		mainView.backgroundColor = uiTheme.checkoutViewBackgroundColor
		mainView.tableView.backgroundColor = .clear

		mainView.tableView.register(VGSPaymentOptionCardTableViewCell.self, forCellReuseIdentifier: "VGSPaymentOptionCardTableViewCell")
		mainView.tableView.register(VGSPaymentOptionNewCardTableViewCell.self, forCellReuseIdentifier: "VGSPaymentOptionNewCardTableViewCell")
		mainView.tableView.dataSource = self
		mainView.tableView.delegate = self

		mainView.tableView.reloadData()
	}

	/// Handles tap on close button.
	@objc fileprivate func closeButtonDidTap() {
		guard let service = paymentService else {return}
		VGSCheckoutAnalyticsClient.shared.trackFormEvent(service.vgsCollect.formAnalyticsDetails, type: .cancel)
		paymentService?.serviceDelegate?.checkoutServiceStateDidChange(with: .cancelled, in: service)
	}
}

// MARK: - UITableViewDataSource

extension VGSPaymentOptionsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.paymentOptions.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let option = viewModel.paymentOptions[indexPath.row]
		switch option {
		case .savedCard(let card):
			guard let cardPaymentOptionCell = mainView.tableView.dequeueReusableCell(withIdentifier: "VGSPaymentOptionCardTableViewCell") as? VGSPaymentOptionCardTableViewCell else {fatalError("not implemented")}
			cardPaymentOptionCell.configure(with: card.paymentOptionCellViewModel, uiTheme: uiTheme)

			return cardPaymentOptionCell
		case .newCard:
			guard let newCardPaymentOptionCell = mainView.tableView.dequeueReusableCell(withIdentifier: "VGSPaymentOptionNewCardTableViewCell") as? VGSPaymentOptionNewCardTableViewCell else {fatalError("not implemented")}
			newCardPaymentOptionCell.configure(with: uiTheme)

			return newCardPaymentOptionCell
		}
	}
}

// MARK: - UITableViewDelegate

extension VGSPaymentOptionsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let index = indexPath.row
		var paymentOption = viewModel.paymentOptions[index]
		switch paymentOption {
		case.savedCard(var savedCard):
			guard let lastSelectedId = viewModel.previsouslySelectedID else {return}

			if savedCard.id == lastSelectedId {
				return
			} else {
				savedCard.isSelected = true
				viewModel.paymentOptions[index] = .savedCard(savedCard)
				for i in 0...viewModel.paymentOptions.count - 1 {
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

			viewModel.previsouslySelectedID = savedCard.id
			tableView.reloadData()
		case .newCard:
			guard let service = paymentService else {return}
			let vc = VGSPayWithCardViewController(paymentService: service, initialScreen: .paymentOptions)
			navigationController?.pushViewController(vc, animated: true)
		}
	}
}
