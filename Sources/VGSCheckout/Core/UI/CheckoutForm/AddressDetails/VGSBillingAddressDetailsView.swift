//
//  VGSBillingAddressDetailsView.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for address details.
internal class VGSBillingAddressDetailsSectionView: UIView, VGSFormSectionViewProtocol {

	/// UI Theme.
  internal var uiTheme: VGSCheckoutThemeProtocol

	/// Form items.
	internal var fieldViews: [VGSTextFieldViewProtocol] = []
  
	/// Displays error messages for invalid adrdress details.
  internal let errorLabel: UILabel

	/// Container view for header to add insets.
	internal lazy var headerContainerView: VGSContainerItemView = {
		let view = VGSContainerItemView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.paddings = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

		return view
	}()

	/// Country form item view.
	internal lazy var countryFieldView: VGSCountryFieldView = {
		let componentView = VGSCountryFieldView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false

		return componentView
	}()

	/// Address line 1 form item view.
	internal lazy var addressLine1FieldView: VGSAddressLineFieldView = {
		let componentView = VGSAddressLineFieldView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false

		return componentView
	}()

	/// Address line 2 form item view.
	internal lazy var addressLine2FieldView: VGSAddressLineFieldView = {
		let componentView = VGSAddressLineFieldView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false

		return componentView
	}()

	/// City form item view.
	internal lazy var cityFieldView: VGSCityFieldView = {
		let componentView = VGSCityFieldView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false

		return componentView
	}()

	/// region form item view.
	internal lazy var regionFieldView: VGSStateFieldView = {
		let componentView = VGSStateFieldView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false

		return componentView
	}()

	/// State form item view.
	internal lazy var statePickerFieldView: VGSStatePickerFieldView = {
		let componentView = VGSStatePickerFieldView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false

		return componentView
	}()

	/// Postal Code/Zip form item view.
	internal lazy var postalCodeFieldView: VGSPostalCodeFieldView = {
		let componentView = VGSPostalCodeFieldView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false

		return componentView
	}()

	/// Header view.
	internal lazy var headerView: VGSCheckoutHeaderView = {
		let headerView = VGSCheckoutHeaderView(frame: .zero)
		headerView.translatesAutoresizingMaskIntoConstraints = false

		let title = "Billing Address"
		let model = VGSCheckoutHeaderViewModel(text: title)

		headerView.configure(with: model, uiTheme: uiTheme)

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
		stackView.separatorColor = uiTheme.textFieldBorderColor

		return stackView
	}()

	/// Horizontal stack view for state and cvc.
	internal lazy var stateAndPostalCodeStackView: VGSSeparatedStackView = {
		let stackView = VGSSeparatedStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.distribution = .fillEqually
		stackView.axis = .horizontal

		stackView.spacing = 1
		stackView.separatorColor = uiTheme.textFieldBorderColor

		return stackView
	}()

	/// Payment instrument.
	fileprivate let paymentInstrument: VGSPaymentInstrument

	// MARK: - Initialization

	/// Initialization.
	/// - Parameter paymentInstrument: `VGSPaymentInstrument` object, payment instrument.
  init(paymentInstrument: VGSPaymentInstrument, uiTheme: VGSCheckoutThemeProtocol) {
		self.paymentInstrument = paymentInstrument
    self.uiTheme = uiTheme
    self.errorLabel = VGSAddCardFormViewBuilder.buildErrorLabel(with: uiTheme)
		super.init(frame: .zero)

		setupUI()
	}

	/// no:doc
	required init?(coder: NSCoder) {
		fatalError("Not implemented")
	}

	// MARK: - Interface

	/// Update Array of form blocks with validation state.
	internal func updateSectionBlocks(_ sectionBlocks: [VGSAddCardSectionBlock], isValid: Bool) {
		sectionBlocks.forEach { sectionBlock in
      updateSectionBlock(sectionBlock, isValid: isValid)
		}
	}

	/// Update Form block items UI with validation state.
	internal func updateSectionBlock(_ block: VGSAddCardSectionBlock, isValid: Bool) {
		switch block {
		case .addressInfo:
			if isValid {
				verticalStackView.separatorColor = uiTheme.textFieldBorderColor
			} else {
				verticalStackView.separatorColor = uiTheme.textFieldBorderErrorColor
			}
		default:
		 break
		}
	}

	// TODO: - refactor duplicated code for processing state styles.
	/// Disable input views for processing state.
	internal func updateUIForProcessingState() {
		 /// Update grid view.
		if #available(iOS 13, *) {
			verticalStackView.borderView.layer.borderColor = UIColor.systemGray.cgColor
		} else {
			verticalStackView.borderView.layer.borderColor = UIColor.gray.cgColor
		}

		// Update form fields.
		fieldViews.forEach { fieldView in
			if #available(iOS 13.0, *) {
				fieldView.placeholderView.backgroundColor = .systemGroupedBackground
				fieldView.textField.textColor = UIColor.placeholderText
				fieldView.placeholderView.hintComponentView.label.textColor = UIColor.placeholderText
			} else {
				fieldView.placeholderView.backgroundColor = .white
				fieldView.textField.textColor = .gray
				fieldView.placeholderView.hintComponentView.label.textColor = .gray
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

		verticalStackView.addArrangedSubview(countryFieldView)
		verticalStackView.addArrangedSubview(addressLine1FieldView)
		verticalStackView.addArrangedSubview(addressLine2FieldView)
		verticalStackView.addArrangedSubview(cityFieldView)

		stateAndPostalCodeStackView.addArrangedSubview(statePickerFieldView)
		stateAndPostalCodeStackView.addArrangedSubview(postalCodeFieldView)

		verticalStackView.addArrangedSubview(stateAndPostalCodeStackView)

		rootStackView.addArrangedSubview(errorLabel)
		errorLabel.isHiddenInCheckoutStackView = true

		// Gather all form items.
		fieldViews = [
			countryFieldView,
			addressLine1FieldView,
			addressLine2FieldView,
			cityFieldView,
			statePickerFieldView,
			postalCodeFieldView
		]

		// Setup insets and UI Theme.
		fieldViews.forEach { fieldView in
			fieldView.updateStyle(with: uiTheme)
			fieldView.placeholderView.stackView.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
			fieldView.placeholderView.stackView.isLayoutMarginsRelativeArrangement = true
		}
	}
}
