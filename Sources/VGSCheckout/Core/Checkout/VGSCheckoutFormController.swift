//
//  VGSCheckoutFormController.swift
//  VGSCheckout

import Foundation
#if os(iOS)
import UIKit
#endif
import VGSCollectSDK

internal class VGSCheckoutFormController: NSObject {

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

	internal let paymentFlow: VGSPaymentFlow

	internal let payButton: VGSSubmitButton = VGSCheckoutFormViewBuilder.buildPaymentButton()

	internal let payButtonContainerView: VGSContainerItemView = VGSCheckoutFormViewBuilder.buildPaymentButtonContainerView()

	internal let cardFormController: VGSCardFormItemController

	/// `VGSCollect` object.
	internal let vgsCollect: VGSCollect

	// MARK: - Initialization

	init(paymentFlow: VGSPaymentFlow, vgsCollect: VGSCollect) {
		self.paymentFlow = paymentFlow
		self.vgsCollect = vgsCollect
		self.cardFormController = VGSCardFormItemController(paymentFlow: paymentFlow, vgsCollect: vgsCollect, validationBehavior: .onFocus)
		super.init()
	}

	internal func buildCheckoutViewController() -> UIViewController {
		let formView = VGSFormView()
		formView.translatesAutoresizingMaskIntoConstraints = false

		let viewController = VGSFormViewController(formView: formView)
		viewController.formView.stackView.layoutMargins = UIEdgeInsets(top: 50, left: 16, bottom: 50, right: 16)
		viewController.formView.stackView.isLayoutMarginsRelativeArrangement = true

		viewController.formView.addFormItemView(backgroundStackView)
		payButtonContainerView.addContentView(payButton)

		cardFormController.buildForm()

		payButton.addTarget(self, action: #selector(payDidTap), for: .touchUpInside)
		cardFormController.delegate = self

		backgroundStackView.addArrangedSubview(cardFormController.cardFormView)
		backgroundStackView.addArrangedSubview(payButtonContainerView)

		/// Add empty transparent view to bottom.
		let view = UIView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false

		viewController.formView.addFormItemView(view)

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

// MARK: - VGSFormItemControllerDelegate

extension VGSCheckoutFormController: VGSFormItemControllerDelegate {
	func stateDidChange(_ state: FormItemControllerState) {
		switch state {
		case .invalid:
			payButton.status = .disabled
		case .valid:
			payButton.status = .enabled
		}
	}
}
