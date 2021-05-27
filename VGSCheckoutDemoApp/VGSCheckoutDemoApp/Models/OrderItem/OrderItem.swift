//
//  OrderItem.swift
//  VGSCheckoutDemoApp
//

import Foundation
import UIKit

/// Holds order item.
struct OrderItem {

	/// Item title.
	let title: String

	/// Item image.
	let image: UIImage?

	/// Price.
	let price: Decimal
}

extension Array where Element == OrderItem {

  /// Total price.
	var totalPrice: Decimal {
		return map({$0.price}).reduce(0, +)
	}
}
