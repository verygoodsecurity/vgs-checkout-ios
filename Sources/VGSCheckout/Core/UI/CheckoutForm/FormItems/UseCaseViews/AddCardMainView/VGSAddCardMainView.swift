//
//  VGSAddCardMainView.swift
//  VGSCheckout

import Foundation
#if os(iOS)
import UIKit
#endif

/// Holds UI for AddCard flow.
internal class VGSAddCardMainView: UIView {

	/// Defines layout style.
	internal enum LayoutStyle {
		case fullScreen
	}

	// MARK: - Vars

	/// Payment instrument.
	internal let paymentInstrument: VGSPaymentInstrument

	/// Main view layout style.
	internal let viewLayoutStyle: LayoutStyle

	/// Header bar view.
	internal lazy var headerView: VGSHeaderBarView = {
		let view = VGSHeaderBarView()
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	/// Pay with card header view.
	internal lazy var payWithCardHeaderView: VGSPayWithCardHeaderView = {
		let view = VGSPayWithCardHeaderView()
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	/// Form view.
	internal lazy var formView: VGSFormView = {
		let view = VGSFormView()
		view.translatesAutoresizingMaskIntoConstraints = false

		view.stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 50, right: 16)
		view.stackView.isLayoutMarginsRelativeArrangement = true
		view.stackView.spacing = 8

		return view
	}()

	/// Background stack view.
	fileprivate let backgroundStackView: UIStackView = VGSAddCardFormViewBuilder.buildBackgroundStackView()

	/// Pay button.
	internal let payButton: VGSSubmitButton = VGSAddCardFormViewBuilder.buildPaymentButton()

	/// Pay button container view to add insets.
	internal let payButtonContainerView: VGSContainerItemView = VGSAddCardFormViewBuilder.buildPaymentButtonContainerView()

	internal let cardDetailsView: VGSCheckoutCardFormView

	// MARK: - Initialization

	/// Initializer.
	internal init(paymentInstrument: VGSPaymentInstrument, cardDetailsView: VGSCheckoutCardFormView, viewLayoutStyle: LayoutStyle = .fullScreen) {
		self.paymentInstrument = paymentInstrument
		self.viewLayoutStyle = viewLayoutStyle
		self.cardDetailsView = cardDetailsView
		super.init(frame: .zero)

		setupUI()
	}

	/// :nodoc:
	internal required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Helpers

	/// Setup UI and basic layout.
	private func setupUI() {
		switch viewLayoutStyle {
		case .fullScreen:
			let headerView = VGSHeaderBarView()
			headerView.translatesAutoresizingMaskIntoConstraints = false
			formView.addFormItemView(headerView)

			//headerView.delegate = self

			let payWithCardHeaderView = VGSPayWithCardHeaderView(frame: .zero)
			payWithCardHeaderView.translatesAutoresizingMaskIntoConstraints = false
			formView.addFormItemView(payWithCardHeaderView)

			formView.addFormItemView(backgroundStackView)
			payButtonContainerView.addContentView(payButton)

			//payButton.addTarget(self, action: #selector(payDidTap), for: .touchUpInside)
			// cardFormController.delegate = self
			// Add empty transparent view to bottom.

			backgroundStackView.addArrangedSubview(cardDetailsView)
			backgroundStackView.addArrangedSubview(payButtonContainerView)
		}
	}
}
