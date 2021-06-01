//
//  VGSCheckoutCardFormView.swift
//  VGSCollectSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal class VGSCheckoutCardFormView: UIView {

	internal enum CardHolderNameType {
		case none
		case single(_ cardHolder: VGSCardholderFormItemView)
		case splitted(_ firstName: VGSCardholderFormItemView, _ lastName: VGSCardholderFormItemView)
	}

	// MARK: - Vars

	fileprivate var cardHolderNameType: CardHolderNameType

	/// Card number view.
	internal lazy var cardNumberComponentView: VGSCardNumberFormItemView = {
		let componentView = VGSCardNumberFormItemView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false
		
		return componentView
	}()

	/// Exp date view.
	internal lazy var expDateComponentView: VGSExpirationDateFormItemView = {
		let componentView = VGSExpirationDateFormItemView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false

		return componentView
	}()

	/// CVC view.
	internal lazy var cvcDateComponentView: VGSCVCFormItemView = {
		let componentView = VGSCVCFormItemView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false

		return componentView
	}()

	/// Container view for header to add insets.
	internal lazy var headerContainerView: VGSContainerItemView = {
		let view = VGSContainerItemView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.paddings = UIEdgeInsets(top: 16, left: 0, bottom: -8, right: 0)

		return view
	}()

	/// Header view.
	internal lazy var headerView: VGSCheckoutHeaderView = {
		let headerView = VGSCheckoutHeaderView(frame: .zero)
		headerView.translatesAutoresizingMaskIntoConstraints = false

		let title = NSMutableAttributedString(string: "Card Details")
		let model = VGSCheckoutHeaderViewModel(attibutedTitle: title)

		headerView.configure(with: model)

		return headerView
	}()

	/// Root stack view.
	internal lazy var rootStackView: UIStackView = {
		let stackView = UIStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fill
		stackView.axis = .vertical

		stackView.spacing = 8

		return stackView
	}()

	/// Vertical stack view for all fields.
	internal lazy var verticalStackView: VGSSeparatedStackView = {
		let stackView = VGSSeparatedStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fill
		stackView.axis = .vertical
		stackView.hasBorderView = true
		stackView.borderViewCornerRadius = 4
		
		stackView.spacing = 1
		stackView.separatorColor = UIColor.gray

		return stackView
	}()

	/// Horizontal stack view for exp date and cvc.
	internal lazy var horizonalStackView: VGSSeparatedStackView = {
		let stackView = VGSSeparatedStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.distribution = .fillEqually
		stackView.axis = .horizontal

		stackView.spacing = 1
		stackView.separatorColor = UIColor.gray

		return stackView
	}()

	/// Horizontal stack view for card holder name.
	internal lazy var cardHolderNameStackView: VGSSeparatedStackView = {
		let stackView = VGSSeparatedStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.distribution = .fillEqually
		stackView.axis = .horizontal

		stackView.hasBorderView = true
		stackView.borderViewCornerRadius = 4

		stackView.spacing = 1
		stackView.separatorColor = UIColor.gray

		return stackView
	}()

	// MARK: - Initialization

	override init(frame: CGRect) {
		let holderNameItemView = VGSCardholderFormItemView(frame: .zero)
		self.cardHolderNameType = .single(holderNameItemView)

//		let firstNameItemView = VGSCardholderFormItemView(frame: .zero)
//		let lastNameItemView = VGSCardholderFormItemView(frame: .zero)
//		self.cardHolderNameType = .splitted(firstNameItemView, lastNameItemView)

		super.init(frame: .zero)

		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("Not implemented")
	}

	// MARK: - Interface

	// MARK: - Helpers

	/// Setup UI and layout.
	private func setupUI() {
		addSubview(rootStackView)
		rootStackView.checkout_constraintViewToSuperviewEdges()

		headerContainerView.addContentView(headerView)
		rootStackView.addArrangedSubview(headerContainerView)

		switch cardHolderNameType {
		case .single(let itemView):
			rootStackView.addArrangedSubview(cardHolderNameStackView)
			cardHolderNameStackView.addArrangedSubview(itemView)
			itemView.placeholderComponent.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
			itemView.placeholderComponent.stackView.isLayoutMarginsRelativeArrangement = true

			itemView.cardHolderName.placeholder = "John Doe"
			itemView.placeholderComponent.hintComponentView.label.text = "Cardholder"
		case .splitted(let firstNameItemView, let lastNameItemView):
			rootStackView.addArrangedSubview(cardHolderNameStackView)
			cardHolderNameStackView.addArrangedSubview(firstNameItemView)
			cardHolderNameStackView.addArrangedSubview(lastNameItemView)

			firstNameItemView.cardHolderName.placeholder = "John"
			lastNameItemView.cardHolderName.placeholder = "Doe"

			firstNameItemView.placeholderComponent.hintComponentView.label.text = "First Name"
			lastNameItemView.placeholderComponent.hintComponentView.label.text = "Last Name"

			firstNameItemView.placeholderComponent.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
			firstNameItemView.placeholderComponent.stackView.isLayoutMarginsRelativeArrangement = true

			lastNameItemView.placeholderComponent.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
			lastNameItemView.placeholderComponent.stackView.isLayoutMarginsRelativeArrangement = true
		case .none:
			break
		}

		rootStackView.addArrangedSubview(verticalStackView)

		cardNumberComponentView.placeholderComponent.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		cardNumberComponentView.placeholderComponent.stackView.isLayoutMarginsRelativeArrangement = true


		expDateComponentView.placeholderComponent.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		expDateComponentView.placeholderComponent.stackView.isLayoutMarginsRelativeArrangement = true

		cvcDateComponentView.placeholderComponent.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		cvcDateComponentView.placeholderComponent.stackView.isLayoutMarginsRelativeArrangement = true

		horizonalStackView.addArrangedSubview(expDateComponentView)
		horizonalStackView.addArrangedSubview(cvcDateComponentView)

		verticalStackView.addArrangedSubview(cardNumberComponentView)
		verticalStackView.addArrangedSubview(horizonalStackView)
	}
}
