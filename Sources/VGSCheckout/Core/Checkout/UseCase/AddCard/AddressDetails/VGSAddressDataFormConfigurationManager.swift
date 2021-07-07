//
//  VGSAddressDataFormConfigurationManager.swift
//  VGSCheckout

import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Encapsulates address form setup with collect.
internal class VGSAddressDataFormConfigurationManager {

	internal static func setupAddressForm(with vaultConfiguration: VGSCheckoutConfiguration, vgsCollect: VGSCollect, addressFormView: VGSBillingAddressDetailsView) {

		let countryTextField = addressFormView.countryFormItemView.countryTextField
		let addressLine1TextField = addressFormView.addressLine1FormItemView.addressLineTextField
		let addressLine2TextField = addressFormView.addressLine2FormItemView.addressLineTextField
		let cityTextField = addressFormView.cityItemFormView.cityTextField
		let stateTextField = addressFormView.stateFormItemView.stateTextField
		let zipTextField = addressFormView.zipFormItemView.zipCodeTextField

		let countryConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "country")
		countryConfiguration.type = .none
		countryConfiguration.isRequiredValidOnly = true

		countryTextField.configuration = countryConfiguration

		let addressLine1Configuration = VGSConfiguration(collector: vgsCollect, fieldName: "adddressLine1")
		addressLine1Configuration.type = .none
		addressLine1Configuration.isRequiredValidOnly = true

		addressLine1TextField.placeholder = "Address line 1"

		addressLine1TextField.configuration = addressLine1Configuration

		let addressLine2Configuration = VGSConfiguration(collector: vgsCollect, fieldName: "adddressLine2")
		addressLine2Configuration.type = .none
		addressLine2Configuration.isRequiredValidOnly = true

		addressLine2TextField.configuration = addressLine2Configuration

		addressLine2TextField.placeholder = "Address line 2 (Optional)"

		let cityConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "city")
		cityConfiguration.type = .none
		cityConfiguration.isRequiredValidOnly = true

		cityTextField.configuration = cityConfiguration

		cityTextField.placeholder = "City"

		let stateConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "state")
		stateConfiguration.type = .none
		stateConfiguration.isRequiredValidOnly = true

		stateTextField.placeholder = "State"

		stateTextField.configuration = stateConfiguration

		let zipConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "zip")
		zipConfiguration.type = .none
		zipConfiguration.isRequiredValidOnly = true

		zipTextField.placeholder = "ZIP CODE"

		zipTextField.configuration = zipConfiguration
	}

	internal static func setupAddressForm(with multiplexingConfiguration: VGSCheckoutMultiplexingConfiguration, vgsCollect: VGSCollect, addressFormView: VGSBillingAddressDetailsView) {

		let countryTextField = addressFormView.countryFormItemView.countryTextField
		let addressLine1TextField = addressFormView.addressLine1FormItemView.addressLineTextField
		let addressLine2TextField = addressFormView.addressLine2FormItemView.addressLineTextField
		let cityTextField = addressFormView.cityItemFormView.cityTextField
		let stateTextField = addressFormView.stateFormItemView.stateTextField
		let zipTextField = addressFormView.zipFormItemView.zipCodeTextField

		let countryConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "country")
		countryConfiguration.type = .none
		countryConfiguration.isRequiredValidOnly = true

		countryTextField.configuration = countryConfiguration

		let addressLine1Configuration = VGSConfiguration(collector: vgsCollect, fieldName: "adddressLine1")
		addressLine1Configuration.type = .none
		addressLine1Configuration.isRequiredValidOnly = true

		addressLine1TextField.placeholder = "Address line 1"

		addressLine1TextField.configuration = addressLine1Configuration

		let addressLine2Configuration = VGSConfiguration(collector: vgsCollect, fieldName: "adddressLine2")
		addressLine2Configuration.type = .none
		addressLine2Configuration.isRequiredValidOnly = true

		addressLine2TextField.configuration = addressLine2Configuration

		addressLine2TextField.placeholder = "Address line 2 (Optional)"

		let cityConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "city")
		cityConfiguration.type = .none
		cityConfiguration.isRequiredValidOnly = true

		cityTextField.configuration = cityConfiguration

		cityTextField.placeholder = "City"

		let stateConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "state")
		stateConfiguration.type = .none
		stateConfiguration.isRequiredValidOnly = true

		stateTextField.placeholder = "State"

		stateTextField.configuration = stateConfiguration

		let zipConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "zip")
		zipConfiguration.type = .none
		zipConfiguration.isRequiredValidOnly = true

		zipTextField.placeholder = "ZIP CODE"

		zipTextField.configuration = zipConfiguration
	}
}
