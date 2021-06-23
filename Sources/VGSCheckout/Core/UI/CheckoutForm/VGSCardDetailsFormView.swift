//
//  VGSCardDetailsFormView.swift
//  VGSCollectSDK
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal struct VGSFieldGroup {
	internal let fieldView: [[UIView]]
}

internal class VGSCardDetailsFormView: UIView {

	/// Defines field distribution.
	internal enum FieldsDistribution {
		case singleLineDateAndCVC
		case doubleLineDateAndCVC
		case singleLineAll
	}

	/// Form items.
	internal var formItems: [VGSTextFieldFormItemProtocol] = []

	/// Displays error messages for invalid card details.
	internal let cardDetailsErrorLabel = VGSAddCardFormViewBuilder.buildErrorLabel()

	/// Fields distribution.
	internal var fieldsDistribution: FieldsDistribution = .singleLineDateAndCVC

	/// Card number view.
	internal lazy var cardNumberFormItemView: VGSCardNumberFormItemView = {
		let componentView = VGSCardNumberFormItemView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false
		
		return componentView
	}()

	/// Exp date view.
	internal lazy var expDateFormItemView: VGSExpirationDateFormItemView = {
		let componentView = VGSExpirationDateFormItemView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false

		return componentView
	}()

	/// CVC view.
	internal lazy var cvcFormItemView: VGSCVCFormItemView = {
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
		view.paddings = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

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

	internal func updateFormBlock(_ block: VGSAddCardFormBlock, isValid: Bool) {
		switch block {
		case .cardHolder:
			if isValid {
				cardHolderDetailsView.cardHolderNameStackView.separatorColor = UIColor.gray
			} else {
				cardHolderDetailsView.cardHolderNameStackView.separatorColor = UIColor.red
			}
		case .cardDetails:
			if isValid {
				verticalStackView.separatorColor = UIColor.gray
				horizonalStackView.separatorColor = UIColor.gray
			} else {
				verticalStackView.separatorColor = UIColor.red
				horizonalStackView.separatorColor = UIColor.red
			}
		}
	}

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
				cardDetailsErrorLabel.isHidden = true
			default:
				break
			}
		case .multiplexing(let multiplexing):
			cardHolderDetailsView.translatesAutoresizingMaskIntoConstraints = false
			rootStackView.addArrangedSubview(cardHolderDetailsView)
			cardDetailsErrorLabel.isHidden = true
		}

		rootStackView.addArrangedSubview(verticalStackView)

		cardNumberFormItemView.formItemView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		cardNumberFormItemView.formItemView.stackView.isLayoutMarginsRelativeArrangement = true

		verticalStackView.addArrangedSubview(cardNumberFormItemView)

		switch fieldsDistribution {
		case .singleLineDateAndCVC:
			setupDateAndCVC(in: true)
		case .doubleLineDateAndCVC:
			setupDateAndCVC(in: false)
		case .singleLineAll:
			setupAllInSingleLine()
		}

		rootStackView.addArrangedSubview(cardDetailsErrorLabel)
		cardDetailsErrorLabel.isHidden = true

		// Gather all form items.
		formItems = cardHolderDetailsView.formItems + [
			cardNumberFormItemView,
			expDateFormItemView,
			cvcFormItemView
		]

		formItems.first?.textField.becomeFirstResponder()
	}

	private func setupDateAndCVC(in singleLine: Bool) {
		if singleLine {
			horizonalStackView.axis = .horizontal
		} else {
			horizonalStackView.axis = .vertical
		}

		expDateFormItemView.formItemView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		expDateFormItemView.formItemView.stackView.isLayoutMarginsRelativeArrangement = true

		cvcFormItemView.formItemView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		cvcFormItemView.formItemView.stackView.isLayoutMarginsRelativeArrangement = true

		horizonalStackView.addArrangedSubview(expDateFormItemView)
		horizonalStackView.addArrangedSubview(cvcFormItemView)

		verticalStackView.addArrangedSubview(horizonalStackView)
	}

	private func setupAllInSingleLine() {
		expDateFormItemView.formItemView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		expDateFormItemView.formItemView.stackView.isLayoutMarginsRelativeArrangement = true

		cvcFormItemView.formItemView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		cvcFormItemView.formItemView.stackView.isLayoutMarginsRelativeArrangement = true

		verticalStackView.axis = .horizontal
		verticalStackView.addArrangedSubview(expDateFormItemView)
		verticalStackView.addArrangedSubview(cvcFormItemView)
	}
}
