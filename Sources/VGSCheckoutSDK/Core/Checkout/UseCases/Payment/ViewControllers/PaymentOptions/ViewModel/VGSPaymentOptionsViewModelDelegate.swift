//
//  VGSPaymentOptionsViewModelDelegate.swift
//  VGSCheckoutSDK

import Foundation

/// A set of methods to notify about changes in VGSPaymentOptionsViewModel.
internal protocol VGSPaymentOptionsViewModelDelegate: AnyObject {

	/// Tells the delegate that saved card selection state was updated.
	func savedCardSelectionDidUpdate()

	/// Tells the delegate that saved cards were updated for editing.
	func savedCardDidUpdateForEditing()

	/// Tells the delegate that user removed saved card.
	/// - Parameter id: `String` object, saved card instrument id.
	func savedCardDidRemove(with id: String)

	/// Tells the delegate that pay with new card option was tapped.
	func payWithNewCardDidTap()
}
