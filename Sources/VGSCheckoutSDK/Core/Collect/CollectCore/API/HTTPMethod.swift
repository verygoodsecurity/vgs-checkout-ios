//
//  HTTPMethod.swift
//  VGSCheckoutSDK
//
//  Created on 16.02.2021.
//  Copyright © 2021 VGS. All rights reserved.
//

import Foundation

/// Key-value data type, usually used for response format.
internal typealias JsonData = [String: Any]

/// Key-value data type, used in http request headers.
internal typealias HTTPHeaders = [String: String]

/// Key-value data type, for internal use.
internal typealias BodyData = [String: Any]

/// HTTP request methods
internal enum HTTPMethod: String {
		/// GET method.
		case get     = "GET"
		/// POST method.
		case post    = "POST"
		/// PUT method.
		case put     = "PUT"
		/// PATCH method.
		case patch = "PATCH"
		/// DELETE method.
		case delete = "DELETE"
}
