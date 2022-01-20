//
//  VGSSavedCardOptionAccessoryView.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// A set of methods to notify about changes in saved card option accessory view.
internal protocol VGSSavedCardOptionAccessoryViewDelegate: AnyObject {

	/// Tells the delegate that remove card button was tapped.
	/// - Parameter view: `VGSSavedCardOptionAccessoryView` object, accessory view object.
	func removeCardDidTapInView(in view: VGSSavedCardOptionAccessoryView)
}

/// Holds UI for saved card accessory options view.
internal class VGSSavedCardOptionAccessoryView: UIView {

	// MARK: - Constants

	/// Remove icon size.
	private let removeCardIconSize: CGSize = CGSize(width: 20, height: 20)

	/// Remove card icon image.
	private let removeCardImage = UIImage(named: "saved_card_remove_card_icon", in: BundleUtils.shared.resourcesBundle, compatibleWith: nil)

	// MARK: - Vars

	internal weak var delegate: VGSSavedCardOptionAccessoryViewDelegate?

	/// Checkbox.
	private let checkbox: VGSRoundedCheckbox

	/// Defines state for view.
	enum AccessoryViewState {

		/// Hidden.
		case hidden

		/// Selected - display checkbox.
		case selected(_ isSelected: Bool)

		/// Delete card - display remove card icon.
		case delete
	}

	/// UI theme.
	private let uiTheme: VGSCheckoutThemeProtocol

	/// Remove card button.
	fileprivate lazy var removeCardButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(removeCardImage, for: .normal)

		return button
	}()

	/// View current state.
	internal var accessoryViewState: AccessoryViewState = .hidden {
		didSet {
			updateUI()
		}
	}

	// MARK: - Initializer

	/// no:doc
	init(uiTheme: VGSCheckoutThemeProtocol) {
		self.uiTheme = uiTheme
		let checkboxTheme = VGSRoundedCheckbox.generateCheckboxThemeForSavedCard(from: uiTheme)
		self.checkbox = VGSRoundedCheckbox(theme: checkboxTheme)
		super.init(frame: .zero)
	}

	/// no:doc
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Interface

	// MARK: - Helpers

	/// Setups UI.
	private func setupUI() {
		setupCheckboxUI()
	}

	/// Setups checkbox UI.
	private func setupCheckboxUI() {
		addSubview(checkbox)
		checkbox.translatesAutoresizingMaskIntoConstraints = false
		checkbox.checkout_constraintViewToSuperviewCenter()
	}

	/// Setups remove button UI.
	private func setupRemoveButtonUI() {
		addSubview(removeCardButton)
		removeCardButton.checkout_constraintViewToSuperviewEdges()
		removeCardButton.addTarget(self, action: #selector(removeCardButtonDidTap), for: .touchUpInside)
	}

	/// Updates UI with current state.
	private func updateUI() {
		switch accessoryViewState {
		case .hidden:
			checkbox.isHidden = true
			removeCardButton.isHidden = true
		case .selected(let isSelected):
			checkbox.isHidden = false
			removeCardButton.isHidden = true
			checkbox.isSelected = isSelected
		case .delete:
			checkbox.isHidden = true
			removeCardButton.isHidden = false
		}
	}

	// MARK: - Actions

	/// Handles tap on remove card button.
	@objc private func removeCardButtonDidTap() {
		delegate?.removeCardDidTapInView(in: self)
	}
}
