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

	internal let payButton: VGSSubmitButton

	internal let payButtonContainerView: VGSContainerItemView

	/// `VGSCollect` object.
	internal let vgsCollect: VGSCollect


	// MARK: - Initialization

	init(paymentFlow: VGSPaymentFlow, vgsCollect: VGSCollect) {
		self.paymentFlow = paymentFlow
		self.payButton = VGSCheckoutFormViewBuilder.buildPaymentButton()
		self.payButtonContainerView = VGSContainerItemView(frame: .zero)
		self.vgsCollect = vgsCollect
		super.init()
		payButton.addTarget(self, action: #selector(payDidTap), for: .touchUpInside)
	}

	internal func buildCheckoutViewController() -> UIViewController {
		let formView = VGSFormView()
		formView.translatesAutoresizingMaskIntoConstraints = false

		let viewController = VGSFormViewController(formView: formView)
		viewController.formView.stackView.layoutMargins = UIEdgeInsets(top: 50, left: 16, bottom: 50, right: 16)
		viewController.formView.stackView.isLayoutMarginsRelativeArrangement = true


		viewController.formView.addFormItemView(backgroundStackView)

		backgroundStackView.addArrangedSubview(cardCheckoutView)
		backgroundStackView.addArrangedSubview(payButtonContainerView)

		/// Add empty transparent view to bottom.
		let view = UIView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false

		viewController.formView.addFormItemView(view)

		return viewController
	}

	// MARK: - View

	internal lazy var cardCheckoutView: VGSCheckoutCardFormView = {
		let view = VGSCheckoutCardFormView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	// MARK: - Helpers


	@objc fileprivate func payDidTap() {
		payButton.status = .processing
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.payButton.status = .success
		}
	}

	var textFiedComponents: [VGSTextFieldFormComponentProtocol] {
		return [cardCheckoutView.cardNumberComponentView,
						cardCheckoutView.expDateComponentView,
						cardCheckoutView.cvcDateComponentView]
	}
}
