//
//  VGSCheckbox.swift
//  VGSCheckoutSDK

import Foundation
#if os(iOS)
import UIKit
#endif

/// Custom checkbox control.
internal class VGSCheckbox: UIView {

	/// Unselected state image.
	private let unselectedStateImage = UIImage(named: "radio_button_unselected", in: BundleUtils.shared.resourcesBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)

	/// Checkmark image.
	private let checkmarkImage = UIImage(named: "checkmark", in: BundleUtils.shared.resourcesBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)

	// MARK: - Vars

	/// Image view.
	internal lazy var imageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	/// Image view with checkmark.
	internal lazy var checkmarkImageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.image = checkmarkImage
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	/// Indicates selection state.
	internal var isSelected: Bool = false {
		didSet {
			updateUI()
		}
	}

	/// Theme object.
	fileprivate let theme: VGSCheckoutThemeProtocol

	// MARK: - Override

	init(theme: VGSCheckoutThemeProtocol) {
		self.theme = theme
		super.init(frame: .zero)

		setupUI()
	}

	/// no:doc
	required init?(coder: NSCoder) {
		fatalError("not implemented")
	}

	/// Updates UI.
	internal func updateUI() {
		if isSelected {
			checkmarkImageView.isHidden = false
			imageView.backgroundColor = theme.checkoutCheckboxSelectedColor
			checkmarkImageView.tintColor = theme.checkoutCheckmarkTintColor
			imageView.layer.borderWidth = 0
		} else {
			checkmarkImageView.isHidden = true
			imageView.backgroundColor = .clear
			imageView.layer.borderWidth = 1
			imageView.layer.borderColor = theme.checkoutCheckboxUnselectedColor.cgColor
		}
	}

	/// no:doc
	internal override var intrinsicContentSize: CGSize {
		return CGSize(width: 22, height: 22)
	}

	/// Setup UI.
	private func setupUI() {
		addSubview(imageView)
		imageView.checkout_constraintViewToSuperviewEdges()
		addSubview(checkmarkImageView)
		checkmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		checkmarkImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		checkmarkImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
		checkmarkImageView.heightAnchor.constraint(equalToConstant: 8).isActive = true

		imageView.layer.cornerRadius = 3
		imageView.layer.masksToBounds = true
	}
}
