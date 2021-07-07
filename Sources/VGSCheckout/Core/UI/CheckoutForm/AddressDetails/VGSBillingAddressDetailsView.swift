//
//  VGSBillingAddressDetailsView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for address details.
internal class VGSBillingAddressDetailsView: UIView, VGSFormGroupViewProtocol {

	/// Form items.
	internal var formItems: [VGSTextFieldFormItemProtocol] = []

	/// Displays error messages for invalid adrdress details.
	internal let errorLabel = VGSAddCardFormViewBuilder.buildErrorLabel()

	/// Container view for header to add insets.
	internal lazy var headerContainerView: VGSContainerItemView = {
		let view = VGSContainerItemView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.paddings = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

		return view
	}()

	/// Country form item view.
	internal lazy var countryFormItemView: VGSCountryFormItemView = {
		let componentView = VGSCountryFormItemView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false

		return componentView
	}()

	/// Address line 1 form item view.
	internal lazy var addressLine1FormItemView: VGSAddressLineFormItemView = {
		let componentView = VGSAddressLineFormItemView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false

		return componentView
	}()

	/// Address line 2 form item view.
	internal lazy var addressLine2FormItemView: VGSAddressLineFormItemView = {
		let componentView = VGSAddressLineFormItemView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false

		return componentView
	}()

	/// City form item view.
	internal lazy var cityItemFormView: VGSCityFormItemView = {
		let componentView = VGSCityFormItemView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false

		return componentView
	}()

	/// State form item view.
	internal lazy var stateFormItemView: VGSStateFormItemView = {
		let componentView = VGSStateFormItemView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false

		return componentView
	}()

	/// ZIP form item view.
	internal lazy var zipFormItemView: VGSZipCodeFormItemView = {
		let componentView = VGSZipCodeFormItemView(frame: .zero)
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

	/// Horizontal stack view for state and cvc.
	internal lazy var stateAndZipStackView: VGSSeparatedStackView = {
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
//		switch block {
//		case .cardHolder:
//			if isValid {
//				cardHolderDetaailsView.cardHolderNameStackView.separatorColor = UIColor.gray
//			} else {
//				cardHolderDetailsView.cardHolderNameStackView.separatorColor = UIColor.red
//			}
//		case .cardDetails:
//			if isValid {
//				verticalStackView.separatorColor = UIColor.gray
//				horizonalStackView.separatorColor = UIColor.gray
//			} else {
//				verticalStackView.separatorColor = UIColor.red
//				horizonalStackView.separatorColor = UIColor.red
//			}
//		case .addressInfo:
//			break
//		}
	}

	/// Disable input view for processing state.
	internal func updateUIForProcessingState() {
		// Update grid view.
//		if #available(iOS 13, *) {
//			cardHolderDetailsView.cardHolderNameStackView.separatorColor = UIColor.systemGray
//			cardHolderDetailsView.cardHolderNameStackView.borderView.layer.borderColor = UIColor.systemGray.cgColor
//			verticalStackView.borderView.layer.borderColor = UIColor.systemGray.cgColor
//		} else {
//			cardHolderDetailsView.cardHolderNameStackView.separatorColor = UIColor.gray
//			cardHolderDetailsView.cardHolderNameStackView.borderView.layer.borderColor = UIColor.gray.cgColor
//			verticalStackView.borderView.layer.borderColor = UIColor.gray.cgColor
//		}

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

		rootStackView.addArrangedSubview(verticalStackView)

		verticalStackView.addArrangedSubview(countryFormItemView)
		verticalStackView.addArrangedSubview(addressLine1FormItemView)
		verticalStackView.addArrangedSubview(addressLine2FormItemView)
		verticalStackView.addArrangedSubview(cityItemFormView)

		stateAndZipStackView.addArrangedSubview(stateFormItemView)
		stateAndZipStackView.addArrangedSubview(zipFormItemView)

		verticalStackView.addArrangedSubview(stateAndZipStackView)

		rootStackView.addArrangedSubview(errorLabel)
		errorLabel.isHiddenInCheckoutStackView = true

		// Gather all form items.
		formItems = [
			countryFormItemView,
			addressLine1FormItemView,
			addressLine2FormItemView,
			cityItemFormView,
			stateFormItemView,
			zipFormItemView
		]
	}
}
