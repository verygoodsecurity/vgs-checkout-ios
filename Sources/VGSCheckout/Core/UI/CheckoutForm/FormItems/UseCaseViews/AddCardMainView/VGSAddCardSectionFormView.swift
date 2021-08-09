//
//  VGSAddCardSectionFormView.swift
//  VGSCheckout

import Foundation
#if os(iOS)
import UIKit
#endif

/// Holds UI for add card section form.
internal class VGSAddCardFormView: VGSFormView {

	/// Defines layout style.
	internal enum LayoutStyle {
		case fullScreen
	}

	// MARK: - Vars

	/// Main view layout style.
	internal let viewLayoutStyle: LayoutStyle

	/// Displays error messages for invalid card details.
  internal let cardDetailsErrorLabel: UILabel

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
	internal let payButton: VGSSubmitButton

	/// Pay button container view to add insets.
	internal let payButtonContainerView: VGSContainerItemView = VGSAddCardFormViewBuilder.buildPaymentButtonContainerView()

  /// Card details view.
	internal let cardDetailsSectionView: VGSCardDetailsSectionView

	/// Billing address view.
	internal let billingAddressSectionView: VGSBillingAddressDetailsSectionView

  internal let uiTheme: VGSCheckoutThemeProtocol
	// MARK: - Initialization

	/// Initializer.
  internal init(cardDetailsView: VGSCardDetailsSectionView, billingAddressView: VGSBillingAddressDetailsSectionView, viewLayoutStyle: LayoutStyle = .fullScreen, uiTheme: VGSCheckoutThemeProtocol) {
    self.uiTheme = uiTheme
    self.cardDetailsErrorLabel = VGSAddCardFormViewBuilder.buildErrorLabel(with: uiTheme)
    self.payButton = VGSAddCardFormViewBuilder.buildPaymentButton(with: uiTheme)

		self.viewLayoutStyle = viewLayoutStyle
		self.cardDetailsSectionView = cardDetailsView
		self.billingAddressSectionView = billingAddressView
		super.init()

    self.payButton.delegate = self
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

			backgroundStackView.addArrangedSubview(cardDetailsSectionView)
			backgroundStackView.addArrangedSubview(billingAddressSectionView)
			
			backgroundStackView.addArrangedSubview(payButtonContainerView)
		}
	}
}

// MARK: - VGSSubmitButtonDelegateProtocol

extension VGSAddCardFormView: VGSSubmitButtonDelegateProtocol {
	func statusDidChange(in button: VGSSubmitButton) {
    button.updateUI(with: uiTheme)
  }
}
