//
//  VGSPaymentOptionsViewModel+Extensions.swift
//  VGSCheckoutSDK

import Foundation

// no:doc
internal extension VGSPaymentOptionsViewModel {

	// no:doc
	static func provideMockedData() -> [VGSPaymentOption] {
		return [
			.savedCard(VGSSavedCardModel(id: "1", cardBrand: "visa", last4: "1231", expDate: "12/22", cardHolder: "John Smith 1 Smith J Longggggggggg ")),
			.savedCard(VGSSavedCardModel(id: "2", cardBrand: "maestro", last4: "1488", expDate: "01/23", cardHolder: "John Smith 2")),
			.savedCard(VGSSavedCardModel(id: "3", cardBrand: "visa", last4: "1233", expDate: "12/24", cardHolder: "John Smith 3")),
			.savedCard(VGSSavedCardModel(id: "4", cardBrand: "maestro", last4: "5674", expDate: "01/25", cardHolder: "John Smith 4")),
			.savedCard(VGSSavedCardModel(id: "5", cardBrand: "visa", last4: "1235", expDate: "12/26", cardHolder: "John Smith 5")),
			.savedCard(VGSSavedCardModel(id: "6", cardBrand: "maestro", last4: "5676", expDate: "01/27", cardHolder: "John Smith 6")),
			.savedCard(VGSSavedCardModel(id: "7", cardBrand: "visa", last4: "1237", expDate: "12/28", cardHolder: "John Smith 7")),
			.savedCard(VGSSavedCardModel(id: "8", cardBrand: "maestro", last4: "5678", expDate: "01/29", cardHolder: "John Smith 8")),
			.savedCard(VGSSavedCardModel(id: "9", cardBrand: "visa", last4: "1299", expDate: "12/30", cardHolder: "John Smith 9")),
			.savedCard(VGSSavedCardModel(id: "10", cardBrand: "maestro", last4: "5688", expDate: "01/31", cardHolder: "John Smith 10")),
			.savedCard(VGSSavedCardModel(id: "11", cardBrand: "visa", last4: "1490", expDate: "12/32", cardHolder: "John Smith 11")),
			.savedCard(VGSSavedCardModel(id: "12", cardBrand: "maestro", last4: "1238", expDate: "01/33", cardHolder: "John Smith 12")),
			.newCard
		]
	}
}

// no:doc
extension VGSPaymentOptionsViewModel {
	
	/// Remove card popup texts.
	enum RemoveCardPopupConstants: String {

		/// Popup title.
		case title = "vgs_checkout_remove_card_popup_title"

		/// Popup message.
		case messageText = "vgs_checkout_remove_card_popup_description"

		/// Popup cancel action title.
		case cancelActionTitle = "vgs_checkout_remove_card_popup_cancel_button_title"

		/// Popup remove card action title.
		case removeActionTitle = "vgs_checkout_remove_card_popup_remove_card_button_title"

		/// Localized text.
		internal var localized: String {
			return VGSCheckoutLocalizationUtils.vgsLocalizedString(forKey: self.rawValue)
		}
	}
}
