//
//  VGSPaymentOption.swift
//  VGSCheckoutSDK

import Foundation

/// Payment options.
internal enum VGSPaymentOption {

	/// Saved card.
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

	/// Removes selection from all saved cards.
	mutating func unselectAllSavedCards() {
		for index in 0..<self.count {
			let option = self[index]

			switch option {
			case .savedCard(var card):
					card.isSelected = false

				// Update card.
				self[index] = .savedCard(card)
			case .newCard:
				continue
			}
		}
	}

	/// Marks as selected previously saved card finInstrumentId or the first one.
	/// - Parameter finInstrumentId: `String?` object, fin id of the last saved card or nil if last saved card was removed. Next first card will be mark as selected.
	mutating func selectSavedCardAfterEditing(with finInstrumentId: String?) {
		for index in 0..<count {
			let option = self[index]

			switch option {
			case .savedCard(var card):
				// If no last selected card set first as initial.
				if finInstrumentId == nil {
					if index == 0 {
						card.isSelected = true
					}
				} else {
					// Restore previously selected card id.
					if card.id == finInstrumentId {
						card.isSelected = true
					}
				}

				// Update card.
				self[index] = .savedCard(card)
			case .newCard:
				continue
			}
		}
	}
}
