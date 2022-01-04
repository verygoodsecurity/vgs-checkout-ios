//
//  VGSFormatAmountUtils.swift
//  VGSCheckoutSDK

import Foundation

/// Amount formatter utils.
internal final class VGSFormatAmountUtils {

	/// no:doc
	private init() {}

	/// Formats money amounts.
	///
	/// - Parameters:
	///   - amount: `Int` object, amount in decimals.
	///   - currencyCode: `String` object, currency.
	///   - localeIdentifier: `String?` object, locale identifier.
	/// - Returns: The formatted currency amount.
	internal static func formatted(amount: Int64, currencyCode: String, localeIdentifier: String? = nil) -> String? {
		let decimalAmount = decimalAmount(amount, currencyCode: currencyCode, localeIdentifier: localeIdentifier)

		return currencyFormatter(currencyCode: currencyCode, localeIdentifier: localeIdentifier).string(from: decimalAmount)
	}

	/// Converts an amount in minor currency unit to a decimal amount in major currency units.
	///
	/// - Parameters:
	///   - amount: `Int` object, amount in decimals.
	///   - currencyCode: `String` object, currency.
	///   - localeIdentifier: `String?` object, locale identifier.
	internal static func decimalAmount(_ amount: Int64, currencyCode: String, localeIdentifier: String? = nil) -> NSDecimalNumber {
			let defaultFormatter = currencyFormatter(currencyCode: currencyCode, localeIdentifier: localeIdentifier)
			let maximumFractionDigits = maxFractionDigits(for: currencyCode, localeIdentifier: localeIdentifier)
			defaultFormatter.maximumFractionDigits = maximumFractionDigits

			let decimalMinorAmount = NSDecimalNumber(value: amount)
			return decimalMinorAmount.multiplying(byPowerOf10: Int16(-maximumFractionDigits))
	}

	/// Max fraction digits.
	/// - Parameters:
	///   - currencyCode: `String` object, currency.
	///   - localeIdentifier: `String?` object, locale identifier.
	/// - Returns: Maximum fraction digits.
	internal static func maxFractionDigits(for currencyCode: String, localeIdentifier: String?) -> Int {

		//  https://en.wikipedia.org/wiki/ISO_4217
		switch currencyCode {
		case "MRO":
			return 1
		case "RSD":
			return 2
		case "CVE":
			return 0
		case "GHC":
			return 0
		default:
			let formatter = currencyFormatter(currencyCode: currencyCode, localeIdentifier: localeIdentifier)
			return formatter.maximumFractionDigits
		}
	}

	/// Currency formatter.
	/// - Parameters:
	///   - currencyCode: `String` object, currency.
	///   - localeIdentifier: `String?` object, locale identifier.
	/// - Returns: `NumberFormatter` object.
	private static func currencyFormatter(currencyCode: String, localeIdentifier: String?) -> NumberFormatter {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.currencyCode = currencyCode
		if let localeIdentifier = localeIdentifier {
			formatter.locale = Locale(identifier: localeIdentifier)
		}
		return formatter
	}
}
