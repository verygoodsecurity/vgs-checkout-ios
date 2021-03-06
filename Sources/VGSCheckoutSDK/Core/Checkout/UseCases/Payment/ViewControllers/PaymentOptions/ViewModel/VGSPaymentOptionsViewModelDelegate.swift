//
//  VGSPaymentOptionsViewModelDelegate.swift
//  VGSCheckoutSDK

import Foundation

/// A set of methods to notify about changes in VGSPaymentOptionsViewModel.
internal protocol VGSPaymentOptionsViewModelDelegate: AnyObject {

	/// Tells the delegate that saved card selection state was updated.
	func savedCardSelectionDidUpdate()

	/// Tells the delegate that saved cards were updated before editing.
	func savedCardDidUpdateBeforeEditing()

	/// Tells the delegate that saved cards were updated after editing.
	func savedCardDidUpdateAfterEditing()

	/// Tells the delegate that user removed saved card.
	/// - Parameter id: `String` object, saved card instrument id.
	/// - Parameter requestResult: `VGSCheckoutRequestResult` object, request result.
	func savedCardDidRemove(with id: String, requestResult: VGSCheckoutRequestResult)

	/// Tells the delegate that pay with new card option was tapped.
	func payWithNewCardDidTap()
}
