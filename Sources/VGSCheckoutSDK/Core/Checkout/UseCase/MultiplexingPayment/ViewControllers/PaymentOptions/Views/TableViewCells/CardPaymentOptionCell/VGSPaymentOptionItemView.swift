//
//  VGSPaymentOptionItemView.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Payment option item view.
internal class VGSPaymentOptionItemView: UIView {

	/// Theme object.
	internal let uiTheme: VGSCheckoutThemeProtocol

	/// Stack view.
	internal lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 8
		stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 4, right: 16)
		stackView.isLayoutMarginsRelativeArrangement = true

		return stackView
	}()

	init(uiTheme: VGSCheckoutThemeProtocol) {
		self.uiTheme = uiTheme
		super.init(frame: .zero)
		setupUI()
	}

	/// no:doc
	required init?(coder: NSCoder) {
		fatalError("not implemented")
	}

	private func setupUI() {
		addSubview(stackView)
		stackView.checkout_constraintViewToSuperviewEdges()
	}
}
