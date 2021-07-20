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


		addressLine1TextField.placeholder = "Address line 1"

		addressLine1TextField.configuration = addressLine1Configuration

		let cityConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "city")
		cityConfiguration.type = .none
		cityConfiguration.isRequiredValidOnly = true
		cityConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
		])
		addressLine1Configuration.returnKeyType = .next

		cityTextField.configuration = cityConfiguration

		cityTextField.placeholder = "City"


		let statePickerConfiguration = VGSPickerTextFieldConfiguration(collector: vgsCollect, fieldName: "state")
//		let regionsDataSource = VGSRegionsDataSourceProvider(with: "US")
//		let regionsDataSourceProvider = VGSPickerDataSourceProvider(dataSource: regionsDataSource)
//		statePickerConfiguration.dataProvider = regionsDataSourceProvider
		statePickerConfiguration.type = .none
		statePickerConfiguration.isRequiredValidOnly = true

		statePickerTextField.configuration = statePickerConfiguration

		statePickerTextField.placeholder = "State"
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

		zipTextField.placeholder = "ZIP CODE"

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

	internal static func setupAddressForm(with multiplexingConfiguration: VGSCheckoutMultiplexingConfiguration, vgsCollect: VGSCollect, addressFormView: VGSBillingAddressDetailsSectionView) {

		let countryTextField = addressFormView.countryFieldView.countryTextField
		let addressLine1TextField = addressFormView.addressLine1FieldView.addressLineTextField
		let cityTextField = addressFormView.cityFieldView.cityTextField
		let stateTextField = addressFormView.statePickerFieldView.statePickerTextField
		let zipTextField = addressFormView.zipFieldView.zipCodeTextField

		let countryConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "billing_address.country")
		countryConfiguration.type = .none
		countryConfiguration.isRequiredValidOnly = true

		countryTextField.configuration = countryConfiguration

		let addressLine1Configuration = VGSConfiguration(collector: vgsCollect, fieldName: "billing_address.address1")
		addressLine1Configuration.type = .none
		addressLine1Configuration.isRequiredValidOnly = true
		addressLine1Configuration.returnKeyType = .next

		addressLine1TextField.placeholder = "Address line 1"

		addressLine1TextField.configuration = addressLine1Configuration

		let cityConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "billing_address.city")
		cityConfiguration.type = .none
		cityConfiguration.isRequiredValidOnly = true

		cityTextField.configuration = cityConfiguration

		cityTextField.placeholder = "City"
		cityConfiguration.returnKeyType = .next

		let stateConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "billing_address.region")
		stateConfiguration.type = .none
		stateConfiguration.isRequiredValidOnly = true
		stateConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
		])
		stateConfiguration.returnKeyType = .next

		stateTextField.placeholder = "State"

		stateTextField.configuration = stateConfiguration

		let zipConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "billing_address.postal_code")
		zipConfiguration.type = .none
		zipConfiguration.isRequiredValidOnly = true

		zipTextField.placeholder = "ZIP CODE"

		zipTextField.configuration = zipConfiguration
	}
}
