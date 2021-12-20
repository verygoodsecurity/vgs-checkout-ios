//
//  VGSCollectHTTPMethod+Exntensions.swift
//  VGSCheckoutSDK

import Foundation

internal extension HTTPMethod {
	init(checkoutHTTPMethod: VGSCheckoutHTTPMethod) {
		switch checkoutHTTPMethod {
		case .post:
			self = .post
		case .put:
			self = .put
		case .patch:
			self = .patch
		case .delete:
			self = .delete
		case .get:
			self = .get
		}
	}
}
