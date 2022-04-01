//
//  VGSAddressDataFormConfigurationManager.swift
//  VGSCheckoutSDK

import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Encapsulates address form setup with collect.
internal class VGSAddressDataFormConfigurationManager {

	internal static func setupAddressForm(with vaultConfiguration: VGSCheckoutCustomConfiguration, vgsCollect: VGSCollect, addressFormView: VGSBillingAddressDetailsSectionView) {

		let countryTextField = addressFormView.countryFieldView.countryTextField
		let addressLine1TextField = addressFormView.addressLine1FieldView.textField
		let addressLine2TextField = addressFormView.addressLine2FieldView.textField
		let cityTextField = addressFormView.cityFieldView.textField
		let postalCodeTextField = addressFormView.postalCodeFieldView.textField

		let countryOptions = vaultConfiguration.billingAddressCountryFieldOptions
		let addressLine1Options = vaultConfiguration.billingAddressLine1FieldOptions
		let addressLine2Options = vaultConfiguration.billingAddressLine2FieldOptions
		let cityOptions = vaultConfiguration.billingAddressCityFieldOptions
		let postalCodeOptions = vaultConfiguration.billingAddressPostalCodeFieldOptions

    let addressVisibility = vaultConfiguration.formConfiguration.billingAddressVisibility
    
		switch addressVisibility {
		case .hidden:
			addressFormView.isHidden = true
			return
		case .visible:
			break
		}

		let validCountriesDataSource = VGSCountryPickerDataSource(validCountryISOCodes: countryOptions.validCountries)

		let addressFieldsOptions = [vaultConfiguration.billingAddressCountryFieldOptions, vaultConfiguration.billingAddressLine1FieldOptions, vaultConfiguration.billingAddressLine2FieldOptions, vaultConfiguration.billingAddressCityFieldOptions, vaultConfiguration.billingAddressPostalCodeFieldOptions].compactMap {return $0 as? VGSCheckoutAddressOptionsProtocol}

		// Check if has visible address fields.
		let visibleAddressFields = addressFieldsOptions.filter({$0.visibility == .visible})
		if visibleAddressFields.isEmpty {
			// Hide address view.
			addressFormView.isHidden = true
			return
		}

		for option in addressFieldsOptions {
			switch option.fieldType {
			case .country:
				if option.visibility == .visible {
					let countryConfiguration = VGSPickerTextFieldConfiguration(collector: vgsCollect, fieldName: countryOptions.fieldName)
					let validCountriesDataSource = VGSCountryPickerDataSource(validCountryISOCodes: countryOptions.validCountries)
					countryConfiguration.dataProvider = VGSPickerDataSourceProvider(dataSource: validCountriesDataSource)
					countryConfiguration.type = .none
					countryConfiguration.isRequiredValidOnly = true

					countryTextField.configuration = countryConfiguration

					// Force select first row in picker.
					countryTextField.selectFirstRow()
				} else {
					addressFormView.countryFieldView.isHidden = true

					var hasCountries = false
					if let countries = countryOptions.validCountries {
						hasCountries = !countries.isEmpty
					}

					if !hasCountries {
						let event = VGSLogEvent(level: .warning, text: "Country field is hidden. You should provide validCountries array", severityLevel: .warning)
						VGSCheckoutLogger.shared.forwardLogEvent(event)
					}
				}
			case .addressLine1:
				if option.visibility == .visible {
					let addressLine1Configuration = VGSConfiguration(collector: vgsCollect, fieldName: addressLine1Options.fieldName)
					addressLine1Configuration.type = .none
					addressLine1Configuration.keyboardType = .default
//					if option.isRequired {
//						addressLine1Configuration.isRequiredValidOnly = true
//					} else {
//						addressLine1Configuration.isRequired = false
//					}
					addressLine1Configuration.validationRules = VGSValidationRuleSet(rules: [
						VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
					])

					addressLine1TextField.configuration = addressLine1Configuration
				} else {
					addressFormView.addressLine1FieldView.isHidden = true
				}
			case .addressLine2:
				if option.visibility == .visible {
					let addressLine2Configuration = VGSConfiguration(collector: vgsCollect, fieldName: addressLine2Options.fieldName)
					addressLine2Configuration.type = .none
					addressLine2Configuration.keyboardType = .default

					addressLine2TextField.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line2_hint")
					addressFormView.addressLine2FieldView.placeholderView.hintLabel.text = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line2_subtitle")

					addressLine2TextField.configuration = addressLine2Configuration
				} else {
					addressFormView.addressLine2FieldView.isHidden = true
				}
			case .city:
				if option.visibility == .visible {
					let cityConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: cityOptions.fieldName)
					cityConfiguration.type = .none
					cityConfiguration.keyboardType = .default
//					if option.isRequired {
//						cityConfiguration.isRequiredValidOnly = true
//					} else {
//						cityConfiguration.isRequired = false
//					}
					cityConfiguration.validationRules = VGSValidationRuleSet(rules: [
						VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
					])

					cityTextField.configuration = cityConfiguration
				} else {
					addressFormView.cityFieldView.isHidden = true
				}
			case .postalCode:
				if option.visibility == .visible {
					let firstCountryRawCode = validCountriesDataSource.countries.first?.code ?? "US"
					let firstCountryISOCode = VGSCountriesISO(rawValue: firstCountryRawCode) ?? VGSAddressCountriesDataProvider.defaultFirstCountryCode

					let postalCodeConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: postalCodeOptions.fieldName)
					postalCodeConfiguration.type = .none
//					if option.isRequired {
					postalCodeConfiguration.isRequiredValidOnly = true
					postalCodeConfiguration.validationRules = VGSValidationRuleSet(rules: [
						VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
					])

					postalCodeConfiguration.validationRules = VGSValidationRuleSet(rules: VGSPostalCodeValidationRulesFactory.validationRules(for: firstCountryISOCode))
					//					} else {
					//						postalCodeConfiguration.isRequired = false
					//					}

					postalCodeConfiguration.returnKeyType = .done



					postalCodeTextField.configuration = postalCodeConfiguration

					VGSPostalCodeFieldView.updateUI(for: addressFormView.postalCodeFieldView, countryISOCode: firstCountryISOCode)
				} else {
					addressFormView.postalCodeFieldView.isHidden = true
				}
			default:
				break
			}
		}
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

	internal static func setupAddressForm(with configuration: VGSCheckoutPayoptBasicConfiguration, vgsCollect: VGSCollect, addressFormView: VGSBillingAddressDetailsSectionView) {

		let countryTextField = addressFormView.countryFieldView.countryTextField
		let addressLine1TextField = addressFormView.addressLine1FieldView.textField
		let addressLine2TextField = addressFormView.addressLine2FieldView.textField
		let cityTextField = addressFormView.cityFieldView.textField
		let postalCodeTextField = addressFormView.postalCodeFieldView.textField

		let countryOptions = configuration.billingAddressCountryFieldOptions
		let addressLine1Options = configuration.billingAddressLine1FieldOptions
		let addressLine2Options = configuration.billingAddressLine2FieldOptions
		let cityOptions = configuration.billingAddressCityFieldOptions
		let postalCodeOptions = configuration.billingAddressPostalCodeFieldOptions

    let addressVisibility = configuration.formConfiguration.billingAddressVisibility
    
    switch addressVisibility {
    case .hidden:
      addressFormView.isHidden = true
      return
    case .visible:
      break
    }

		let validCountriesDataSource = VGSCountryPickerDataSource(validCountryISOCodes: countryOptions.validCountries)

		let addressFieldsOptions = [countryOptions, addressLine1Options, addressLine2Options, cityOptions, postalCodeOptions].compactMap {return $0 as? VGSCheckoutAddressOptionsProtocol}

		// Check if has visible address fields.
		let visibleAddressFields = addressFieldsOptions.filter({$0.visibility == .visible})
		if visibleAddressFields.isEmpty {
			// Hide address view.
			addressFormView.isHidden = true
			return
		}

		for option in addressFieldsOptions {
			switch option.fieldType {
			case .country:
				if option.visibility == .visible {
					let countryConfiguration = VGSPickerTextFieldConfiguration(collector: vgsCollect, fieldName: "card.billing_address.country")
					let validCountriesDataSource = VGSCountryPickerDataSource(validCountryISOCodes: countryOptions.validCountries)
					countryConfiguration.dataProvider = VGSPickerDataSourceProvider(dataSource: validCountriesDataSource)
					countryConfiguration.type = .none
					countryConfiguration.isRequiredValidOnly = true

					countryTextField.configuration = countryConfiguration

					// Force select first row in picker.
					countryTextField.selectFirstRow()
				} else {
					addressFormView.countryFieldView.isHidden = true

					var hasCountries = false
					if let countries = countryOptions.validCountries {
						hasCountries = !countries.isEmpty
					}

					if !hasCountries {
						let event = VGSLogEvent(level: .warning, text: "Country field is hidden. You should provide validCountries array", severityLevel: .warning)
						VGSCheckoutLogger.shared.forwardLogEvent(event)
					}
				}
			case .addressLine1:
				if option.visibility == .visible {
					let addressLine1Configuration = VGSConfiguration(collector: vgsCollect, fieldName: "card.billing_address.address1")
					addressLine1Configuration.type = .none
					addressLine1Configuration.keyboardType = .default
//					if option.isRequired {
//						addressLine1Configuration.isRequiredValidOnly = true
//					} else {
//						addressLine1Configuration.isRequired = false
//					}
					addressLine1Configuration.validationRules = VGSValidationRuleSet(rules: [
						VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
					])

					addressLine1TextField.configuration = addressLine1Configuration
				} else {
					addressFormView.addressLine1FieldView.isHidden = true
				}
			case .addressLine2:
				if option.visibility == .visible {
					let addressLine2Configuration = VGSConfiguration(collector: vgsCollect, fieldName: "card.billing_address.adddressLine2")
					addressLine2Configuration.type = .none
					addressLine2Configuration.keyboardType = .default

					addressLine2TextField.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line2_hint")
					addressFormView.addressLine2FieldView.placeholderView.hintLabel.text = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_address_info_address_line2_subtitle")

					addressLine2TextField.configuration = addressLine2Configuration
				} else {
					addressFormView.addressLine2FieldView.isHidden = true
				}
			case .city:
				if option.visibility == .visible {
					let cityConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "card.billing_address.city")
					cityConfiguration.type = .none
					cityConfiguration.keyboardType = .default
//					if option.isRequired {
//						cityConfiguration.isRequiredValidOnly = true
//					} else {
//						cityConfiguration.isRequired = false
//					}
					cityConfiguration.validationRules = VGSValidationRuleSet(rules: [
						VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
					])

					cityTextField.configuration = cityConfiguration
				} else {
					addressFormView.cityFieldView.isHidden = true
				}
			case .postalCode:
				if option.visibility == .visible {
					let firstCountryRawCode = validCountriesDataSource.countries.first?.code ?? "US"
					let firstCountryISOCode = VGSCountriesISO(rawValue: firstCountryRawCode) ?? VGSAddressCountriesDataProvider.defaultFirstCountryCode

					let postalCodeConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "card.billing_address.postal_code")
					postalCodeConfiguration.type = .none
//					if option.isRequired {
					postalCodeConfiguration.isRequiredValidOnly = true
					postalCodeConfiguration.validationRules = VGSValidationRuleSet(rules: [
						VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
					])

					postalCodeConfiguration.validationRules = VGSValidationRuleSet(rules: VGSPostalCodeValidationRulesFactory.validationRules(for: firstCountryISOCode))
					//					} else {
					//						postalCodeConfiguration.isRequired = false
					//					}

					postalCodeConfiguration.returnKeyType = .done

					postalCodeTextField.configuration = postalCodeConfiguration

					VGSPostalCodeFieldView.updateUI(for: addressFormView.postalCodeFieldView, countryISOCode: firstCountryISOCode)
				} else {
					addressFormView.postalCodeFieldView.isHidden = true
				}
			default:
				break
			}
		}
	}

	/// Updates postal code field view if needed.
	/// - Parameters:
	///   - countryISO: `VGSCountriesISO` object, new country ISO.
	///   - checkoutConfigurationType: `VGScheckoutConfigurationType` object, payment instrument.
	///   - addressFormView: `VGSBillingAddressDetailsSectionView` object, address form view.
	///   - vgsCollect: `VGSCollect` object, an instance of VGSColelct.
	///   - formValidationHelper: `VGSFormValidationHelper` object, validation helper.
	internal static func updatePostalCodeViewIfNeeded(with countryISO: VGSCountriesISO, addressFormView: VGSBillingAddressDetailsSectionView, vgsCollect: VGSCollect, formValidationHelper: VGSFormValidationHelper) {
		let postalCodeFieldView = addressFormView.postalCodeFieldView
		let postalCodeTextField = addressFormView.postalCodeFieldView.textField

		// 1. Unhide/hide postal code field view.
		// 2. Register/unregister postal code text field in collect.
		// 3. Add/remove postal code field view from validation helper.
		if countryISO.hasPostalCode {
			postalCodeFieldView.isHiddenInCheckoutStackView = false
			vgsCollect.registerTextFields(textField: [postalCodeTextField])
			formValidationHelper.fieldViewsManager.appendFieldViews([postalCodeFieldView])
		} else {
			postalCodeFieldView.isHiddenInCheckoutStackView = true
			vgsCollect.unsubscribeTextField(postalCodeTextField)
			formValidationHelper.fieldViewsManager.removeFieldView(postalCodeFieldView)
		}
	}

	/*
	Update form for counries without address verification support.

	internal static func updateAddressForm(with countryISO: VGSCountriesISO, checkoutConfigurationType: VGScheckoutConfigurationType, addressFormView: VGSBillingAddressDetailsSectionView, vgsCollect: VGSCollect, formValidationHelper: VGSFormValidationHelper) {
		switch checkoutConfigurationType {
		case .vault:
			break
		case .payoptAddCArd:
			// If country does not support Address verification hide all other fields and unregister them from collect.
			// Otherwise register and show fields again. Only for payopt flow.
			let isAddressVerificationAvailable = VGSBillingAddressUtils.isAddressVerificationAvailable(for: countryISO)

			if isAddressVerificationAvailable {
				addressFormView.cityAndPostalCodeStackView.isHiddenInCheckoutStackView = false
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
				formValidationHelper.fieldViewsManager.appendFieldViews([addressFormView.addressLine1FieldView, addressFormView.addressLine2FieldView, addressFormView.cityFieldView,  addressFormView.postalCodeFieldView])
			} else {
				addressFormView.cityAndPostalCodeStackView.isHiddenInCheckoutStackView = true
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
	*/
}
