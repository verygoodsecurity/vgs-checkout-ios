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

	fileprivate let borderView = UIView()

	internal var borderCornerMasks: CACornerMask = []

	/// Stack view.
	internal lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .fill

		return stackView
	}()

	/// Hint component view.
	internal lazy var hintComponentView: VGSFormHintView = {
		let view = VGSFormHintView(frame: .zero)
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
		stackView.checkout_constraintViewToSuperviewEdges()

		stackView.addArrangedSubview(hintComponentView)

		borderView.isHidden = true
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		if superview != nil && borderView.superview == nil {
			superview?.addSubview(borderView)
		}
		borderView.frame = superview!.bounds.inset(by: UIEdgeInsets(top: -1, left: -1, bottom: -1, right: -1))
		borderView.layer.borderWidth = 2
		borderView.layer.zPosition = 99
		borderView.layer.maskedCorners = borderCornerMasks
		borderView.layer.cornerRadius = 4
	}

	internal func highlight(with color: UIColor) {
		UIView.animate(withDuration: 0.1) {
			self.borderView.layer.borderColor = color.cgColor
			self.borderView.isHidden = false
		}
	}

	internal func removeHighlight() {
		UIView.animate(withDuration: 0.1) {
			self.borderView.isHidden = true
		}
	}
}
