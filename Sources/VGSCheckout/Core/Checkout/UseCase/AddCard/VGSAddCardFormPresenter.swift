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
				payButton.status = .disabled
			case .valid:
				payButton.status = .enabled
			case .processing:
				payButton.status = .processing
			}
		}
	}

	fileprivate let backgroundStackView: UIStackView = VGSCheckoutFormViewBuilder.buildBackgroundStackView()

	internal let paymentInstrument: VGSPaymentInstrument

	internal let payButton: VGSSubmitButton = VGSCheckoutFormViewBuilder.buildPaymentButton()

	internal let payButtonContainerView: VGSContainerItemView = VGSCheckoutFormViewBuilder.buildPaymentButtonContainerView()

	internal let cardFormController: VGSCardFormItemController

	/// `VGSCollect` object.
	internal let vgsCollect: VGSCollect

	// MARK: - Initialization

	init(paymentInstrument: VGSPaymentInstrument, vgsCollect: VGSCollect) {
		self.paymentInstrument = paymentInstrument
		self.vgsCollect = vgsCollect
		self.cardFormController = VGSCardFormItemController(paymentInstrument: paymentInstrument, vgsCollect: vgsCollect, validationBehavior: .onFocus)
		super.init()
	}

	internal func buildCheckoutViewController() -> UIViewController {
		let formView = VGSFormView()
		formView.translatesAutoresizingMaskIntoConstraints = false

		let viewController = VGSFormViewController(formView: formView)
		viewController.formView.stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 50, right: 16)
		viewController.formView.stackView.isLayoutMarginsRelativeArrangement = true
		viewController.formView.stackView.spacing = 8

		let headerView = VGSHeaderBarView()
		headerView.translatesAutoresizingMaskIntoConstraints = false
		viewController.formView.addFormItemView(headerView)
		headerView.delegate = self

		let payWithCardHeaderView = VGSPayWithCardHeaderView(frame: .zero)
		payWithCardHeaderView.translatesAutoresizingMaskIntoConstraints = false
		viewController.formView.addFormItemView(payWithCardHeaderView)

		viewController.formView.addFormItemView(backgroundStackView)
		payButtonContainerView.addContentView(payButton)

		cardFormController.buildForm()

		payButton.addTarget(self, action: #selector(payDidTap), for: .touchUpInside)
		cardFormController.delegate = self
		// Add empty transparent view to bottom.

		// Test view for keyboard animation check.
		let view1 = UIView()
		view1.backgroundColor = .clear
		view1.translatesAutoresizingMaskIntoConstraints = false
		view1.heightAnchor.constraint(equalToConstant: 200).isActive = true

		backgroundStackView.addArrangedSubview(cardFormController.cardFormView)
		backgroundStackView.addArrangedSubview(payButtonContainerView)

		/// Add empty transparent view to bottom.
		let view = UIView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false

		viewController.formView.addFormItemView(view)

		//checkoutCoordinator.setRootViewController(viewController)

		return viewController
	}

	// MARK: - Helpers

	@objc fileprivate func payDidTap() {
		payButton.status = .processing
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.payButton.status = .success
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

extension VGSAddCardFormPresenter: VGSFormItemControllerDelegate {
	func stateDidChange(_ state: FormItemControllerState) {
		switch state {
		case .invalid:
			payButton.status = .disabled
		case .valid:
			payButton.status = .enabled
		}
	}
}

