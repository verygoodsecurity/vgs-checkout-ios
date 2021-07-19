//
//  VGSCardDataFormConfigurationManager.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Encapsulates form setup with collect.
internal class VGSCardDataFormConfigurationManager {

	internal static func setupCardForm(with vaultConfiguration: VGSCheckoutConfiguration, vgsCollect: VGSCollect, cardFormView: VGSCardDetailsSectionView) {
		let textFiedFormItems = cardFormView.formItems

		let cardNumberFieldName = vaultConfiguration.formConfiguration.cardOptions.cardNumberOptions.fieldName
		let cvcFieldName = vaultConfiguration.formConfiguration.cardOptions.cvcOptions.fieldName
		let expDateFieldName = vaultConfiguration.formConfiguration.cardOptions.expirationDateOptions.fieldName

		let cardNumber = cardFormView.cardNumberFormItemView.cardTextField
		let expCardDate = cardFormView.expDateFormItemView.expDateTextField
		let cvcCardNum = cardFormView.cvcFormItemView.cvcTextField

		let cardConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: cardNumberFieldName)
		cardConfiguration.type = .cardNumber
		cardConfiguration.isRequiredValidOnly = true

		/// Enable validation of unknown card brand if needed
		cardConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRulePaymentCard(error: VGSValidationErrorType.cardNumber.rawValue, validateUnknownCardBrand: true)
		])
		cardNumber.configuration = cardConfiguration
		cardNumber.placeholder = "4111 1111 1111 1111"

		cardNumber.textAlignment = .natural
		cardNumber.cardIconLocation = .right

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
	//        expCardDate.monthPickerFormat = .longSymbols

		let cvcConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: cvcFieldName)
		cvcConfiguration.isRequired = true
		cvcConfiguration.type = .cvc

		cvcCardNum.configuration = cvcConfiguration
		cvcCardNum.isSecureTextEntry = true
		cvcCardNum.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_expiration_date_hint")
		cvcCardNum.tintColor = .lightGray

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

				if let cardHolderName = textFiedFormItems.first(where: {$0.fieldType == .cardholderName}) {
					cardHolderName.textField.textAlignment = .natural
					cardHolderName.textField.configuration = holderConfiguration
				}
			/*
			case .splitted(let firstName, lastName: let lastName):
				if let firstNameFormItem = textFiedFormItems.first(where: {$0.fieldType == .firstName}), let lastNameFormItem = textFiedFormItems.first(where: {$0.fieldType == .lastName})  {

					let firstNameConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: firstName)
					firstNameConfiguration.type = .cardHolderName
					firstNameConfiguration.returnKeyType = .next
					firstNameConfiguration.validationRules = VGSValidationRuleSet(rules: [
						VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
					])

					firstNameFormItem.textField.textAlignment = .natural
					firstNameFormItem.textField.configuration = firstNameConfiguration

					let lastNameConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: lastName)
					lastNameConfiguration.type = .cardHolderName
					lastNameConfiguration.returnKeyType = .next
					lastNameConfiguration.validationRules = VGSValidationRuleSet(rules: [
						VGSValidationRuleLength(min: 1, max: 64, error: VGSValidationErrorType.length.rawValue)
					])

					lastNameFormItem.textField.textAlignment = .natural
					lastNameFormItem.textField.configuration = firstNameConfiguration
				}
			*/
			}
		}
	}

	internal static func setupCardForm(with multiplexingConfiguration: VGSCheckoutMultiplexingConfiguration, vgsCollect: VGSCollect, cardFormView: VGSCardDetailsSectionView) {

		let textFiedFormItems = cardFormView.formItems

		let cardNumber = cardFormView.cardNumberFormItemView.cardTextField
		let expCardDate = cardFormView.expDateFormItemView.expDateTextField
		let cvcCardNum = cardFormView.cvcFormItemView.cvcTextField

		let cardConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "data.attributes.details.number")
		cardConfiguration.type = .cardNumber
		cardConfiguration.isRequiredValidOnly = true

		/// Enable validation of unknown card brand if needed
		cardConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRulePaymentCard(error: VGSValidationErrorType.cardNumber.rawValue, validateUnknownCardBrand: true)
		])
		cardNumber.configuration = cardConfiguration
		cardNumber.placeholder = "4111 1111 1111 1111"

		cardNumber.textAlignment = .natural
		cardNumber.cardIconLocation = .right

		let expDateConfiguration = VGSExpDateConfiguration(collector: vgsCollect, fieldName: "data.attributes.details")
		expDateConfiguration.type = .expDate
		expDateConfiguration.inputDateFormat = .shortYear
		expDateConfiguration.outputDateFormat = .longYear
		expDateConfiguration.serializers = [VGSCheckoutExpDateSeparateSerializer(monthFieldName: "data.attributes.details.month", yearFieldName: "data.attributes.details.year")]
		expDateConfiguration.formatPattern = "##/##"
		expDateConfiguration.inputSource = .keyboard

		/// Update validation rules
		expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRuleCardExpirationDate(dateFormat: .shortYear, error: VGSValidationErrorType.expDate.rawValue)
		])

		expDateConfiguration.inputDateFormat = .shortYear
		expCardDate.configuration = expDateConfiguration
		expCardDate.placeholder = "MM/YY"

		let cvcConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "data.attributes.details.verification_value")
		cvcConfiguration.type = .cvc

		cvcCardNum.configuration = cvcConfiguration
		cvcCardNum.isSecureTextEntry = true
		cvcCardNum.placeholder = VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: "vgs_checkout_card_expiration_date_hint")
		cvcCardNum.tintColor = .lightGray

		guard let cardHolderName = textFiedFormItems.first(where: {$0.fieldType == .cardholderName}) else {
			assertionFailure("Invalid multiplexing setup!")
			return
		}

		cardHolderName.textField.textAlignment = .natural
		let holderConfiguration = VGSConfiguration(collector: vgsCollect, fieldName: "data.attributes.details.name")
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
