//
//  VGSBillingAddressDetailsView.swift
//  VGSCheckoutSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds UI for address details.
internal class VGSBillingAddressDetailsSectionView: UIView {

	/// UI Theme.
  internal var uiTheme: VGSCheckoutThemeProtocol

	/// Form items.
	internal var fieldViews: [VGSTextFieldViewProtocol] = []

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
        componentView.uiConfigurationHandler = VGSTextFieldViewUIConfigurationHandler(view: componentView, theme: uiTheme)
        componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_country_subtitle")
        componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_acountry_hint")
		return componentView
	}()

	/// Address line 1 form item view.
	internal lazy var addressLine1FieldView: VGSBaseFieldView = {
		let componentView = VGSBaseFieldView(frame: .zero)
		componentView.translatesAutoresizingMaskIntoConstraints = false
        componentView.fieldType = .addressLine1
        componentView.uiConfigurationHandler = VGSTextFieldViewUIConfigurationHandler(view: componentView, theme: uiTheme)
        componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line1_subtitle")
        componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line1_hint")
		return componentView
	}()

	/// Address line 2 form item view.
	internal lazy var addressLine2FieldView: VGSBaseFieldView = {
        let componentView = VGSBaseFieldView(frame: .zero)
        componentView.translatesAutoresizingMaskIntoConstraints = false
        componentView.fieldType = .addressLine2
        componentView.uiConfigurationHandler = VGSTextFieldViewUIConfigurationHandler(view: componentView, theme: uiTheme)
        componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line2_subtitle")
        componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line2_hint")
        return componentView
	}()

	/// City form item view.
	internal lazy var cityFieldView: VGSBaseFieldView = {
        let componentView = VGSBaseFieldView(frame: .zero)
        componentView.translatesAutoresizingMaskIntoConstraints = false
        componentView.fieldType = .city
        componentView.uiConfigurationHandler = VGSTextFieldViewUIConfigurationHandler(view: componentView, theme: uiTheme)
        componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_city_subtitle")
        componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_city_hint")
        return componentView
	}()

	/// region form item view.
	internal lazy var regionFieldView: VGSBaseFieldView = {
        let componentView = VGSBaseFieldView(frame: .zero)
        componentView.translatesAutoresizingMaskIntoConstraints = false
        componentView.fieldType = .state
        componentView.uiConfigurationHandler = VGSTextFieldViewUIConfigurationHandler(view: componentView, theme: uiTheme)
        componentView.subtitle = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_region_type_state_subtitle")
        componentView.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_region_type_state_hint")
        return componentView
    }()

	/// Postal Code/Zip form item view.
	internal lazy var postalCodeFieldView: VGSBaseFieldView = {
        let componentView = VGSBaseFieldView(frame: .zero)
        componentView.translatesAutoresizingMaskIntoConstraints = false
        componentView.fieldType = .postalCode
        componentView.uiConfigurationHandler = VGSTextFieldViewUIConfigurationHandler(view: componentView, theme: uiTheme)
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
	internal lazy var verticalStackView: UIStackView = {
		let stackView = UIStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .fill
		stackView.axis = .vertical

		return stackView
	}()

	/// Horizontal stack view for city and postal code.
	internal lazy var cityAndPostalCodeStackView: UIStackView = {
		let stackView = UIStackView(frame: .zero)
		stackView.translatesAutoresizingMaskIntoConstraints = false

		stackView.distribution = .fillEqually
		stackView.axis = .horizontal
		stackView.spacing = 20

		return stackView
	}()

	// MARK: - Initialization

	/// Initialization.
	/// - Parameter paymentInstrument: `VGSPaymentInstrument` object, payment instrument.
  init(uiTheme: VGSCheckoutThemeProtocol) {
        self.uiTheme = uiTheme
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

		backgroundColor = .vgsSectionBackgroundColor
		layer.cornerRadius = 8

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

		cityAndPostalCodeStackView.addArrangedSubview(cityFieldView)
		cityAndPostalCodeStackView.addArrangedSubview(postalCodeFieldView)

		verticalStackView.addArrangedSubview(cityAndPostalCodeStackView)
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
			fieldView.updateUI(for: .initial)
			fieldView.placeholderView.stackView.layoutMargins = VGSUIConstants.FormUI.fieldViewLayoutMargings
			fieldView.textField.padding = VGSUIConstants.FormUI.textFieldPaddings
		}
	}
}
