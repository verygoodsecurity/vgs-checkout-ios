//
//  VGSFormFieldsValidatorFactory.swift
//  VGSCheckout

import Foundation

/// Factory class provides validators for different form field type.
internal class VGSFormFieldsValidatorFactory {

	/// Provides validator for form field type.
	/// - Parameter formFieldType: `VGSAddCardFormFieldType` object, field type.
	/// - Returns: `VGSFormTextFieldValidationProtocol` object, validator.
	static func provideFieldValidator(for formFieldType: VGSAddCardFormFieldType) -> VGSFormTextFieldValidationProtocol {
		switch formFieldType {
		case .cardNumber:
			return VGSCardNumberFieldValidator()
		case .cardholderName, .firstName, .lastName:
			return VGSCardholderFieldValidator()
		case .expirationDate:
			return VGSExpDateFieldValidator()
		case .cvc:
			return VGSCardCVCFieldValidator()
		case .country, .addressLine1, .addressLine2, .city, .state:
			// TODO: - add country validator
			return VGSCardNumberFieldValidator()
		}
	}
}
