//
//  VGSPaymentOptionsMainView.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

internal class SelfSizedTableView: UITableView {
	var maxHeight: CGFloat = UIScreen.main.bounds.size.height

	override func reloadData() {
		super.reloadData()
		self.invalidateIntrinsicContentSize()
		self.layoutIfNeeded()
	}

	override var contentSize: CGSize {
			didSet {
					invalidateIntrinsicContentSize()
			}
	}

	override var intrinsicContentSize: CGSize {
			layoutIfNeeded()
			return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
	}
}

/// Holds UI for payment options screen.
internal class VGSPaymentOptionsMainView: UIView {

	/// Table view.
	internal let tableView = SelfSizedTableView(frame: .zero)

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
		formView.translatesAutoresizingMaskIntoConstraints = false
		formView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		formView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		formView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		formView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -75).isActive = true

		formView.stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		formView.stackView.isLayoutMarginsRelativeArrangement = true

		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.isScrollEnabled = false

		formView.stackView.addArrangedSubview(tableView)
		formView.scrollView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
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
