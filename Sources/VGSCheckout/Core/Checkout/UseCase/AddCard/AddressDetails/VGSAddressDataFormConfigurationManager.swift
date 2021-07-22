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
		let zipTextField = addressFormView.zipFieldView.zipCodeTextField

		let countryConfiguration = VGSPickerTextFieldConfiguration(collector: vgsCollect, fieldName: "country")
		countryConfiguration.dataProvider = VGSPickerDataSourceProvider(dataSource: VGSCountryPickerDataSource())
		countryConfiguration.type = .none
		countryConfiguration.isRequiredValidOnly = true

		countryTextField.configuration = countryConfiguration

		// Force select first row in picker.
		countryTextField.selectFirstRow()

		let addressLine1Configuration = VGSConfiguration(collector: vgsCollect, fieldName: "adddressLine1")
		addressLine1Configuration.type = .none
		addressLine1Configuration.isRequiredValidOnly = true
		addressLine1Configuration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
		])
		addressLine1Configuration.returnKeyType = .next

		addressLine1TextField.configuration = addressLine1Configuration

		let addressLine2Configuration = VGSConfiguration(collector: vgsCollect, fieldName: "adddressLine2")
		addressLine2Configuration.type = .none
		addressLine2Configuration.isRequiredValidOnly = false
		addressLine2Configuration.returnKeyType = .next

		addressLine2TextField.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line2_hint")
		addressFormView.addressLine2FieldView.placeholderView.hintLabel.text = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line2_subtitle")


		addressLine2TextField.configuration = addressLine2Configuration

		let cityConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "city")
		cityConfiguration.type = .none
		cityConfiguration.isRequiredValidOnly = true
		cityConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
		])
		addressLine1Configuration.returnKeyType = .next

		cityTextField.configuration = cityConfiguration

		let statePickerConfiguration = VGSPickerTextFieldConfiguration(collector: vgsCollect, fieldName: "state")
//		let regionsDataSource = VGSRegionsDataSourceProvider(with: "US")
//		let regionsDataSourceProvider = VGSPickerDataSourceProvider(dataSource: regionsDataSource)
//		statePickerConfiguration.dataProvider = regionsDataSourceProvider
		statePickerConfiguration.type = .none
		statePickerConfiguration.isRequiredValidOnly = true

		statePickerTextField.configuration = statePickerConfiguration

		statePickerTextField.mode = .textField

		// Force select first state.
//		statePickerTextField.selectFirstRow()

		let zipConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "zip")
		zipConfiguration.type = .none
		zipConfiguration.isRequiredValidOnly = true
		zipConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
		])
		zipConfiguration.returnKeyType = .done

		zipTextField.configuration = zipConfiguration
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
		let zipTextField = addressFormView.zipFieldView.zipCodeTextField

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

		let stateConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "data.attributes.details.billing_address.region")
		stateConfiguration.type = .none
		stateConfiguration.isRequiredValidOnly = true
		stateConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
		])
		stateConfiguration.returnKeyType = .next

		stateTextField.configuration = stateConfiguration
		stateTextField.mode = .textField

		let zipConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "data.attributes.details.billing_address.postal_code")
		zipConfiguration.type = .none
		zipConfiguration.isRequiredValidOnly = true

		zipTextField.configuration = zipConfiguration
	}
}
