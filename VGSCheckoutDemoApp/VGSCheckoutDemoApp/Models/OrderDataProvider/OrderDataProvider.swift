//
//  OrderDataProvider.swift
//  VGSCheckoutDemoApp
//

import Foundation
import UIKit

/// Order data provider.
final class OrderDataProvider {
	/// Provides order items.
	/// - Returns: An array of `OrderItem` objects.
	static func provideOrders() -> [OrderItem] {
		return [
			OrderItem(title: "Pizza diablo", image: UIImage(named: "pizza_diable"), price: 10),
			OrderItem(title: "Pizza diablo", image: UIImage(named: "pizza_vegano"), price: 30.50)
		]
	}
}
