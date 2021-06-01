//
//  VGSFormHintComponentView.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Form component for hint.
internal class VGSFormHintView: UIView {

	// MARK: - Vars

	/// Stack view.
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 4

		return stackView
	}()

	/// Hint label.
	internal lazy var label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontForContentSizeCategory = true
		label.font = UIFont.preferredFont(forTextStyle: .title3)

		return label
	}()

	/// Accessory type, default is `none`.
	internal var accessory: VGSCheckoutHintItemType = .none {
		didSet {
			switch accessory {
			case .none:
				hideAllExceptLabel()
			case .invalid:
				hintImageViewContainer.isHidden = false
//				hintImageView.image = UIImage(named: "invalid_state_icon", in: AssetsBundle.main.iconBundle, compatibleWith: nil)
			case .valid:
				hintImageViewContainer.isHidden = false
//				hintImageView.image = UIImage(named: "valid_state_icon", in: AssetsBundle.main.iconBundle, compatibleWith: nil)
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
			hintImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			hintImageView.topAnchor.constraint(equalTo: view.topAnchor),
			hintImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		]

		NSLayoutConstraint.activate(constraints)
		return view
	}()

	/// Hint image view.
	private lazy var hintImageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false

		imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
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

		stackView.addArrangedSubview(label)
		hintImageViewContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
		stackView.addArrangedSubview(hintImageViewContainer)
	}

	/// Hide allv views except hint label.
	internal func hideAllExceptLabel() {
		let allOtherSubviewsExceptLabel = stackView.arrangedSubviews.filter { $0 != label}
		allOtherSubviewsExceptLabel.forEach { view in
			view.isHidden = true
		}
	}
}

internal enum VGSCheckoutHintItemType {
	case none
	case valid
	case invalid
	case custom(UIView)
}
