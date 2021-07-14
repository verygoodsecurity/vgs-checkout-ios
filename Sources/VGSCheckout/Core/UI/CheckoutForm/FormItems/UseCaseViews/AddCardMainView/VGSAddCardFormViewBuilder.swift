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

		stackView.layer.cornerRadius = 4
		stackView.layer.borderColor = UIColor(hexString: "#C8D0DB").cgColor
		stackView.layer.borderWidth = 1

		stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
		stackView.isLayoutMarginsRelativeArrangement = true

		return stackView
	}

  static func buildPaymentButton(with uiTheme: VGSCheckoutSubmitButtonThemeProtocol, delegate: VGSSubmitButtonDelegateProtocol? = nil) -> VGSSubmitButton {
		let button = VGSSubmitButton(frame: .zero)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
    button.titleLabel.font = uiTheme.checkoutSubmitButtonTitleFont
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
  static func buildErrorLabel(with uiTheme: VGSCheckoutErrorLabelThemeProtocol) -> UILabel {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontForContentSizeCategory = true
    label.font = uiTheme.checkoutErrorLabelFont
		label.textColor = uiTheme.checkoutErrorLabelTextColor
		label.numberOfLines = 0

		return label
	}
}
