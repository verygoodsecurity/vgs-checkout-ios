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

	/// Configuration type.
	internal let paymentInstrument: VGSPaymentInstrument

	/// VGSCollect instance.
	internal let vgsCollect: VGSCollect

	/// Validation manager.
	internal let formValidationHelper: VGSFormValidationHelper

	/// Autofocus manager.
	internal let autoFocusManager: VGSFieldAutofocusManager

	// MARK: - Initialization

  internal init(paymentInstrument: VGSPaymentInstrument, vgsCollect: VGSCollect, validationBehavior: VGSFormValidationBehaviour = .onFocus, uiTheme: VGSCheckoutThemeProtocol, formValidationHelper: VGSFormValidationHelper, autoFocusManager: VGSFieldAutofocusManager) {
		self.paymentInstrument = paymentInstrument
		self.vgsCollect = vgsCollect
		self.validationBehavior = validationBehavior
    self.billingAddressFormView = VGSBillingAddressDetailsSectionView(paymentInstrument: paymentInstrument, uiTheme: uiTheme)
		self.formValidationHelper = formValidationHelper
		self.autoFocusManager = autoFocusManager

		buildForm()
	}

	// MARK: - Interface

	internal func buildForm() {
		billingAddressFormView.translatesAutoresizingMaskIntoConstraints = false

		switch paymentInstrument {
		case .vault(let configuration):
			setupCardForm(with: configuration)
		case .multiplexing(let multiplexingConfig):
			setupCardForm(with: multiplexingConfig)
		}

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
		  textField.delegate = self
		}

		for item in fieldViews {
			item.placeholderView.delegate = self
		}

		// Set picker fields delegate.
		statePickerField?.pickerSelectionDelegate = self
		countryPickerField?.pickerSelectionDelegate = self
	}

	// MARK: - Helpers

	private func setupCardForm(with vaultConfiguration: VGSCheckoutConfiguration) {
		VGSAddressDataFormConfigurationManager.setupAddressForm(with: vaultConfiguration, vgsCollect: vgsCollect, addressFormView: billingAddressFormView)
	}

	private func setupCardForm(with multiplexingConfiguration: VGSCheckoutMultiplexingConfiguration) {
		VGSAddressDataFormConfigurationManager.setupAddressForm(with: multiplexingConfiguration, vgsCollect: vgsCollect, addressFormView: billingAddressFormView)
	}

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
	fileprivate var countryPickerField: VGSPickerTextField? {
		guard let countryTextField = fieldViews.first(where: {$0.fieldType == .country})?.textField as? VGSPickerTextField else {return nil}

		return countryTextField
	}

	/// State field view.
	fileprivate var stateFieldView: VGSTextFieldViewProtocol? {
		return fieldViews.first(where: {$0.fieldType == .state})
	}

	/// State field view.
	fileprivate var zipFieldView: VGSTextFieldViewProtocol? {
		return fieldViews.first(where: {$0.fieldType == .postalCode})
	}

	/// State picker field.
	fileprivate var statePickerField: VGSPickerTextField? {
		guard let stateTextField = fieldViews.first(where: {$0.fieldType == .state})?.textField as? VGSPickerTextField else {return nil}

		return stateTextField
	}

	fileprivate var currentRegions: [VGSAddressRegionModel] {
		guard let config = countryPickerField?.configuration as? VGSPickerTextFieldConfiguration, let dataSource = config.dataProvider?.dataSource as? VGSRegionsDataSourceProvider else {
			return []
		}

		return dataSource.regions
	}
}

// MARK: - VGSTextFieldDelegate

extension VGSAddressDataSectionViewModel: VGSTextFieldDelegate {

	func vgsTextFieldDidChange(_ textField: VGSTextField) {
		formValidationHelper.updateFormSectionViewOnEditingTextField(textField: textField)
		updateFormState()
	}

	func vgsTextFieldDidEndEditing(_ textField: VGSTextField) {
		formValidationHelper.updateFormSectionViewOnEndEditingTextField(textField: textField)
		updateFormState()
	}

	func vgsTextFieldDidEndEditingOnReturn(_ textField: VGSTextField) {
		formValidationHelper.updateFormSectionViewOnEndEditingTextField(textField: textField)
//		autoFocusManager.focusOnEndEditingOnReturn(for: textField)
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

	func updateZipField(with countryISO: VGSCountriesISO) {
		guard let zipTextFieldView = zipFieldView else {return}
		VGSPostalCodeFieldView.updateUI(for: zipTextFieldView, countryISOCode: countryISO)
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
				VGSAddressDataFormConfigurationManager.updateAddressForm(with: newCountry, paymentInstrument: paymentInstrument, addressFormView: billingAddressFormView, vgsCollect: vgsCollect)
				updateStateField(with: newCountry)
				updateZipField(with: newCountry)
			}
		} else if pickerTextField === statePickerField {

		}
	}
}
