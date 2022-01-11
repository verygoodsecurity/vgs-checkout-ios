//
//  VGSSaveCardViewController.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Holds UI for save card flow.
internal class VGSSaveCardViewController: VGSBaseCardViewController {

	// MARK: - Vars

	// Save card service.
	fileprivate weak var saveCardService: VGSSaveCardCheckoutService?

	// Save card view model.
	fileprivate let saveCardViewModel: VGSSaveCardViewModelProtocol

	// MARK: - Initialization

	init(saveCardService: VGSSaveCardCheckoutService) {
		self.saveCardService = saveCardService
		self.saveCardViewModel = VGSSaveCardViewModelFactory.buildAddCardViewModel(with: saveCardService.checkoutConfigurationType, vgsCollect: saveCardService.vgsCollect)
		super.init(checkoutConfigurationType: saveCardService.checkoutConfigurationType, vgsCollect: saveCardService.vgsCollect, uiTheme: saveCardService.uiTheme)
	}

	/// no:doc
	internal required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	/// no:doc
	override func viewDidLoad() {
		super.viewDidLoad()

		delegate = self
	}

	// MARK: - Override

	override func setupUI() {
		super.setupUI()

		navigationItem.title = saveCardViewModel.rootNavigationTitle
		addCardSectionFormView.submitButton.title = saveCardViewModel.submitButtonTitle
	}
}

// MARK: - VGSCheckoutBaseCardViewControllerDelegate

extension VGSSaveCardViewController: VGSCheckoutBaseCardViewControllerDelegate {
	func submitButtonDidTap(in formState: VGSBaseCardViewController.FormState, viewController: VGSBaseCardViewController) {
		switch formState {
		case .processing:
			saveCardViewModel.apiWorker.sendData {[weak self] requestResult in
				guard let strongSelf = self else {return}
				let state = VGSAddCardFlowState.requestSubmitted(requestResult)
				guard let service = strongSelf.saveCardService else {return}
				strongSelf.saveCardService?.serviceDelegate?.checkoutServiceStateDidChange(with: state, in: service)
			}
		default:
			break
		}
	}

	func closeButtonDidTap(in viewController: VGSBaseCardViewController) {
		guard let service = saveCardService else {return}
		saveCardService?.serviceDelegate?.checkoutServiceStateDidChange(with: .cancelled, in: service)
	}
}
