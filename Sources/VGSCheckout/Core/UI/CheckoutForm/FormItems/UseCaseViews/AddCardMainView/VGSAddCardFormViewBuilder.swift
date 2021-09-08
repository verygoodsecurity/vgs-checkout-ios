//
//  VGSAddCardFormViewBuilder.swift
//  VGSCheckout
//

import Foundation
#if os(iOS)
import UIKit
#endif

internal class VGSAddCardFormViewBuilder {

	// TODO: - add styling 
	static func buildBackgroundStackView() -> UIStackView {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
		stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 20
		return stackView
	}

  static func buildPaymentButton(with uiTheme: VGSCheckoutSubmitButtonThemeProtocol, delegate: VGSSubmitButtonDelegateProtocol? = nil) -> VGSSubmitButton {
		let button = VGSSubmitButton(frame: .zero)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
    button.titleLabel.font = uiTheme.checkoutSubmitButtonTitleFont

		button.title = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_save_card_button_title" )
    button.delegate = delegate
    button.updateUI(with: uiTheme)

		return button
	}

	static func buildPaymentButtonContainerView() -> VGSContainerItemView {
		let view = VGSContainerItemView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.paddings = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
		return view
	}
    
    /// Build error label.
    /// - Returns: `UILabel` for error message.
  static func buildErrorLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .systemFont(ofSize: 14)
        label.textColor = .red
        label.numberOfLines = 1
        return label
    }
}
