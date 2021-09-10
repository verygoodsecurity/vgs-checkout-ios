//
//  VGSFormHintComponentView.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Form component for hint.
internal class VGSFieldHintView: UIView {

	/// Defines hint accessory type.
	internal enum HintItemType {

		/// No accessory view.
		case none

		/// View for invalid state.
		case invalid

		/// Custom view.
		case custom(UIView)
	}

	// MARK: - Vars

	/// Stack view.
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 6

		return stackView
	}()

	/// Hint label.
	internal lazy var label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false

		label.adjustsFontForContentSizeCategory = true
    label.numberOfLines = 0

		return label
	}()

	/// Accessory type, default is `none`.
	internal var accessory: HintItemType = .none {
		didSet {
			switch accessory {
			case .none:
				hideAllExceptLabel()
			case .invalid:
				hintImageViewContainer.isHiddenInCheckoutStackView = false
				hintImageView.image = UIImage(named: "invalid_state_icon", in: BundleUtils.shared.resourcesBundle, compatibleWith: nil)
			case .custom(let view):
				hideAllExceptLabel()
				stackView.addArrangedSubview(view)
			}
		}
	}

	/// Container for hint image view.
	internal lazy var hintImageViewContainer: UIView = {
		let view = UIView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(hintImageView)

		let constraints = [
			view.widthAnchor.constraint(equalTo: hintImageView.widthAnchor),
			hintImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			hintImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		]

		NSLayoutConstraint.activate(constraints)
		return view
	}()

	/// Hint image view.
	private lazy var hintImageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false

		imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
		imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true

		// imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
		return imageView
	}()

	// MARK: - Initialization

	/// no:doc
	internal override init(frame: CGRect) {
		super.init(frame: .zero)

		setupUI()
	}

	/// no:doc
	internal required init?(coder: NSCoder) {
		fatalError("not implemented")
	}

	// MARK: - Helpers

	/// Build basic UI and layout.
	internal func setupUI() {
		addSubview(stackView)
		stackView.checkout_constraintViewToSuperviewEdges()

		stackView.addArrangedSubview(hintImageViewContainer)
		stackView.addArrangedSubview(label)
	}

	/// Hide allv views except hint label.
	internal func hideAllExceptLabel() {
		let allOtherSubviewsExceptLabel = stackView.arrangedSubviews.filter { $0 != label}
		allOtherSubviewsExceptLabel.forEach { view in
			view.isHiddenInCheckoutStackView = true
		}
	}
}
