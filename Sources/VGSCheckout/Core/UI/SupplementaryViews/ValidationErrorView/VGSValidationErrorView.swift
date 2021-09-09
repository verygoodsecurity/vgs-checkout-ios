//
//  VGSValidationErrorView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// View to display validation errors.
internal class VGSValidationErrorView: UIView {

	/// Defines validation view UI state.
	internal enum ValidationViewUIState {

		/// Error hasn't been displayed yet.
		case initial

		/// Display error.
		case error(_ text: String)

		/// Hide error text keeping the error label space to avoid jumping UI.
		case valid
	}

	/// Constraint for error label height to display padding when no error.
	private var errorLabelHeightConstraint: NSLayoutConstraint?

	/// Holds view ui state.
	internal var viewUIState: ValidationViewUIState = .initial {
		didSet {
			updateUI()
		}
	}

	// MARK: - Vars

	/// A boolean flag indicating that view already has an error. Use this flag to track that we have an error at least once so we need to keep error label space.
	private var isDirty: Bool = false

	/// A boolean flag indicating field is in last row so extra bottom inset is required to adjust paddings for last field view.
	internal var isLastRow: Bool = false

	/// Stack view.
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.axis = .vertical
		stackView.spacing = 0
		stackView.distribution = .fill

		return stackView
	}()

	/// Error label.
	internal lazy var errorLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false

		label.adjustsFontForContentSizeCategory = true
		label.numberOfLines = 0

		return label
	}()

	// MARK: - Initialization

	/// no:doc
	override init(frame: CGRect) {
		super.init(frame: frame)

		setupUI()
	}

	/// no:doc
	required init?(coder: NSCoder) {
		fatalError("Not implemented")
	}

	// MARK: - Interface

	// MARK: - Private

	/// Setup UI and layout.
	private func setupUI() {
		addSubview(stackView)
		stackView.checkout_constraintViewToSuperviewEdges()

		stackView.addArrangedSubview(errorLabel)
		errorLabelHeightConstraint = errorLabel.heightAnchor.constraint(equalToConstant: 16)
		errorLabelHeightConstraint?.isActive = true
	}

	/// Updates view UI.
	private func updateUI() {
		switch viewUIState {
		case .initial:
			break
		case .error(let errorText):
			isDirty = true
			updateErrorLabelLayout()
			errorLabel.text = errorText
		case .valid:
			// Dispay error label only if we have an error.
			if isDirty {
				updateErrorLabelLayout()
				errorLabel.text = String.checkoutEmptyErrorText
			}
		}
	}

	/// Update error label layout.
	private func updateErrorLabelLayout() {
		// Turn off hardcoded label height constraint view.
		errorLabelHeightConstraint?.isActive = false

		// Update stack view insets.
		stackView.addArrangedSubview(errorLabel)
		stackView.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 8, right: 0)

		if isLastRow {
			stackView.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 16, right: 0)
		}
		stackView.isLayoutMarginsRelativeArrangement = true
	}
}
