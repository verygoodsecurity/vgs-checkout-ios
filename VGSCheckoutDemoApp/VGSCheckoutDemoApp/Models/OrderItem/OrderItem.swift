//
//  OrderItem.swift
//  VGSCheckoutDemoApp
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds order item.
struct OrderItem {

	/// Number formatter for price.
	static let numberFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.minimumFractionDigits = 2
		formatter.generatesDecimalNumbers = true

		return formatter
	}()

	/// Item title.
	let title: String

	/// Item image.
	let image: UIImage?

	/// Price.
	let price: Decimal

	/// Price string.
	var priceText: String {
		return OrderItem.numberFormatter.string(from: price as NSDecimalNumber) ?? ""
	}
}

extension Array where Element == OrderItem {

  /// Total price.
	var totalPrice: Decimal {
		return map({$0.price}).reduce(0, +)
	}

	/// Total price text.
	var totalPriceText: String {
		return OrderItem.numberFormatter.string(from: totalPrice as NSDecimalNumber) ?? ""
	}
}
