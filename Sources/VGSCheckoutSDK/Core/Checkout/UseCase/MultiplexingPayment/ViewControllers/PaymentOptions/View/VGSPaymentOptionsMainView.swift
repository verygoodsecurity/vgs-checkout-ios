//
//  VGSPaymentOptionsMainView.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Holds UI for payment options screen.
internal class VGSPaymentOptionsMainView: UIView {

	/// Submit button.
	internal let submitButton: VGSSubmitButton
	
	/// Pay button container view to add insets.
	internal let payButtonContainerView: VGSContainerItemView = VGSAddCardFormViewBuilder.buildPaymentButtonContainerView()

	/// Form view.
	private lazy var formView = VGSFormView()

	// MARK: - Initialization

	internal init(uiTheme: VGSCheckoutThemeProtocol) {
		submitButton = VGSAddCardFormViewBuilder.buildPaymentButton(with: uiTheme)
		super.init(frame: .zero)
		setupUI()
	}

	/// no:doc
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Helpers

	/// Setup UI.
	internal func setupUI() {
		addSubview(formView)
		formView.checkout_constraintViewToSuperviewEdges()
		formView.stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		formView.stackView.isLayoutMarginsRelativeArrangement = true
		setupSubmitButtonUI()
	}

	private func setupSubmitButtonUI() {
		addSubview(payButtonContainerView)
		payButtonContainerView.paddings = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		payButtonContainerView.addContentView(submitButton)
		payButtonContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24).isActive = true
		payButtonContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		payButtonContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
	}
}
