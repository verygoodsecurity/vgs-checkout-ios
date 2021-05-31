//
//  VGSFormView.swift
//  VGSCheckoutSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCollectSDK

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

		return scrollView
	}()

	// MARK: - Private

	private func setupUI() {
		setupScrollView()
		setupStackView()
	}

	// MARK: - Helpers

	private func setupScrollView() {
		addSubview(scrollView)
		scrollView.checkout_constraintViewToSuperviewEdges()
	}

	private func setupStackView() {
		scrollView.addSubview(stackView)
		stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
		stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
		stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
		stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
		stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
	}

	// MARK: - Override

	override internal var intrinsicContentSize: CGSize {
		let targetWidth = superview?.bounds.width ?? UIScreen.main.bounds.width
		let targetHeight = UIView.layoutFittingCompressedSize.height

		let targetSize = CGSize(width: targetWidth, height: targetHeight)

		// Return size of stack view content.
		let size = stackView.systemLayoutSizeFitting(targetSize,
																						 withHorizontalFittingPriority: .required,
																						 verticalFittingPriority: .fittingSizeLevel)

		return size
	}
}
