//
//  VGSPlaceholderFieldView.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal protocol VGSPlaceholderFieldViewDelegate: AnyObject {
	func didTap(in formView: VGSPlaceholderFieldView)
}

/// View for placeholder item in form.
internal class VGSPlaceholderFieldView: UIView {

	// MARK: - Vars

	weak var delegate: VGSPlaceholderFieldViewDelegate?

	internal let tapGesture = UITapGestureRecognizer()

	/// Stack view.
	internal lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .fill

		return stackView
	}()

	/// Hint component view.
	internal lazy var hintComponentView: VGSFieldHintView = {
		let view = VGSFieldHintView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	/// Hint label.
	internal var hintLabel: UILabel {
		return hintComponentView.label
	}

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

	/// Setup UI and basic layout.
	fileprivate func setupUI() {
		addSubview(stackView)
		stackView.checkout_constraintViewToSuperviewEdges()

		stackView.addArrangedSubview(hintComponentView)

		hintComponentView.addGestureRecognizer(tapGesture)
		tapGesture.addTarget(self, action: #selector(handleTap))

		layer.cornerRadius = 4
		layer.masksToBounds = true
	}

	@objc fileprivate func handleTap() {
		delegate?.didTap(in: self)
	}
}
