//
//  VGSPayWithCardHeaderView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// View for pay with card header.
internal class VGSPayWithCardHeaderView: UIView {

	// MARK: - Vars

	// This is adapted from https://github.com/noahsark769/ColorCompatibility
	// Copyright (c) 2019 Noah Gilmore <noah.w.gilmore@gmail.com>
	/// Separator color.
	static var separatorColor: UIColor {
			if #available(iOS 13, *) {
					return .opaqueSeparator
			}
			return UIColor(
					red: 0.7764705882352941, green: 0.7764705882352941, blue: 0.7843137254901961, alpha: 1.0
			)
	}

	/// Hint label
	internal lazy var hintLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Or pay with a card"
		label.font = UIFont.preferredFont(forTextStyle: .headline)
		label.adjustsFontForContentSizeCategory = true
		label.textColor = UIColor.gray

		return label
	}()

	/// Stack view.
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.axis = .horizontal
		stackView.spacing = 6
		stackView.distribution = .fill

		return stackView
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
		let leftView = VGSPayWithCardHeaderView.buildLineView()
		let rightView = VGSPayWithCardHeaderView.buildLineView()
		stackView.addArrangedSubview(leftView)
		stackView.addArrangedSubview(hintLabel)
		stackView.addArrangedSubview(rightView)

		leftView.widthAnchor.constraint(equalTo: rightView.widthAnchor).isActive = true
	}

	/// Build line view.
	/// - Returns: `UIView` object, line view separator.
	static func buildLineView() -> UIView {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false

		let lineView = UIView()
		lineView.translatesAutoresizingMaskIntoConstraints = false
		lineView.backgroundColor = VGSPayWithCardHeaderView.separatorColor

		view.addSubview(lineView)
		let constraints = [
			lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			lineView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			lineView.heightAnchor.constraint(equalToConstant: 1)
		]
		NSLayoutConstraint.activate(constraints)

		return view
	}
}
