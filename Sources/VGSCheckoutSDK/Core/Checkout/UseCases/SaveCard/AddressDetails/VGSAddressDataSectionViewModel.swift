//
//  VGSAddressDataSectionViewModel.swift
//  VGSCheckoutSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds logic for billing addres setup and handling events.
final internal class VGSAddressDataSectionViewModel: VGSBaseFormSectionProtocol, VGSPlaceholderFieldViewDelegate, VGSPickerTextFieldSelectionDelegate {
  
	/// Delegate.
	weak var delegate: VGSFormSectionPresenterDelegate?

	/// Form section state.
	internal var state: VGSFormSectionState = .invalid {
		didSet {
			delegate?.stateDidChange(state)
		}
	}

	/// Validation behavior.
	internal let validationBehavior: VGSCheckoutFormValidationBehaviour

	/// Card form view.
	internal let billingAddressFormView: VGSBillingAddressDetailsSectionView

	/// Text field form items in add card section.
	var fieldViews: [VGSTextFieldViewProtocol] {
		return billingAddressFormView.fieldViews
	}

	/// Text fields.
	var vgsTextFields: [VGSTextField] {
		return fieldViews.map({return $0.textField})
	}

	/// VGSCollect instance.
	internal let vgsCollect: VGSCollect

	/// Validation manager.
	internal let formValidationHelper: VGSFormValidationHelper

	/// Autofocus manager.
	internal let autoFocusManager: VGSFieldAutofocusManager

	/// Payment instrument.
	internal let checkoutConfigurationType: VGSCheckoutConfigurationType

	// MARK: - Initialization
  
	internal required init(vgsCollect: VGSCollect, validationBehavior: VGSCheckoutFormValidationBehaviour, uiTheme: VGSCheckoutThemeProtocol, formValidationHelper: VGSFormValidationHelper, autoFocusManager: VGSFieldAutofocusManager, checkoutConfigurationType: VGSCheckoutConfigurationType) {
    self.vgsCollect = vgsCollect
		self.checkoutConfigurationType = checkoutConfigurationType
    self.validationBehavior = validationBehavior
    self.billingAddressFormView = VGSBillingAddressDetailsSectionView(uiTheme: uiTheme)
    self.formValidationHelper = formValidationHelper
    self.autoFocusManager = autoFocusManager
  }

  internal convenience init(vgsCollect: VGSCollect, configuration: VGSCheckoutCustomConfiguration, validationBehavior: VGSCheckoutFormValidationBehaviour = .onSubmit, uiTheme: VGSCheckoutThemeProtocol, formValidationHelper: VGSFormValidationHelper, autoFocusManager: VGSFieldAutofocusManager) {
		self.init(vgsCollect: vgsCollect, validationBehavior: validationBehavior, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager, checkoutConfigurationType: .custom(configuration))

    setupBillingAddressForm(with: configuration)
    buildForm()
	}
  
  internal convenience init(vgsCollect: VGSCollect, configuration: VGSCheckoutAddCardConfiguration, validationBehavior: VGSCheckoutFormValidationBehaviour, uiTheme: VGSCheckoutThemeProtocol, formValidationHelper: VGSFormValidationHelper, autoFocusManager: VGSFieldAutofocusManager) {
    self.init(vgsCollect: vgsCollect, validationBehavior: validationBehavior, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager, checkoutConfigurationType: .payoptAddCard(configuration))

		setupBillingAddressForm(with: configuration)
    buildForm()
  }

	internal convenience init(vgsCollect: VGSCollect, configuration: VGSCheckoutPaymentConfiguration, validationBehavior: VGSCheckoutFormValidationBehaviour, uiTheme: VGSCheckoutThemeProtocol, formValidationHelper: VGSFormValidationHelper, autoFocusManager: VGSFieldAutofocusManager) {
		self.init(vgsCollect: vgsCollect, validationBehavior: validationBehavior, uiTheme: uiTheme, formValidationHelper: formValidationHelper, autoFocusManager: autoFocusManager, checkoutConfigurationType: .payoptTransfers(configuration))

		setupBillingAddressForm(with: configuration)
		buildForm()
	}

	// MARK: - Interface

	/// Builds form.
  internal func buildForm() {
		billingAddressFormView.translatesAutoresizingMaskIntoConstraints = false

		for item in fieldViews {
			item.placeholderView.delegate = self
			item.delegate = self
		}

		billingAddressFormView.cityFieldView.validationErrorView.isLastRow = true

		if let lastFieldView = fieldViews.last {
			lastFieldView.validationErrorView.isLastRow = true
		}

		// Set picker fields delegate.
		statePickerField?.pickerSelectionDelegate = self
		countryPickerField?.pickerSelectionDelegate = self

		// Country field cannot be empty so make it filled from start.
		billingAddressFormView.countryFieldView.uiConfigurationHandler?.filled()

		let validCountries = checkoutConfigurationType.validCountries
		let firstCountryISO = VGSAddressCountriesDataProvider.provideFirstCountryISO(for: validCountries)

		lastSelectedCountryCode = firstCountryISO.rawValue
	}

	/// Updates initial UI. Since validation manager is constructed later than init is called we need this method to refresh state for firstCountryCode.
	internal func updateInitialPostalCodeUI() {
		let validCountries = checkoutConfigurationType.validCountries
		let firstCountryISO = VGSAddressCountriesDataProvider.provideFirstCountryISO(for: validCountries)

		if checkoutConfigurationType.isPostalCodeVisible {
			// Update collect and validation helpers country without postal code.
			VGSAddressDataFormConfigurationManager.updatePostalCodeViewIfNeeded(with: firstCountryISO,  addressFormView: billingAddressFormView, vgsCollect: vgsCollect, formValidationHelper: formValidationHelper)

			updatePostalCodeField(with: firstCountryISO)
		}

		updateFormState()
	}

	// MARK: - Helpers

	/// Setup billing address form with vault configuration.
	/// - Parameter vaultConfiguration: `VGSCheckoutCustomConfiguration` object, vault configuration.
	private func setupBillingAddressForm(with vaultConfiguration: VGSCheckoutCustomConfiguration) {
		VGSAddressDataFormConfigurationManager.setupAddressForm(with: vaultConfiguration, vgsCollect: vgsCollect, addressFormView: billingAddressFormView)
	}

	/// Setup billing address form with payopt configuration.
	/// - Parameter configuration: `VGSCheckoutPayoptBasicConfiguration` object, payopt configuration.
	private func setupBillingAddressForm(with configuration: VGSCheckoutPayoptBasicConfiguration) {
		VGSAddressDataFormConfigurationManager.setupAddressForm(with: configuration, vgsCollect: vgsCollect, addressFormView: billingAddressFormView)
	}

	/// Handles tap in form views to make textField first responder when tap is outside the textField.
	func didTap(in formView: VGSPlaceholderFieldView) {
		for item in fieldViews {
			if item.placeholderView === formView {
				item.textField.becomeFirstResponder()
			}
		}
	}

	/// Update Form Validation State.
	func updateFormState() {
		if formValidationHelper.isFormValid() {
			state = .valid
		} else {
			state = .invalid
		}
	}

	/// Country picker field.
  internal var countryPickerField: VGSPickerTextField? {
		guard let countryTextField = fieldViews.first(where: {$0.fieldType == .country})?.textField as? VGSPickerTextField else {return nil}

		return countryTextField
	}

	/// State field view.
  internal var stateFieldView: VGSTextFieldViewProtocol? {
		return fieldViews.first(where: {$0.fieldType == .state})
	}

	/// State field view.
  internal var postalCodeFieldView: VGSTextFieldViewProtocol? {
		return fieldViews.first(where: {$0.fieldType == .postalCode})
	}

	/// State picker field.
  internal var statePickerField: VGSPickerTextField? {
		guard let stateTextField = fieldViews.first(where: {$0.fieldType == .state})?.textField as? VGSPickerTextField else {return nil}

		return stateTextField
	}

	/// Current available regions.
  internal var currentRegions: [VGSAddressRegionModel] {
		guard let config = countryPickerField?.configuration as? VGSPickerTextFieldConfiguration, let dataSource = config.dataProvider?.dataSource as? VGSRegionsDataSourceProvider else {
			return []
		}

		return dataSource.regions
	}

	/// Current selected country.
	internal var lastSelectedCountryCode: String?
}

// MARK: - VGSTextFieldDelegate

extension VGSAddressDataSectionViewModel: VGSTextFieldViewDelegate {
    func vgsFieldViewDidBeginEditing(_ fieldView: VGSTextFieldViewProtocol) {
        formValidationHelper.updateFieldViewOnBeginEditingTextField(fieldView)
        updateFormState()
    }
    
    func vgsFieldViewDidEndEditing(_ fieldView: VGSTextFieldViewProtocol) {
        formValidationHelper.updateFieldViewOnEndEditing(fieldView)
        updateFormState()
    }
    
    func vgsFieldViewDidEndEditingOnReturn(_ fieldView: VGSTextFieldViewProtocol) {
        formValidationHelper.updateFieldViewOnEndEditing(fieldView)
        updateFormState()
    }
    
    func vgsFieldViewdDidChange(_ fieldView: VGSTextFieldViewProtocol) {
        formValidationHelper.updateFieldViewOnTextChangeInTextField(fieldView)
        updateFormState()
    }

	func pickerAddressDidUpdate(in field: VGSTextField, fieldType: VGSAddCardFormFieldType) {
		guard field is VGSPickerTextField else {
			return
		}

		switch fieldType {
		case .country:
			break
		case .state:
			break
		default:
			break
		}
	}

	func updateStateField(with countryISO: VGSCountriesISO) {
		guard let stateField = statePickerField, let stateTextFieldView = self.stateFieldView else {return}

		let countryRegion = VGSAddressRegionType.regionType(for: countryISO)
		stateTextFieldView.placeholderView.hintLabel.text = countryRegion.lozalizedHint
		stateField.placeholder = countryRegion.lozalizedPlaceholder

		/*
		switch countryISO {
		case .us, .ca:
			if let config = stateField.configuration as? VGSPickerTextFieldConfiguration {
				let regionsDataSource = VGSRegionsDataSourceProvider(with: countryISO.rawValue)
				let regionsDataSourceProvider = VGSPickerDataSourceProvider(dataSource: regionsDataSource)
				config.dataProvider = regionsDataSourceProvider
				stateField.configuration = config
			}
		default:
			billingAddressFormView.statePickerFieldView.statePickerTextField.mode = .textField
		}
	  */
	}

	func updatePostalCodeField(with countryISO: VGSCountriesISO) {
		guard let postalCodeTextFieldView = postalCodeFieldView, countryISO.hasPostalCode else {return}
        /// update validation rules for country
        postalCodeTextFieldView.textField.validationRules = VGSValidationRuleSet(rules: VGSPostalCodeValidationRulesFactory.validationRules(for: countryISO))
        /// update UI state
		VGSPostalCodeFieldView.updateUI(for: postalCodeTextFieldView, countryISOCode: countryISO)
	}

	func userDidSelectValue(_ textValue: String?, in pickerTextField: VGSPickerTextField) {
		guard let text = textValue else {return}
		if pickerTextField === countryPickerField {
			var currentCountryCode: String = ""

			for country in VGSAddressCountriesDataProvider.provideAllCountries() {
				if country.name == text {
					currentCountryCode = country.code
				}
			}

			switch validationBehavior {
				case .onSubmit:
					// Clear postal code error on country change.
					if let previousCountryCode = lastSelectedCountryCode {
						if previousCountryCode != currentCountryCode {
							postalCodeFieldView?.updateUI(for: .filled)
							postalCodeFieldView?.validationErrorView.viewUIState = .valid
						}
					}
				case .onFocus:
					break
			}

			lastSelectedCountryCode = currentCountryCode

			if let newCountry = VGSCountriesISO(rawValue: currentCountryCode) {

				// Update collect and validation helpers country without postal code.

				if checkoutConfigurationType.isPostalCodeVisible {
				VGSAddressDataFormConfigurationManager.updatePostalCodeViewIfNeeded(with: newCountry,  addressFormView: billingAddressFormView, vgsCollect: vgsCollect, formValidationHelper: formValidationHelper)


				// Uncomment this code to enable other countries without AWS support
//				VGSAddressDataFormConfigurationManager.updateAddressForm(with: newCountry, checkoutConfigurationType: checkoutConfigurationType, addressFormView: billingAddressFormView, vgsCollect: vgsCollect, formValidationHelper: formValidationHelper)

				//updateStateField(with: newCountry)
				updatePostalCodeField(with: newCountry)
				}

				// Postal code field configuration has been already updated on previous textChange delegate call. Simulate delegate editing event to refresh state with new configuration.
				pickerTextField.delegate?.vgsTextFieldDidChange?(pickerTextField)

				if checkoutConfigurationType.isPostalCodeVisible {
					if validationBehavior == .onFocus {
						formValidationHelper.revalidatePostalCodeFieldIfNeeded()
					}
				}
				
				// Revalidate the entire form - on switching countries previous postal code can be invalid now.
				updateFormState()
			}
		} else if pickerTextField === statePickerField {

		}
	}
}
