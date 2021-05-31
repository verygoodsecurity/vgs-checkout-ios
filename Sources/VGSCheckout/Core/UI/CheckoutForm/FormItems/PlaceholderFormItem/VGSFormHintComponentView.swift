//
//  VGSFormHintComponentView.swift
//  VGSCollectSDK
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

internal class VGSFormHintComponentView: UIView {

	// MARK: - Vars

	internal lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.spacing = 4

		return stackView
	}()

	internal lazy var label: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontForContentSizeCategory = true
		label.font = UIFont.preferredFont(forTextStyle: .title3)

		return label
	}()

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

	internal lazy var hintImageViewContainer: UIView = {
		let view = UIView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(hintImageView)

		let constraints = [
			hintImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			hintImageView.topAnchor.constraint(equalTo: view.topAnchor),
			hintImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//			hintImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		]

		if #available(iOS 11.0, *) {
			hintImageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
		} else {
			// Fallback on earlier versions
		}

//		hintImageView.setContentHuggingPriority(.required, for: .horizontal)
//		hintImageView.setContentCompressionResistancePriority(.required, for: .horizontal)

		NSLayoutConstraint.activate(constraints)

		return view
	}()

	internal lazy var hintImageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false

		return imageView
	}()

	// MARK: - Initialization

	internal override init(frame: CGRect) {
		super.init(frame: .zero)

		setupUI()
	}

	internal required init?(coder: NSCoder) {
		fatalError("not implemented")
	}

	// MARK: - Helpers

	internal func setupUI() {
		addSubview(stackView)
		stackView.checkout_constraintViewToSuperviewEdges()

		stackView.addArrangedSubview(label)
		hintImageViewContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
		stackView.addArrangedSubview(hintImageViewContainer)
	}

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
