//
//  VGSCheckoutSDKRequestResult.swift
//  VGSCheckoutSDK

import Foundation

/// Checkout addtional info in `VGSCheckoutRequestResult`.
public protocol VGSCheckoutInfo {}

/// Basic Checkout addtional info.
internal protocol VGSCheckoutBasicExtraData {}

/// Response enum cases for SDK requests.
@frozen public enum VGSCheckoutRequestResult {
		/**
		 Success response case

		 - Parameters:
				- code: response status code.
				- data: response **data** object.
				- response: URLResponse object represents a URL load response.
				- info: `VGSCheckoutInfo?`, addtional info in `VGSCheckoutRequestResult`.
		*/
		case success(_ code: Int, _ data: Data?, _ response: URLResponse?, _ info: VGSCheckoutInfo? = nil)

		/**
		 Failed response case

		 - Parameters:
				- code: response status code.
				- data: response **Data** object.
				- response: `URLResponse` object represents a URL load response.
				- error: `Error` object.
				- info: `VGSCheckoutInfo?`, addtional info in `VGSCheckoutRequestResult`.
		*/
		case failure(_ code: Int, _ data: Data?, _ response: URLResponse?, _ error: Error?, _ info: VGSCheckoutInfo? = nil)
}
