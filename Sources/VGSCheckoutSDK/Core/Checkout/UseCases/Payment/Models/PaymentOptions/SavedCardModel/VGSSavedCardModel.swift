//
//  VGSSavedCardModel.swift
//  VGSCheckoutSDK

import Foundation

/// Holds saved card data.
internal class VGSSavedCardModel {

	// MARK: - Vars

	/// Fin instrument id.
	internal let id: String

	/// Card brand name.
	internal let cardBrandName: String

	/// Card brand.
	internal let cardBrand: VGSCheckoutPaymentCards.CardBrand

	/// Last 4 digits.
	internal let last4: String

	/// Exp date.
	internal let expDate: String

	/// Card holder name.
	internal let cardHolder: String

	/// A Boolean flag, indicates selection state, default is `false`.
	internal var isSelected = false

	/// no:doc
	struct JSONKeys {
		static let data = "data"
		static let id = "id"
		static let card = "card"
		static let number = "number"
		static let name = "name"
		static let expYear = "exp_year"
		static let expMonth = "exp_month"
		static let brand = "brand"
	}

	// MARK: - Initializer

	/// Initializer.
	internal init?(json: JsonData) {
		let keys = JSONKeys.self
		guard let dataJSON = json[keys.data] as? JsonData,
					let id = dataJSON[keys.id] as? String,
				let cardJSON = dataJSON[keys.card] as? JsonData,
		let cardNumber = cardJSON[keys.number] as? String,
		let name = cardJSON[keys.name] as? String,
		let expYear = cardJSON[keys.expYear] as? Int,
		let expMonth = cardJSON[keys.expMonth] as? Int,
		let brand = cardJSON[keys.brand] as? String else {
			return nil
		}
		self.id = id
		self.cardHolder = name
		self.last4 = String(cardNumber.suffix(4))
		self.expDate = "\(expMonth)/" + "\(expYear)"
		self.cardBrandName = brand
		self.cardBrand = VGSCheckoutPaymentCards.CardBrand(brand)
	}

	/// Initializer
	/// - Parameters:
	///   - id: `String` object, card fin id.
	///   - cardBrand: `String` object, card brand name.
	///   - last4: `String` object, last 4 digits.
	///   - expDate: `String` object, exp date.
	///   - cardHolder: `String` object, card holder name.
	internal init(id: String, cardBrand: String, last4: String, expDate: String, cardHolder: String) {
		self.id = id
		self.cardBrandName = cardBrand
		self.last4 = last4
		self.expDate = expDate
		self.cardHolder = cardHolder
		self.cardBrand = VGSCheckoutPaymentCards.CardBrand(cardBrand)
	}

	/// Payment option cell view model.
	internal var paymentOptionCellViewModel: VGSPaymentOptionCardCellViewModel {
		let image = cardBrand.brandIcon

		let last4Text = "•••• \(last4) | \(expDate)"

		return VGSPaymentOptionCardCellViewModel(cardBrandImage: image, cardHolder: cardHolder, last4AndExpDateText: last4Text, isSelected: isSelected)
	}

	/// Masled last 4 digits.
	internal var maskedLast4: String {
		return "•••• \(last4)"
	}
}

// no:doc
internal extension Array where Element == VGSSavedCardModel {
	/// Reorders array of saved cards by fin instrument ids.
	/// - Parameter cardIds: `[String]` object, an array of fin instrument ids.
	/// - Returns: `[VGSSavedCardModel]` object, an array of reordered saved cards.
	func reorderByIds(_ cardIds: [String]) -> [VGSSavedCardModel] {
		var orderedArray: [VGSSavedCardModel] = []
		cardIds.forEach { id in
			for card in self {
				if card.id == id {
					orderedArray.append(card)
				}
			}
		}

		return orderedArray
	}
}
