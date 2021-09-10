//
//  VGSAddressDataSectionViewModel.swift
//  VGSCheckout

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
	internal let validationBehavior: VGSFormValidationBehaviour

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

	// MARK: - Initialization
  
  internal required init(vgsCollect: VGSCollect, validationBehavior: VGSFormValidationBehaviour = .onSubmit, uiTheme: VGSCheckoutThemeProtocol, formValidationHelper: VGSFormValidationHelper, autoFocusManager: VGSFieldAutofocusManager) {
    self.vgsCollect = vgsCollect
    self.validationBehavior = validationBehavior
    self.billingAddressFormView = VGSBillingAddressDetailsSectionView(uiTheme: uiTheme)
    self.formValidationHelper = formValidationHelper
    self.autoFocusManager = autoFocusManager
  }

  internal convenience init(vgsCollect: VGSCollect, configuration: VGSCheckoutConfiguration, validationBehavior: VGSFormValidationBehaviour = .onSubmit, uiTheme: VGSCheckoutThemeProtocol, formValidationHelper: VGSFormValidationHelper, autoFocusManager: VGSFieldAutofocusManager) {
    self.init(vgsCollect: vgsCollect, validationBehavior: validationBehavior, uiTheme: uiTheme, formValidationHelper:  formValidationHelper, autoFocusManager: autoFocusManager)

    setupBillingAddressForm(with: configuration)
    buildForm()
	}
  
  internal convenience init(vgsCollect: VGSCollect, configuration: VGSCheckoutMultiplexingConfiguration, validationBehavior: VGSFormValidationBehaviour = .onSubmit, uiTheme: VGSCheckoutThemeProtocol, formValidationHelper: VGSFormValidationHelper, autoFocusManager: VGSFieldAutofocusManager) {
    self.init(vgsCollect: vgsCollect, validationBehavior: validationBehavior, uiTheme: uiTheme, formValidationHelper:  formValidationHelper, autoFocusManager: autoFocusManager)

		setupBillingAddressForm(with: configuration)
    buildForm()
  }

	// MARK: - Interface

	/// Builds form.
  internal func buildForm() {
		billingAddressFormView.translatesAutoresizingMaskIntoConstraints = false

		let inputBlackTextColor: UIColor = {
			if #available(iOS 13.0, *) {
				return UIColor {(traits) -> UIColor in
					return traits.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
				}
			} else {
				return .black
			}
		}()

        vgsTextFields.forEach { textField in
			textField.textColor = inputBlackTextColor
			textField.font = UIFont.preferredFont(forTextStyle: .body)
			textField.adjustsFontForContentSizeCategory = true
		}

		for item in fieldViews {
			item.placeholderView.delegate = self
			item.delegate = self
		}

		if let lastFieldView = fieldViews.last {
			lastFieldView.validationErrorView.isLastRow = true
		}

		// Set picker fields delegate.
		statePickerField?.pickerSelectionDelegate = self
		countryPickerField?.pickerSelectionDelegate = self
	}

	// MARK: - Helpers

	/// Setup billing address form with vault configuration.
	/// - Parameter multiplexingConfiguration: `VGSCheckoutConfiguration` object, vault configuration.
	private func setupBillingAddressForm(with vaultConfiguration: VGSCheckoutConfiguration) {
		VGSAddressDataFormConfigurationManager.setupAddressForm(with: vaultConfiguration, vgsCollect: vgsCollect, addressFormView: billingAddressFormView)
	}

	/// Setup billing address form with multiplexing configuration.
	/// - Parameter multiplexingConfiguration: `VGSCheckoutMultiplexingConfiguration` object, multiplexing configuration.
	private func setupBillingAddressForm(with multiplexingConfiguration: VGSCheckoutMultiplexingConfiguration) {
		VGSAddressDataFormConfigurationManager.setupAddressForm(with: multiplexingConfiguration, vgsCollect: vgsCollect, addressFormView: billingAddressFormView)
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
        updateFormState()
    }

	func pickerAddressDidUpdate(in field: VGSTextField, fieldType: VGSAddCardFormFieldType) {
		guard let pickerField = field as? VGSPickerTextField else {
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
		guard let postalCodeTextFieldView = postalCodeFieldView else {return}
        /// update validation rules for country
        postalCodeTextFieldView.textField.validationRules = VGSValidationRuleSet(rules: VGSPostalCodeValidationRulesFactory.validationRules(for: countryISO))
        /// update UI state
		VGSPostalCodeFieldView.updateUI(for: postalCodeTextFieldView, countryISOCode: countryISO)
	}

	func userDidSelectValue(_ textValue: String?, in pickerTextField: VGSPickerTextField) {
		guard let text = textValue else {return}
		if pickerTextField === countryPickerField {
			var currentCountryCode: String = ""

			print("currentRegions: \(currentRegions)")

			for country in VGSAddressCountriesDataProvider.provideSupportedCountries() {
				if country.name == text {
					currentCountryCode = country.code
					print("currentCode found \(currentCountryCode)")
				}
			}

			if let newCountry = VGSCountriesISO(rawValue: currentCountryCode) {
				print("update states with new country: \(newCountry)")

				// Uncomment this code to enable other countries without AWS support

//				VGSAddressDataFormConfigurationManager.updateAddressForm(with: newCountry, paymentInstrument: paymentInstrument, addressFormView: billingAddressFormView, vgsCollect: vgsCollect, formValidationHelper: formValidationHelper)
//
				updateStateField(with: newCountry)
				updatePostalCodeField(with: newCountry)

				// Postal code field configuration has been already updated on previous textChange delegate call. Simulate delegate editing event to refresh state with new files configuration.
				pickerTextField.delegate?.vgsTextFieldDidChange?(pickerTextField)
				
				// Revalidate the entire form - on switching countries previous postal code can be invalid now.
				updateFormState()
			}
		} else if pickerTextField === statePickerField {

		}
	}
}
