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
			OrderItem(title: "Pizza Mars", image: UIImage(named: "pizza_diablo"), price: 9.90),
			OrderItem(title: "Alien Noodles", image: UIImage(named: "pizza_vegano"), price: 44.95)
		]
	}
}
