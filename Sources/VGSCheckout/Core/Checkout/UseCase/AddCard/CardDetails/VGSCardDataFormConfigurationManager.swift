//
//  VGSCardDataFormConfigurationManager.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Encapsulates form setup with collect.
internal class VGSCardDataFormConfigurationManager {

	internal static func setupCardForm(with vaultConfiguration: VGSCheckoutConfiguration, vgsCollect: VGSCollect, cardSectionView: VGSCardDetailsSectionView) {
		let fieldViews = cardSectionView.fieldViews

		let cardNumberFieldName = vaultConfiguration.formConfiguration.cardOptions.cardNumberOptions.fieldName
		let cvcFieldName = vaultConfiguration.formConfiguration.cardOptions.cvcOptions.fieldName
		let expDateFieldName = vaultConfiguration.formConfiguration.cardOptions.expirationDateOptions.fieldName

        guard let cardNumber = cardSectionView.cardNumberFieldView.textField as? VGSCardTextField,
              let expCardDate = cardSectionView.expDateFieldView.textField as? VGSExpDateTextField,
              let cvcCardNum = cardSectionView.cvcFieldView.textField as? VGSCVCTextField
              else {
            return
        }
				

		let cardConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: cardNumberFieldName)
		cardConfiguration.type = .cardNumber
		cardConfiguration.isRequiredValidOnly = true

		/// Enable validation of unknown card brand if needed
		cardConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRulePaymentCard(error: VGSValidationErrorType.cardNumber.rawValue, validateUnknownCardBrand: true)
		])
		cardNumber.configuration = cardConfiguration
		cardNumber.placeholder = "4111 1111 1111 1111"
        cardNumber.isIconHidden = vaultConfiguration.cardNumberFieldOptions.isIconHidden

		cardNumber.textAlignment = .natural
		cardNumber.cardIconLocation = .left

		let expDateConfiguration = VGSExpDateConfiguration(collector: vgsCollect, fieldName: expDateFieldName)
		expDateConfiguration.isRequiredValidOnly = true
		expDateConfiguration.type = .expDate

		/// Default .expDate format is "##/##"
		expDateConfiguration.formatPattern = "##/##"

		/// Update validation rules
		/// FIXME - hardcoded for now!
		expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleCardExpirationDate(dateFormat: .shortYear, error: VGSValidationErrorType.expDate.rawValue)
		])

		expDateConfiguration.inputSource = .keyboard
		expDateConfiguration.inputDateFormat = .shortYear
		expCardDate.configuration = expDateConfiguration
		expCardDate.placeholder = "MM/YY"

		let cvcConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: cvcFieldName)
		cvcConfiguration.isRequired = true
		cvcConfiguration.type = .cvc

		cvcCardNum.configuration = cvcConfiguration
		cvcCardNum.isSecureTextEntry = true
        cvcCardNum.cvcIconLocation = .left
        cvcCardNum.isIconHidden = vaultConfiguration.formConfiguration.cardOptions.cvcOptions.isIconHidden
		cvcCardNum.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_security_code")

		let cardHolderOptions = vaultConfiguration.cardHolderFieldOptions
		if cardHolderOptions.fieldVisibility == .visible {
			switch cardHolderOptions.fieldNameType {
			case .single(let fieldName):
				let holderConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: fieldName)
				holderConfiguration.type = .cardHolderName
				holderConfiguration.validationRules = VGSValidationRuleSet(rules: [
					VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
				])
				holderConfiguration.returnKeyType = .next

				if let cardHolderName = fieldViews.first(where: {$0.fieldType == .cardholderName}) {
					cardHolderName.textField.textAlignment = .natural
					cardHolderName.textField.configuration = holderConfiguration
				}
      /*
			case .splitted(let firstName, lastName: let lastName):
				if let firstNameFieldView = fieldViews.first(where: {$0.fieldType == .firstName}), let lastNameFieldView = fieldViews.first(where: {$0.fieldType == .lastName})  {

					let firstNameConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: firstName)
					firstNameConfiguration.type = .cardHolderName
					firstNameConfiguration.returnKeyType = .next
					firstNameConfiguration.validationRules = VGSValidationRuleSet(rules: [
						VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
					])

					firstNameFieldView.textField.textAlignment = .natural
					firstNameFieldView.textField.configuration = firstNameConfiguration

					let lastNameConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: lastName)
					lastNameConfiguration.type = .cardHolderName
					lastNameConfiguration.returnKeyType = .next
					lastNameConfiguration.validationRules = VGSValidationRuleSet(rules: [
						VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
					])

					lastNameFieldView.textField.textAlignment = .natural
					lastNameFieldView.textField.configuration = firstNameConfiguration
				}
       */
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

	internal static func setupCardForm(with multiplexingConfiguration: VGSCheckoutMultiplexingConfiguration, vgsCollect: VGSCollect, cardSectionView: VGSCardDetailsSectionView) {

		let fieldViews = cardSectionView.fieldViews

        guard let cardNumber = cardSectionView.cardNumberFieldView.textField as? VGSCardTextField,
              let expCardDate = cardSectionView.expDateFieldView.textField as? VGSExpDateTextField,
              let cvcCardNum = cardSectionView.cvcFieldView.textField as? VGSCVCTextField
              else {
            return
        }

		let cardConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "card.number")
		cardConfiguration.type = .cardNumber
		cardConfiguration.isRequiredValidOnly = true

		/// Enable validation of unknown card brand if needed
		cardConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRulePaymentCard(error: VGSValidationErrorType.cardNumber.rawValue, validateUnknownCardBrand: true)
		])
		cardNumber.configuration = cardConfiguration
		cardNumber.placeholder = "4111 1111 1111 1111"

		cardNumber.textAlignment = .natural
		cardNumber.cardIconLocation = .left

		let expDateConfiguration = VGSExpDateConfiguration(collector: vgsCollect, fieldName: "")
		expDateConfiguration.type = .expDate
		expDateConfiguration.inputDateFormat = .shortYear
		expDateConfiguration.outputDateFormat = .longYear
		expDateConfiguration.serializers = [VGSCheckoutExpDateSeparateSerializer(monthFieldName: "card.exp_month", yearFieldName: "card.exp_year")]
		expDateConfiguration.formatPattern = "##/##"
		expDateConfiguration.inputSource = .keyboard

		/// Update validation rules
		expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleCardExpirationDate(dateFormat: .shortYear, error: VGSValidationErrorType.expDate.rawValue)
		])

		expDateConfiguration.inputDateFormat = .shortYear
		expCardDate.configuration = expDateConfiguration
		expCardDate.placeholder = "MM/YY"

		let cvcConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "card.cvc")
		cvcConfiguration.type = .cvc

		cvcCardNum.configuration = cvcConfiguration
		cvcCardNum.isSecureTextEntry = true
		cvcCardNum.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_security_code")

		guard let cardHolderName = fieldViews.first(where: {$0.fieldType == .cardholderName}) else {
			assertionFailure("Invalid multiplexing setup!")
			return
		}

		cardHolderName.textField.textAlignment = .natural
		let holderConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "card.name")
		holderConfiguration.type = .cardHolderName
		holderConfiguration.type = .cardHolderName
		holderConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
		])
		holderConfiguration.keyboardType = .namePhonePad
		holderConfiguration.returnKeyType = .next

		cardHolderName.textField.configuration = holderConfiguration
	}
}
