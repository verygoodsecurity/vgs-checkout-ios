//
//  VGSFormView.swift
//  VGSCheckoutSDKSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Form view with scroll view and vertical stack view.
internal class VGSFormView: UIView {

	// MARK: - Initialization

	/// Initializer.
	internal init() {
		super.init(frame: .zero)

		setupUI()
	}

	/// :nodoc:
	internal required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	/// Adds a view to form.
	///
	/// - Parameter formItemView: `UIView` object, view to add.
	internal func addFormItemView(_ formItemView: UIView) {
		stackView.addArrangedSubview(formItemView)
	}

	// MARK: - Stack View

	internal lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .fill
		return stackView
	}()

	internal lazy var scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false

		scrollView.showsVerticalScrollIndicator = false

		return scrollView
	}()

	// MARK: - Helpers

	/// Setup basic UI and layout.
	private func setupUI() {
		setupScrollView()
		setupStackView()
	}

	/// Setup scroll view.
	private func setupScrollView() {
		addSubview(scrollView)
		scrollView.checkout_constraintViewToSuperviewEdges()
	}

	/// Setup stack view.
	private func setupStackView() {
		scrollView.addSubview(stackView)
		stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
		stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
		stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
	}
}
