//
//  VGSAddCardFormFieldType.swift
//  VGSCheckoutSDK

import Foundation

/// Defines UI sections on add card screen.
internal enum VGSAddCardSection {

	/// Card details section.
	case card

	/// Billing address section.
	case billingAddress
}

/// Defines checkout field types.
internal enum VGSAddCardFormFieldType {

	/// Card number.
	case cardNumber

	/// Expiration date.
	case expirationDate

	/// Security code (CVC/CVV).
	case cvc

	/// Card holder name.
	case cardholderName

	/// First name.
	case firstName

	/// Last name.
	case lastName

	/// Country.
	case country

	/// Address line 1.
	case addressLine1

	/// Address line 2.
	case addressLine2

	/// City.
	case city

	/// State/region/county/province.
	case state

	/// Zip/postal code.
	case postalCode

	/// Analytics field name.
	internal var analyticsFieldName: String {
		switch self {
		case .cardNumber:
			return "cardNumber"
		case .expirationDate:
			return "expDate"
		case .addressLine1:
			return "addressLine1"
		case .addressLine2:
			return "addressLine2"
		case .cardholderName:
			return "cardholderName"
		case .cvc:
			return "cvc"
		case .city:
			return "city"
		case .postalCode:
			return "postalCode"
		case .country:
			return "country"
		default:
			return ""
		}
	}

	/// Corresponding form block.
//	internal var sectionBlock: VGSAddCardSectionBlock {
//		switch self {
//		case .cardholderName, .firstName, .lastName:
//			return .cardHolder
//		case .cardNumber, .expirationDate, .cvc:
//			return .cardDetails
//		case .country, .addressLine1, .addressLine2, .city, .state, .postalCode:
//			return .addressInfo
//		}
//	}
//
	/// Corresponding form section.
	internal var formSection: VGSAddCardSection {
		switch self {
		case .cardNumber, .expirationDate, .cvc, .cardholderName, .firstName, .lastName:
			return .card
		case .country, .addressLine1, .addressLine2, .city, .state, .postalCode:
			return .billingAddress
		}
	}

	/// Empty field name error.
	internal var emptyFieldNameError: String {
		return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: emptyFieldNameLocalizationKey)
	}

	/// Localizable string key.
	private var emptyFieldNameLocalizationKey: String {
		switch self {
		case .cardholderName:
			return "vgs_checkout_card_holder_empty_error"
		case .firstName:
			return "vgs_checkout_card_holder_empty_error"
		case .lastName:
			return "vgs_checkout_card_holder_empty_error"
		case .cardNumber:
			return "vgs_checkout_card_number_empty_error"
		case .expirationDate:
			return "vgs_checkout_expiration_date_empty_error"
		case .cvc:
			return "vgs_checkout_verification_code_invalid_error"
		case .addressLine1:
			return "vgs_checkout_address_info_line1_empty_error"
		case .city:
			return "vgs_checkout_address_info_city_empty_error"
		case .state:
			return "vgs_checkout_address_info_region_empty_error"
		case .postalCode:
			return "vgs_checkout_address_info_zipcode_empty_error"
		default:
			return "Field is empty"
		}
	}
}
