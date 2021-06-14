//
//  VGSPlaceholderFormItemView.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal protocol VGSPlaceholderFormItemViewDelegate: AnyObject {
	func didTap(in formView: VGSPlaceholderFormItemView)
}

/// View for placeholder item in form.
internal class VGSPlaceholderFormItemView: UIView {

	/// The zPosition property specifies the z-axis component of the layer's position. The zPosition is intended to be used to set the visual position of the layer relative to its sibling layers. It should not be used to specify the order of layer siblings, instead reorder the layer in the sublayer array.
	/// Thats why we need to add all borders views to one parent view to handle zPosition correctly.
	weak var borderViewSuperView: UIView?

	// MARK: - Vars

	weak var delegate: VGSPlaceholderFormItemViewDelegate?

	internal let tapGesture = UITapGestureRecognizer()
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
		hintComponentView.addGestureRecognizer(tapGesture)
		tapGesture.addTarget(self, action: #selector(handleTap))
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		if borderViewSuperView != nil && borderView.superview == nil {
			borderViewSuperView?.addSubview(borderView)
		}

		if let view = borderViewSuperView {
			let convertedFrame = convert(frame, to: view)
			borderView.frame = convertedFrame.inset(by: UIEdgeInsets(top: -2, left: -2, bottom: -2, right: -2))
		}


//		borderView.frame = bounds.inset(by: UIEdgeInsets(top: -1, left: -1, bottom: -1, right: -1))
		borderView.layer.borderWidth = 2
		borderView.layer.zPosition = 99
		borderView.layer.maskedCorners = borderCornerMasks
		borderView.isUserInteractionEnabled = false
		borderView.layer.cornerRadius = 4
	}

	internal func increaseBorderZPosition() {
		borderView.layer.zPosition = 999
		guard let view = borderViewSuperView else {
			return
		}

		let convertedFrame = convert(frame, to: view)
		borderView.frame = convertedFrame.inset(by: UIEdgeInsets(top: -2, left: -2, bottom: -2, right: -2))
		borderView.layer.borderWidth = 2
		let a = superview?.superview
	}

	internal func decreaseBorderZPosition() {
		borderView.layer.zPosition = 1
		guard let view = borderViewSuperView else {
			return
		}

		let convertedFrame = convert(frame, to: view)
		borderView.frame = convertedFrame.inset(by: UIEdgeInsets(top: -1, left: -1, bottom: -1, right: -1))
		borderView.layer.borderWidth = 1
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

	@objc fileprivate func handleTap() {
		delegate?.didTap(in: self)
	}
}
