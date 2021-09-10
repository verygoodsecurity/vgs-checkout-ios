//
//  String+extension.swift
//  VGSCheckout
//
//  Created by Dima on 10.01.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation

internal extension String {
    var isAlphaNumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
  
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}

internal extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

internal extension String {
	func normalizedHostname() -> String? {

		// Create component.
		guard var component = URLComponents(string: self) else {return nil}

		if component.query != nil {
			// Clear all queries.
			component.query = nil

      let text = "YOUR HOSTNAME HAS QUERIES AND WILL BE NORMALIZED!"
      let event = VGSLogEvent(level: .warning, text: text, severityLevel: .warning)
      VGSCheckoutLogger.shared.forwardLogEvent(event)
		}

		var path: String
		if let componentHost = component.host {
			// Use hostname if component is url with scheme.
			path = componentHost
		} else {
			// Use path if component has path only.
			path = component.path
		}

		return path.removeExtraPath()
	}

	func removeExtraPath() -> String {
		guard let index = range(of: "/")?.upperBound else {
			return removeLastSlash()
		}

		let substring = String(self.prefix(upTo: index))
		return substring.removeLastSlash()
	}

	func removeLastSlash() -> String {
		var path = self
		if hasSuffix("/") {
			path = String(path.dropLast())
		}

		return path
	}
    
    static let checkoutEmptyErrorText = " "
}

/// JWT decoding.
internal extension String {
    
    /// Decode JSON Web  token.
    static func decode(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")

        guard segments.count > 1 else {
            return  [:]
        }
        return decodeJWTPart(segments[1]) ?? [:]
    }

    static func base64UrlDecode(_ value: String) -> Data? {
      var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")

      let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
      let requiredLength = 4 * ceil(length / 4.0)
      let paddingLength = requiredLength - length
      if paddingLength > 0 {
        let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        base64 = base64 + padding
      }
      return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }

    static func decodeJWTPart(_ value: String) -> [String: Any]? {
      guard let bodyData = base64UrlDecode(value),
        let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
          return nil
      }

      return payload
    }
}
