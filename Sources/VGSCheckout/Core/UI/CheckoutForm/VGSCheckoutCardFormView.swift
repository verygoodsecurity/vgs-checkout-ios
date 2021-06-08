//
//  VGSCheckoutCardFormView.swift
//  VGSCollectSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal struct VGSFieldGroup {
	internal let fieldView: [[UIView]]
}

internal class VGSCheckoutCardFormView: UIView {

	/// Defines field distribution for cvc/exp date.
	internal enum DateAndCVCFieldsDistribution {
		case singleLine
		case doubleLine
	}

	/// Fields distribution.
	internal var fieldsDistribution: DateAndCVCFieldsDistribution = .singleLine

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

	/// Card holder view.
	internal let cardHolderDetailsView: VGSCardHolderDetailsView

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

	/// Payment instrument.
	fileprivate let paymentInstrument: VGSPaymentInstrument

	// MARK: - Initialization

	/// Initialization.
	/// - Parameter paymentInstrument: `VGSPaymentInstrument` object, payment instrument.
	init(paymentInstrument: VGSPaymentInstrument) {
		self.paymentInstrument = paymentInstrument
		self.cardHolderDetailsView = VGSCardHolderDetailsView(paymentInstrument: paymentInstrument)
		super.init(frame: .zero)

		setupUI()
	}

	/// no:doc
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

		switch paymentInstrument {
		case .vault(let configuration):
			switch configuration.cardHolderFieldOptions.fieldVisibility {
			case .visible:
				cardHolderDetailsView.translatesAutoresizingMaskIntoConstraints = false
				rootStackView.addArrangedSubview(cardHolderDetailsView)
			default:
				break
			}
		}

		rootStackView.addArrangedSubview(verticalStackView)

		cardNumberComponentView.placeholderComponent.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		cardNumberComponentView.placeholderComponent.stackView.isLayoutMarginsRelativeArrangement = true

		expDateComponentView.placeholderComponent.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		expDateComponentView.placeholderComponent.stackView.isLayoutMarginsRelativeArrangement = true

		cvcDateComponentView.placeholderComponent.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		cvcDateComponentView.placeholderComponent.stackView.isLayoutMarginsRelativeArrangement = true

		switch fieldsDistribution {
		case .singleLine:
			break
		case .doubleLine:
			horizonalStackView.axis = .vertical
		}

		horizonalStackView.addArrangedSubview(expDateComponentView)
		horizonalStackView.addArrangedSubview(cvcDateComponentView)

		verticalStackView.addArrangedSubview(cardNumberComponentView)
		verticalStackView.addArrangedSubview(horizonalStackView)
	}
}
