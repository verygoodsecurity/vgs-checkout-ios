//
//  VGSPaymentOption.swift
//  VGSCheckoutSDK

import Foundation

/// Payment options.
internal enum VGSPaymentOption {

	/// Saved card.
	/// - Parameter card: `VGSSavedCardModel` object, saved card object.
	case savedCard(_ card: VGSSavedCardModel)

	/// New card.
	case newCard

	/// Saved card associated value of type `VGSSavedCardModel` if .case matches .savedCard.
	internal var savedCardModel: VGSSavedCardModel? {
		switch self {
		case .savedCard(let cardModel):
			return cardModel
		default:
			return nil
		}
	}
}

// no:doc
internal extension Array where Element == VGSPaymentOption {

	/// Preselects first payment card
	mutating func preselectFirstSavedCard() {
		guard let firstPaymentOption = self.first else {return}
			switch firstPaymentOption {
			case .savedCard(let card):
				card.isSelected = true
			default:
				break
		}
	}

	/// Removes selected card by id.
	/// - Parameter id: `String` object, id to remove.
	mutating func removeSavedCard(with id: String) {
		self = filter({ option in
			guard let card = option.savedCardModel else {
				return true
			}

			return card.id != id
		})
	}

	/// `true` if payment options contain saved card.
	var hasSelectedCard: Bool {
		let allSavedCards = compactMap({return $0.savedCardModel})
		return !allSavedCards.filter({$0.isSelected}).isEmpty
	}

	/// Current selected card id.
	var selectedCardId: String? {
		let allSavedCards = compactMap({return $0.savedCardModel})
		return allSavedCards.filter({$0.isSelected}).first?.id
	}

	/// `true` if payment options have saved card.
	var hasSavedCards: Bool {
		let allSavedCards = compactMap({return $0.savedCardModel})
		return !allSavedCards.isEmpty
	}
}
