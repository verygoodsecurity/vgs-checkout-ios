//
//  VGSCheckoutHeaderView.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Header view model.
internal struct VGSCheckoutHeaderViewModel {

	/// Attributed title.
	internal let text: String
}

/// Header view.
internal class VGSCheckoutHeaderView: UIView {

	// MARK: - Vars

	/// Stack view.
	internal lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.alignment = .fill
		return stackView
	}()

	/// Title label.
	internal lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontForContentSizeCategory = true

		label.textAlignment = .left

		return label
	}()

	// MARK: - Initialization

	/// :nodoc:
	override init(frame: CGRect) {
		super.init(frame: .zero)

		setupUI()
	}

	/// :nodoc:
	required init?(coder: NSCoder) {
		fatalError("not implemented")
	}

	// MARK: - Interface

	/// Configure with header view model.
	/// - Parameter model: `VGSCheckoutHeaderViewModel` object, view model.
	/// - Parameter uiTheme: `VGSCheckoutThemeProtocol` object, ui theme.
	internal func configure(with model: VGSCheckoutHeaderViewModel, uiTheme: VGSCheckoutThemeProtocol) {
		titleLabel.text = model.text
		titleLabel.font = uiTheme.checkoutFormSectionTitleFont
	}

	// MARK: - Helpers

	/// Setup basic UI and layout.
	private func setupUI() {
		addSubview(stackView)
		stackView.checkout_constraintViewToSuperviewEdges()

		stackView.addArrangedSubview(titleLabel)
	}
}
