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

		/// Full screen layout (checkout is being presented as view controller).
		case fullScreen
	}

	// MARK: - Vars

	/// Main view layout style.
	internal let viewLayoutStyle: LayoutStyle

	/// Background stack view.
	fileprivate let backgroundStackView: UIStackView = VGSAddCardFormViewBuilder.buildBackgroundStackView()

	/// Save card button.
	internal let saveCardButton: VGSSubmitButton

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
        self.saveCardButton = VGSAddCardFormViewBuilder.buildPaymentButton(with: uiTheme)

		self.viewLayoutStyle = viewLayoutStyle
		self.cardDetailsSectionView = cardDetailsView
		self.billingAddressSectionView = billingAddressView
		super.init()

		self.saveCardButton.delegate = self
		stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
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
			addFormItemView(backgroundStackView)
			payButtonContainerView.addContentView(saveCardButton)

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
