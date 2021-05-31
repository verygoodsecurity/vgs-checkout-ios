//
//  VGSPlaceholderComponentView.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

class VGSPlaceholderComponentView: UIView {

	// MARK: - Vars

	lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .fill

		return stackView
	}()

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

	// MARK: - Helpers

	func setupUI() {
		addSubview(stackView)
		stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		stackView.addArrangedSubview(hintComponentView)
	}

	func updateUI(for validationState: VGSCheckoutFormValidationState) {
		switch validationState {
		case .none:
			hintComponentView.accessory = .none
		case .valid:
			hintComponentView.accessory = .valid
		case .invalid:
			hintComponentView.accessory = .invalid
		}
	}
}
