//
//  VGSPlaceholderFormItemView.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// View for placeholder item in form.
internal class VGSPlaceholderFormItemView: UIView {

	// MARK: - Vars

	/// Stack view.
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .fill

		return stackView
	}()

	/// Hint component view.
	internal lazy var hintComponentView: VGSFormHintComponentView = {
		let view = VGSFormHintComponentView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
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

	/// Update UI.
	/// - Parameter validationState: `VGSCheckoutFormValidationState` object, form validation state.
	internal func updateUI(for validationState: VGSCheckoutFormValidationState) {
		switch validationState {
		case .none:
			hintComponentView.accessory = .none
		case .valid:
			hintComponentView.accessory = .valid
		case .invalid:
			hintComponentView.accessory = .invalid
		}
	}

	// MARK: - Helpers

	/// Setup UI and basic layout.
	fileprivate func setupUI() {
		addSubview(stackView)
		stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		stackView.addArrangedSubview(hintComponentView)
	}
}
