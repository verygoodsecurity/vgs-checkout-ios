//
//  VGSCardDataFormConfigurationManager.swift
//  VGSCheckoutSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Encapsulates form setup with collect.
internal class VGSCardDataFormConfigurationManager {

	internal static func setupCardForm(with vaultConfiguration: VGSCheckoutCustomConfiguration, vgsCollect: VGSCollect, cardSectionView: VGSCardDetailsSectionView) {
		let fieldViews = cardSectionView.fieldViews

		let cardNumberFieldName = vaultConfiguration.formConfiguration.cardOptions.cardNumberOptions.fieldName
		let cvcFieldName = vaultConfiguration.formConfiguration.cardOptions.cvcOptions.fieldName

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

		let expDateOptions = vaultConfiguration.formConfiguration.cardOptions.expirationDateOptions

		let expDateConfiguration = VGSExpDateConfiguration(checkoutExpDateOptions: expDateOptions, collect: vgsCollect)
		expDateConfiguration.isRequiredValidOnly = true
    expDateConfiguration.inputSource = .keyboard
		/// Update validation rules
    let expDateValidationRule = VGSValidationRuleCardExpirationDate(dateFormat: expDateOptions.inputDateFormat,
                                                                    error: VGSValidationErrorType.expDate.rawValue)
		expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [expDateValidationRule])
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

	/* Sample of multiplexing payload:
	 {
		 "card" : {
			 "billing_address" : {
				 "city" : "Texas City",
				 "address1" : "1",
				 "country" : "US",
				 "adddressLine2" : "1",
				 "postal_code" : "12345"
			 },
			 "cvc" : "333",
			 "exp_month" : "10",
			 "name" : "Joe Doe",
			 "number" : "4111111111111111",
			 "exp_year" : "2022"
		 }
	 }
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

		// Enable validation of unknown card brand if needed
		cardConfiguration.validationRules = VGSValidationRuleSet(rules: [
			VGSValidationRulePaymentCard(error: VGSValidationErrorType.cardNumber.rawValue, validateUnknownCardBrand: true)
		])
		cardNumber.configuration = cardConfiguration
		cardNumber.placeholder = "4111 1111 1111 1111"

		cardNumber.textAlignment = .natural
		cardNumber.cardIconLocation = .left

		let expDateConfiguration = VGSExpDateConfiguration(collector: vgsCollect, fieldName: "")
    
    // Setup Date Format
    let inputDateFormat = VGSCheckoutCardExpDateFormat.shortYear
    expDateConfiguration.inputDateFormat = inputDateFormat
    expDateConfiguration.outputDateFormat = .longYear
    expDateConfiguration.formatPattern = inputDateFormat.inputFormatPattern
    expDateConfiguration.serializers = [VGSCheckoutExpDateSeparateSerializer(monthFieldName: "card.exp_month", yearFieldName: "card.exp_year")]

		// Update validation rules
    let expDateValidationRule = VGSValidationRuleCardExpirationDate(dateFormat: inputDateFormat,
                                                                    error: VGSValidationErrorType.expDate.rawValue)
		expDateConfiguration.validationRules = VGSValidationRuleSet(rules: [expDateValidationRule])
    
    expDateConfiguration.inputSource = .keyboard
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
		//holderConfiguration.returnKeyType = .next

		cardHolderName.textField.configuration = holderConfiguration
	}
}
