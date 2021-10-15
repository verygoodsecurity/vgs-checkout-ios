//
//  VGSFormFieldsValidatorFactory.swift
//  VGSCheckoutSDK

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
		case .addressLine1:
			return VGSAddressLine1FieldValidator()
		case .addressLine2:
			return VGSAddressLine2FieldValidator()
		case .city:
			return VGSCityFieldValidator()
		case .state:
			return VGSAddressRegionFieldValidator()
		case .postalCode:
			return VGSPostalCodeFieldValidator()
		case .country:
			return VGSCountryFieldValidator()
		}
	}
}
