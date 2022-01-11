//
//  VGSAddCardFormViewBuilder.swift
//  VGSCheckoutSDK
//

import Foundation
#if os(iOS)
import UIKit
#endif

internal class VGSAddCardFormViewBuilder {

	static func buildBackgroundStackView() -> UIStackView {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.spacing = 16

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
		view.paddings = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
		return view
	}

	static func buildChecboxButtonContainerView() -> VGSContainerItemView {
		let view = VGSContainerItemView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.paddings = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
		return view
	}

	/// Builds error view.
	/// - Returns: `VGSValidationErrorView` object, view to display error message.
	static func buildErrorView() -> VGSValidationErrorView {
		let view = VGSValidationErrorView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}
}
