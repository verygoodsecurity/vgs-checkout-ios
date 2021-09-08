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

	/// Holds view ui state.
	internal var viewUIState: ValidationViewUIState = .initial {
		didSet {
			updateUI()
		}
	}

	// MARK: - Vars

	/// A boolean flag indicating that view already has an error. Use this flag to track that we have an error at least once so we need to keep error label space.
	private var hasError: Bool = false

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

		return label
	}()

	/// Empty padding view with fixed height.
	private lazy var emptyView: UIView = {
		let view = UIView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		view.heightAnchor.constraint(equalToConstant: 16).isActive = true

		return view
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

		stackView.addArrangedSubview(emptyView)
	}

	/// Updates view UI.
	private func updateUI() {
		switch viewUIState {
		case .initial:
			break
		case .error(let errorText):
			hasError = true
			addErrorLabelIfNeeded()
			errorLabel.text = errorText
		case .valid:
			// Dispay error label only if we have an error.
			if hasError {
				addErrorLabelIfNeeded()
				errorLabel.text = String.checkoutEmptyErrorText
			}
		}
	}

	/// Add error label once.
	private func addErrorLabelIfNeeded() {
		if stackView.arrangedSubviews.first(where: {$0 === errorLabel}) == nil {
			// Hide empty view.
			emptyView.isHiddenInCheckoutStackView = true

			// Add error label.
			stackView.addArrangedSubview(errorLabel)
			stackView.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 8, right: 0)

			if isLastRow {
				stackView.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 16, right: 0)
			}
			stackView.isLayoutMarginsRelativeArrangement = true
		}
	}
}
