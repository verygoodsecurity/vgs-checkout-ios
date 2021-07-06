//
//  VGSBillingAddressDetailsView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for card details.
internal class VGSBillingAddressDetailsView: UIView, VGSFormGroupViewProtocol {

	/// Form items.
	internal var formItems: [VGSTextFieldFormItemProtocol] = []

	/// Displays error messages for invalid card details.
	internal let errorLabel = VGSAddCardFormViewBuilder.buildErrorLabel()

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

	// TODO: - move to separe block for address.
	/// Country form item.
	internal lazy var countryFormItemView: VGSCountryFormItemView = {
		let componentView = VGSCountryFormItemView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false

		return componentView
	}()

	/// Header view.
	internal lazy var headerView: VGSCheckoutHeaderView = {
		let headerView = VGSCheckoutHeaderView(frame: .zero)
		headerView.translatesAutoresizingMaskIntoConstraints = false

		let title = NSMutableAttributedString(string: "Billing Address")
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

	/// Update Array of form blocks with validation state.
	internal func updateFormBlocks(_ formBlocks: [VGSAddCardFormBlock], isValid: Bool) {
		formBlocks.forEach { formBlock in
			updateFormBlock(formBlock, isValid: isValid)
		}
	}

	/// Update Form block items UI with validation state.
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
		case .addressInfo:
			break
		}
	}

	/// Disable input view for processing state.
	internal func updateUIForProcessingState() {
		// Update grid view.
		if #available(iOS 13, *) {
			cardHolderDetailsView.cardHolderNameStackView.separatorColor = UIColor.systemGray
			cardHolderDetailsView.cardHolderNameStackView.borderView.layer.borderColor = UIColor.systemGray.cgColor
			verticalStackView.borderView.layer.borderColor = UIColor.systemGray.cgColor
		} else {
			cardHolderDetailsView.cardHolderNameStackView.separatorColor = UIColor.gray
			cardHolderDetailsView.cardHolderNameStackView.borderView.layer.borderColor = UIColor.gray.cgColor
			verticalStackView.borderView.layer.borderColor = UIColor.gray.cgColor
		}

		// Update form fields.
		formItems.forEach { formItem in
			if #available(iOS 13.0, *) {
				formItem.formItemView.backgroundColor = .systemGroupedBackground
				formItem.textField.textColor = UIColor.placeholderText
				formItem.formItemView.hintComponentView.label.textColor = UIColor.placeholderText
			} else {
				formItem.formItemView.backgroundColor = .white
				formItem.textField.textColor = .gray
				formItem.formItemView.hintComponentView.label.textColor = .gray
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
			default:
				break
			}
		case .multiplexing:
			cardHolderDetailsView.translatesAutoresizingMaskIntoConstraints = false
			rootStackView.addArrangedSubview(cardHolderDetailsView)
		}

		rootStackView.addArrangedSubview(verticalStackView)

		cardNumberFormItemView.formItemView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
		cardNumberFormItemView.formItemView.stackView.isLayoutMarginsRelativeArrangement = true

		verticalStackView.addArrangedSubview(cardNumberFormItemView)

		rootStackView.addArrangedSubview(errorLabel)
		errorLabel.isHiddenInCheckoutStackView = true

		// Gather all form items.
		formItems = cardHolderDetailsView.formItems + [
			cardNumberFormItemView,
			expDateFormItemView,
			cvcFormItemView,
			//countryFormItemView
		]

		// Test country field
		//verticalStackView.addArrangedSubview(countryFormItemView)

		formItems.first?.textField.becomeFirstResponder()
	}
}
