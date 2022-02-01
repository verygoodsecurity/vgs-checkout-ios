//
//  VGSCheckboxButton.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// UI for checkbox button.
internal class VGSCheckboxButton: UIControl {

	// MARK: - Vars
  
	/// Stack view.
	internal lazy var stackView: UIStackView = {
		let stackView = UIStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fill
		stackView.axis = .horizontal

		stackView.spacing = 8

		return stackView
	}()
  
  var onTap: (() -> Void)?

	/// Checkbox.
	internal let checkbox: VGSCheckbox

	/// Button title.
	internal lazy var label: UILabel = {
		let label = UILabel()
		label.font = .preferredFont(forTextStyle: .footnote)
		label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		label.setContentHuggingPriority(.defaultLow, for: .horizontal)
		label.numberOfLines = 2
		label.isAccessibilityElement = false
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	/// Checkbox container view.
	fileprivate lazy var checkboxContainerView: UIView = {
		let view = UIView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	// MARK: - Initializer

	/// no:doc
	internal init(text: String, theme: VGSCheckoutThemeProtocol) {
		checkbox = VGSCheckbox(theme: theme)

		super.init(frame: .zero)

		isAccessibilityElement = true
		accessibilityLabel = text
		accessibilityTraits = UISwitch().accessibilityTraits
		label.text = text
//		label.textColor = theme.checkoutCheckboxHintColor
//		label.font = theme.checkoutCheckboxHintFont

		checkbox.translatesAutoresizingMaskIntoConstraints = false
		checkboxContainerView.addSubview(checkbox)
		checkbox.centerXAnchor.constraint(equalTo: checkboxContainerView.centerXAnchor).isActive = true
		checkbox.centerYAnchor.constraint(equalTo: checkboxContainerView.centerYAnchor).isActive = true
		checkboxContainerView.widthAnchor.constraint(equalToConstant: 22).isActive = true
		checkbox.backgroundColor = .clear

		addSubview(stackView)
		stackView.checkout_constraintViewToSuperviewEdges()

		stackView.addArrangedSubview(checkboxContainerView)
		stackView.addArrangedSubview(label)

		let didTapGestureRecognizer = UITapGestureRecognizer(
			target: self, action: #selector(didTap))
		addGestureRecognizer(didTapGestureRecognizer)
	}

	/// no:doc
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	/// Indicates selection state.
	override var isSelected: Bool {
		didSet {
			if isSelected {
				accessibilityTraits.update(with: .selected)
			} else {
				accessibilityTraits.remove(.selected)
			}
			checkbox.isSelected = isSelected
		}
	}

	// MARK: - Override

	// no:doc
	override var isEnabled: Bool {
		didSet {
			checkbox.isUserInteractionEnabled = isEnabled
			label.isUserInteractionEnabled = isEnabled
		}
	}

	// MARK: - Actions

	/// Handles tap action.
	@objc private func didTap() {
		isSelected.toggle()
		sendActions(for: .touchUpInside)
    onTap?()
	}
}
