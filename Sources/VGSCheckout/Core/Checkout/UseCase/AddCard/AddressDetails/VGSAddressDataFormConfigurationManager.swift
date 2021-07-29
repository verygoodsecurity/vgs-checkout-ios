//
//  VGSAddressDataFormConfigurationManager.swift
//  VGSCheckout

import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Encapsulates address form setup with collect.
internal class VGSAddressDataFormConfigurationManager {

	internal static func setupAddressForm(with vaultConfiguration: VGSCheckoutConfiguration, vgsCollect: VGSCollect, addressFormView: VGSBillingAddressDetailsSectionView) {

		let countryTextField = addressFormView.countryFieldView.countryTextField
		let addressLine1TextField = addressFormView.addressLine1FieldView.addressLineTextField
		let addressLine2TextField = addressFormView.addressLine2FieldView.addressLineTextField
		let cityTextField = addressFormView.cityFieldView.cityTextField
		let statePickerTextField = addressFormView.statePickerFieldView.statePickerTextField
		let postalCodeTextField = addressFormView.postalCodeFieldView.postalCodeTextField

		let addressMode = vaultConfiguration.formConfiguration.billingAddressMode

		let countryOptions = vaultConfiguration.billingAddressCountryFieldOptions
		let addressLine1Options = vaultConfiguration.billingAddressLine1FieldOptions
		let addressLine2Options = vaultConfiguration.billingAddressLine2FieldOptions
		let cityOptions = vaultConfiguration.billingAddressCityFieldOptions
		let postalCodeOptions = vaultConfiguration.billingAddressPostalCodeFieldOptions

		switch addressMode {
		case .noAddress:
			addressFormView.isHidden = true
			return
		case .fullAddress:
			break
		}

		let countryConfiguration = VGSPickerTextFieldConfiguration(collector: vgsCollect, fieldName: countryOptions.fieldName)
		countryConfiguration.dataProvider = VGSPickerDataSourceProvider(dataSource: VGSCountryPickerDataSource())
		countryConfiguration.type = .none
		countryConfiguration.isRequiredValidOnly = true

		countryTextField.configuration = countryConfiguration

		// Force select first row in picker.
		countryTextField.selectFirstRow()

		let addressLine1Configuration = VGSConfiguration(collector: vgsCollect, fieldName: addressLine1Options.fieldName)
		addressLine1Configuration.type = .none
		addressLine1Configuration.isRequiredValidOnly = true
		addressLine1Configuration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
		])
		addressLine1Configuration.returnKeyType = .next

		addressLine1TextField.configuration = addressLine1Configuration

		let addressLine2Configuration = VGSConfiguration(collector: vgsCollect, fieldName: addressLine2Options.fieldName)
		addressLine2Configuration.type = .none
		addressLine2Configuration.isRequiredValidOnly = false
		addressLine2Configuration.returnKeyType = .next

		addressLine2TextField.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line2_hint")
		addressFormView.addressLine2FieldView.placeholderView.hintLabel.text = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line2_subtitle")


		addressLine2TextField.configuration = addressLine2Configuration

		let cityConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: cityOptions.fieldName)
		cityConfiguration.type = .none
		cityConfiguration.isRequiredValidOnly = true
		cityConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
		])
		addressLine1Configuration.returnKeyType = .next

		cityTextField.configuration = cityConfiguration

		// Disable state field for now

		addressFormView.statePickerFieldView.isHiddenInCheckoutStackView = true

//		let statePickerConfiguration = VGSPickerTextFieldConfiguration(collector: vgsCollect, fieldName: "state")
////		let regionsDataSource = VGSRegionsDataSourceProvider(with: "US")
////		let regionsDataSourceProvider = VGSPickerDataSourceProvider(dataSource: regionsDataSource)
////		statePickerConfiguration.dataProvider = regionsDataSourceProvider
//		statePickerConfiguration.type = .none
//		statePickerConfiguration.isRequiredValidOnly = true
//
//		statePickerTextField.configuration = statePickerConfiguration
//
//		statePickerTextField.mode = .textField

		// Force select first state.
//		statePickerTextField.selectFirstRow()

		let postalCodeConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: postalCodeOptions.fieldName)
		postalCodeConfiguration.type = .none
		postalCodeConfiguration.isRequiredValidOnly = true
		postalCodeConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
		])
		postalCodeConfiguration.returnKeyType = .done

		postalCodeTextField.configuration = postalCodeConfiguration

		VGSPostalCodeFieldView.updateUI(for: addressFormView.postalCodeFieldView, countryISOCode: .us)
	}

	/*
	{
		name,
		number,
		exp_month,
		exp_year,
		cvc,
		billing_address: {
			name, //require
			company,
			address1, //require
			address2,
			city, //require
			region, //require (Principal subdivision in ISO 3166-2)
			country, //require (Country code in ISO 3166-1 alpha-2)
			state,
			country,
			postal_code, //require
			phone,
		},
	},
	*/

	/*

	name: John Doe
									 number: 41111111111111
									 exp_month: 10
									 exp_year: 2030
									 cvc: 123,
									 billing_address:
										 name: John Doe
										 company: John Doe Company
										 address1: 555 Unblock Us St
										 address2: M13 9PL
										 city: New York
										 region: NY
										 country: US
										 postal_code: 12301
										 phone: '+14842634673'

	*/

	internal static func setupAddressForm(with multiplexingConfiguration: VGSCheckoutMultiplexingConfiguration, vgsCollect: VGSCollect, addressFormView: VGSBillingAddressDetailsSectionView) {

		let countryTextField = addressFormView.countryFieldView.countryTextField
		let addressLine1TextField = addressFormView.addressLine1FieldView.addressLineTextField
		let addressLine2TextField = addressFormView.addressLine2FieldView.addressLineTextField
		let cityTextField = addressFormView.cityFieldView.cityTextField
		let stateTextField = addressFormView.statePickerFieldView.statePickerTextField
		let postalCodeTextField = addressFormView.postalCodeFieldView.postalCodeTextField

		let countryConfiguration = VGSPickerTextFieldConfiguration(collector: vgsCollect, fieldName: "data.attributes.details.billing_address.country")
		countryConfiguration.dataProvider = VGSPickerDataSourceProvider(dataSource: VGSCountryPickerDataSource())
		countryConfiguration.type = .none
		countryConfiguration.isRequiredValidOnly = true

		countryTextField.configuration = countryConfiguration

		// Force select first row in picker.
		countryTextField.selectFirstRow()

		let addressLine1Configuration = VGSConfiguration(collector: vgsCollect, fieldName: "data.attributes.details.billing_address.address1")
		addressLine1Configuration.type = .none
		addressLine1Configuration.isRequiredValidOnly = true
		addressLine1Configuration.returnKeyType = .next

		addressLine1TextField.configuration = addressLine1Configuration

		let addressLine2Configuration = VGSConfiguration(collector: vgsCollect, fieldName: "adddressLine2")
		addressLine2Configuration.type = .none
		addressLine2Configuration.isRequiredValidOnly = false
		addressLine2Configuration.returnKeyType = .next

		addressLine2TextField.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line2_hint")
		addressFormView.addressLine2FieldView.placeholderView.hintLabel.text = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line2_subtitle")

		addressLine2TextField.configuration = addressLine2Configuration

		let cityConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "data.attributes.details.billing_address.city")
		cityConfiguration.type = .none
		cityConfiguration.isRequiredValidOnly = true

		cityTextField.configuration = cityConfiguration

		cityConfiguration.returnKeyType = .next

		// Disable state field for now

		addressFormView.statePickerFieldView.isHiddenInCheckoutStackView = true
//
//		let stateConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "data.attributes.details.billing_address.region")
//		stateConfiguration.type = .none
//		stateConfiguration.isRequiredValidOnly = true
//		stateConfiguration.validationRules = VGSValidationRuleSet(rules: [
//			VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
//		])
//		stateConfiguration.returnKeyType = .next
//
//		stateTextField.configuration = stateConfiguration
//		stateTextField.mode = .textField

		let postalCodeConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "data.attributes.details.billing_address.postal_code")
		postalCodeConfiguration.type = .none
		postalCodeConfiguration.isRequiredValidOnly = true

		postalCodeTextField.configuration = postalCodeConfiguration

		VGSPostalCodeFieldView.updateUI(for: addressFormView.postalCodeFieldView, countryISOCode: .us)
	}

	internal static func updateAddressForm(with countryISO: VGSCountriesISO, paymentInstrument: VGSPaymentInstrument, addressFormView: VGSBillingAddressDetailsSectionView, vgsCollect: VGSCollect, formValidationHelper: VGSFormValidationHelper) {
		switch paymentInstrument {
		case .vault:
			break
		case .multiplexing:
			// If country does not support Address verification hide all other fields and unregister them from collect.
			// Otherwise register and show fields again. Only for multiplexing flow.
			let isAddressVerificationAvailable = VGSBillingAddressUtils.isAddressVerificationAvailable(for: countryISO)

			if isAddressVerificationAvailable {
				addressFormView.stateAndPostalCodeStackView.isHiddenInCheckoutStackView = false
				addressFormView.fieldViews.forEach { fieldView in
					let fieldType = fieldView.fieldType
					switch fieldType {
					case .addressLine1, .addressLine2, .city, .state, .postalCode:
						if let view = fieldView as? UIView {
							view.isHiddenInCheckoutStackView = false
						}
						vgsCollect.registerTextFields(textField: [fieldView.textField])
					default:
						break
					}
				}

				// Add address fields to validation manager again in the correct order.
				formValidationHelper.fieldViewsManager.appendFieldViews([addressFormView.addressLine1FieldView, addressFormView.addressLine2FieldView, addressFormView.cityFieldView, addressFormView.statePickerFieldView, addressFormView.postalCodeFieldView])
			} else {
				addressFormView.stateAndPostalCodeStackView.isHiddenInCheckoutStackView = true
				addressFormView.fieldViews.forEach { fieldView in
					let fieldType = fieldView.fieldType
					switch fieldType {
					case .addressLine1, .addressLine2, .city, .state, .postalCode:
						if let view = fieldView as? UIView {
							view.isHiddenInCheckoutStackView = true
						}
						formValidationHelper.fieldViewsManager.removeFieldView(fieldView)
						vgsCollect.unsubscribeTextField(fieldView.textField)
					default:
						break
					}
				}
			}
		}
	}
}
