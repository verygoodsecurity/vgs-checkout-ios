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

		/// Hide error keeping the error label to avoid jumping UI.
		case isValid
	}

	/// Holds view ui state.
	internal var viewUIState: ValidationViewUIState = .initial {
		didSet {
			updateUI()
		}
	}

	// MARK: - Vars

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
	private lazy var errorLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false

		label.adjustsFontForContentSizeCategory = true

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

	/// no:doc
	override var intrinsicContentSize: CGSize {
		let height = max(super.intrinsicContentSize.height, 30)
		return CGSize(width: UIView.noIntrinsicMetric, height: height)
	}

	// MARK: - Private

	/// Setup UI and layout.
	private func setupUI() {
		addSubview(stackView)
		stackView.checkout_constraintViewToSuperviewEdges()

		stackView.addArrangedSubview(errorLabel)
	}

	/// Updates view UI.
	private func updateUI() {
		switch viewUIState {
		case .initial:
			break
			// Hide error label.
		default:
			break
		}
	}
}
