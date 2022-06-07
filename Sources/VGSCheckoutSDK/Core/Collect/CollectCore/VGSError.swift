//
//  VGSError.swift
//  VGSCheckoutSDK
//
//  Created by Dima on 24.02.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation

/// Type of `VGSError`  and it status code.
internal enum VGSErrorType: Int {
    
    // MARK: - Text input data errors
    
    /// When input data is not valid, but required to be valid
    case inputDataIsNotValid = 1001
    
    // MARK: - Other errors
  
    /// When response type is not supported
    case unexpectedResponseType = 1400
    
    /// When reponse data format is not supported
    case unexpectedResponseDataFormat = 1401

		/// When VGS config URL is not valid.
		case invalidConfigurationURL = 1480

//		/// When payment orchestration JWT token is not valid.
//		case invalidJWTToken = 2000
//
		/// When fin ID not found on Save card request during payment flow.
		case finIdNotFound = 2002

//		/// When order cannot be fetched from pay opt backend.
		case orderIDInfoNotFound = 2003
}

/// An error produced by `VGSCheckout`. Works similar to default `NSError` in iOS.
internal class VGSError: NSError {
    
    /// `VGSErrorType `-  required for each `VGSError` instance
    internal let type: VGSErrorType!
    
    /// Code assiciated with `VGSErrorType`
    override internal var code: Int {
        return type.rawValue
    }

	  ///: nodoc. Public required init.
	internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	/// Initializer.
	/// - Parameters:
	///   - type: `VGSErrorType` object, error type.
	///   - info: `VGSErrorInfo?` object, error info, default is `nil`.
    internal required init(type: VGSErrorType, userInfo info: VGSErrorInfo? = nil) {
        self.type = type
        super.init(domain: VGSCheckoutErrorDomain, code: type.rawValue, userInfo: info?.asDictionary)
    }
}



