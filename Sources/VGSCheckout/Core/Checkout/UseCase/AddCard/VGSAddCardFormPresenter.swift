//
//  VGSAddCardFormPresenter.swift
//  VGSCheckout

import Foundation
#if os(iOS)
import UIKit
#endif
import VGSCollectSDK

/// Handle add card form logic.
internal class VGSAddCardFormPresenter: NSObject {

	enum FormState {
		case invalid
		case valid
		case processing
	}

	var state = FormState.invalid {
		didSet {
			switch state {
			case .invalid:
				addCardMainView.payButton.status = .disabled
			case .valid:
				addCardMainView.payButton.status = .enabled
			case .processing:
				addCardMainView.payButton.status = .processing
			}
		}
	}

	/// Payment instrument.
	internal let paymentInstrument: VGSPaymentInstrument

	///
	internal let cardFormController: VGSCardDetailsFormSectionPresenter

	/// Add card main view.
	internal let addCardMainView: VGSAddCardMainView

	/// `VGSCollect` object.
	internal let vgsCollect: VGSCollect

	// MARK: - Initialization

	init(paymentInstrument: VGSPaymentInstrument, vgsCollect: VGSCollect) {
		self.paymentInstrument = paymentInstrument
		self.vgsCollect = vgsCollect
		self.cardFormController = VGSCardDetailsFormSectionPresenter(paymentInstrument: paymentInstrument, vgsCollect: vgsCollect, validationBehavior: .onFocus)
		self.addCardMainView = VGSAddCardMainView(paymentInstrument: paymentInstrument, cardDetailsView: cardFormController.cardFormView, viewLayoutStyle: .fullScreen)
		super.init()
	}

	internal func buildCheckoutViewController() -> UIViewController {

		addCardMainView.headerView.delegate = self
		addCardMainView.translatesAutoresizingMaskIntoConstraints = false
		let viewController = VGSFormViewController(formView: addCardMainView.formView)

		addCardMainView.payButton.addTarget(self, action: #selector(payDidTap), for: .touchUpInside)
		cardFormController.delegate = self

		return viewController
	}

	// MARK: - Helpers

	@objc fileprivate func payDidTap() {
		addCardMainView.payButton.status = .processing
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.addCardMainView.payButton.status = .success
		}
	}
}

// MARK: - VGSHeaderBarViewDelegate

extension VGSAddCardFormPresenter: VGSHeaderBarViewDelegate {
	func buttonDidTap(in header: VGSHeaderBarView) {
		//checkoutCoordinator.dismissRootViewController()
	}
}

// MARK: - VGSFormItemControllerDelegate

extension VGSAddCardFormPresenter: VGSFormSectionPresenterDelegate {
	func stateDidChange(_ state: VGSFormSectionState) {
		switch state {
		case .invalid:
			addCardMainView.payButton.status = .disabled
		case .valid:
			addCardMainView.payButton.status = .enabled
		}
	}
}
