//
//  UITableView+Extensions.swift
//  VGSCheckoutSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

// swiftlint:disable all

internal extension UITableView {
		func dequeue<T: UITableViewCell>(cellForRowAt indexPath: IndexPath) -> T {
			return dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as! T
		}

	func registerTableViewCell<T: UITableViewCell>(tableViewCellClass: T) {
		register(T.self, forCellReuseIdentifier: "\(T.self)")
	}
}

// swiftlint:enable all
