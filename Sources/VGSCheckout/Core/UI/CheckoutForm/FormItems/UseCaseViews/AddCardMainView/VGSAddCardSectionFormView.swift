//
//  VGSAddCardSectionFormView.swift
//  VGSCheckout

import Foundation
#if os(iOS)
import UIKit
#endif

/// Holds UI for add card section form.
internal class VGSAddCardSectionFormView: VGSFormView {

	/// Defines layout style.
	internal enum LayoutStyle {
		case fullScreen
	}

	// MARK: - Vars

	/// Payment instrument.
	internal let paymentInstrument: VGSPaymentInstrument

	/// Main view layout style.
	internal let viewLayoutStyle: LayoutStyle

	/// Displays error messages for invalid card holder name.
	internal let cardHolderErrorLabel = VGSAddCardFormViewBuilder.buildErrorLabel()

	/// Displays error messages for invalid card details.
	internal let cardDetailsErrorLabel = VGSAddCardFormViewBuilder.buildErrorLabel()

	/// Header bar view.
	internal lazy var headerBarView: VGSHeaderBarView = {
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

	/// Background stack view.
	fileprivate let backgroundStackView: UIStackView = VGSAddCardFormViewBuilder.buildBackgroundStackView()

	/// Pay button.
	internal let payButton: VGSSubmitButton = VGSAddCardFormViewBuilder.buildPaymentButton()

	/// Pay button container view to add insets.
	internal let payButtonContainerView: VGSContainerItemView = VGSAddCardFormViewBuilder.buildPaymentButtonContainerView()

  /// Card details view.
	internal let cardDetailsView: VGSCardDetailsFormView

	// MARK: - Initialization

	/// Initializer.
	internal init(paymentInstrument: VGSPaymentInstrument, cardDetailsView: VGSCardDetailsFormView, viewLayoutStyle: LayoutStyle = .fullScreen) {
		self.paymentInstrument = paymentInstrument
		self.viewLayoutStyle = viewLayoutStyle
		self.cardDetailsView = cardDetailsView

		super.init()

		stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 50, right: 16)
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.spacing = 8

		setupUI()
	}

	/// no:doc
	internal required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Interface

	internal func updateUI(errorText: String, formFieldType: VGSAddCardFormFieldType) {
		switch formFieldType {
		case .cardholderName, .firstName, .lastName:
			cardDetailsView.cardHolderErrorLabel.isHidden = false
			cardDetailsView.cardHolderErrorLabel.text = errorText
		case .cardNumber, .expirationDate, .cvc:
			cardDetailsView.cardDetailsErrorLabel.isHidden = false
			cardDetailsView.cardDetailsErrorLabel.text = errorText
		}
	}

	// MARK: - Helpers

	/// Setup UI and basic layout.
	private func setupUI() {
		switch viewLayoutStyle {
		case .fullScreen:
			addFormItemView(headerBarView)

			let payWithCardHeaderView = VGSPayWithCardHeaderView(frame: .zero)
			payWithCardHeaderView.translatesAutoresizingMaskIntoConstraints = false
			addFormItemView(payWithCardHeaderView)

			addFormItemView(backgroundStackView)
			payButtonContainerView.addContentView(payButton)

			backgroundStackView.addArrangedSubview(cardDetailsView)
			backgroundStackView.addArrangedSubview(payButtonContainerView)
		}
	}
}