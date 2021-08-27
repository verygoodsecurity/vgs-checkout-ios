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

    /// Container view
    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
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
        componentView.fieldType = .country
        componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_country_subtitle")
        componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_acountry_hint")
		return componentView
	}()

	/// Address line 1 form item view.
	internal lazy var addressLine1FieldView: VGSErrorFieldView = {
		let componentView = VGSErrorFieldView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false
        componentView.fieldType = .addressLine1
        componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line1_subtitle")
        componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line1_hint")
		return componentView
	}()

	/// Address line 2 form item view.
	internal lazy var addressLine2FieldView: VGSErrorFieldView = {
        let componentView = VGSErrorFieldView(frame: .zero)
        componentView.translatesAutoresizingMaskIntoConstraints = false
        componentView.fieldType = .addressLine2
        componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line2_subtitle")
        componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line2_hint")
        return componentView
	}()

	/// City form item view.
	internal lazy var cityFieldView: VGSErrorFieldView = {
        let componentView = VGSErrorFieldView(frame: .zero)
        componentView.translatesAutoresizingMaskIntoConstraints = false
        componentView.fieldType = .city
        componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_city_subtitle")
        componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_city_hint")
        return componentView
	}()

	/// region form item view.
	internal lazy var regionFieldView: VGSErrorFieldView = {
        let componentView = VGSErrorFieldView(frame: .zero)
        componentView.translatesAutoresizingMaskIntoConstraints = false
        componentView.fieldType = .state
        componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_region_type_state_subtitle")
        componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_region_type_state_hint")
        return componentView
    }()

	/// Postal Code/Zip form item view.
	internal lazy var postalCodeFieldView: VGSErrorFieldView = {
        let componentView = VGSErrorFieldView(frame: .zero)
        componentView.translatesAutoresizingMaskIntoConstraints = false
        componentView.fieldType = .postalCode
        componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_postal_code_subtitle")
        componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_postal_code_hint")
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
		stackView.hasBorderView = false
//		stackView.borderViewCornerRadius = 4

//		stackView.spacing = 1
//		stackView.separatorColor = uiTheme.textFieldBorderColor

		return stackView
	}()

	/// Horizontal stack view for state and cvc.
	internal lazy var stateAndPostalCodeStackView: VGSSeparatedStackView = {
		let stackView = VGSSeparatedStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.distribution = .fillEqually
		stackView.axis = .horizontal
        stackView.hasBorderView = false
		stackView.spacing = 1

		return stackView
	}()

	// MARK: - Initialization

	/// Initialization.
	/// - Parameter paymentInstrument: `VGSPaymentInstrument` object, payment instrument.
  init(uiTheme: VGSCheckoutThemeProtocol) {
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
//		switch block {
//		case .addressInfo:
//			if isValid {
//				verticalStackView.separatorColor = uiTheme.textFieldBorderColor
//			} else {
//				verticalStackView.separatorColor = uiTheme.textFieldBorderErrorColor
//			}
//		default:
//		 break
//		}
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
        /// TODO: Change to system colors
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        
        addSubview(containerView)
        containerView.checkout_defaultSectionViewConstraints()
        
        containerView.addSubview(rootStackView)
        rootStackView.checkout_constraintViewToSuperviewEdges()
		headerContainerView.addContentView(headerView)
		rootStackView.addArrangedSubview(headerContainerView)

		rootStackView.addArrangedSubview(verticalStackView)

		verticalStackView.addArrangedSubview(countryFieldView)
		verticalStackView.addArrangedSubview(addressLine1FieldView)
		verticalStackView.addArrangedSubview(addressLine2FieldView)
		verticalStackView.addArrangedSubview(cityFieldView)

		stateAndPostalCodeStackView.addArrangedSubview(postalCodeFieldView)

		verticalStackView.addArrangedSubview(stateAndPostalCodeStackView)

//		rootStackView.addArrangedSubview(errorLabel)
		errorLabel.isHiddenInCheckoutStackView = false

		// Gather all form items.
		fieldViews = [
			countryFieldView,
			addressLine1FieldView,
			addressLine2FieldView,
			cityFieldView,
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
