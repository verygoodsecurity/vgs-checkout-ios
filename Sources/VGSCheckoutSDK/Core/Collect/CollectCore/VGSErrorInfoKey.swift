//
//  VGSErrorInfoKey.swift
//  VGSCheckoutSDK
//
//  Created by Dima on 27.02.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation

/// :nodoc: VGSError typealias for error info key.
internal typealias VGSErrorInfoKey = String

/// An error domain string used to produce `VGSError` from `VGSCheckout` -  **"vgscollect.sdk"**
internal let VGSCheckoutErrorDomain = "vgscheckout.sdk"

// MARK: - VGSErrorInfoKeys

// MARK: - Input data errors

/// Error key, used for errors when input data is required to be not empty or to be valid only, but is not valid.
/// - Note:
///    `VGSError` with this  error key can include `VGSSDKErrorInputDataRequired` and `VGSSDKErrorInputDataRequiredValid` error keys in **userInfo** dictionary.
internal let VGSSDKErrorInputDataIsNotValid: VGSErrorInfoKey = "VGSSDKErrorInputDataIsNotValid"

/// Error key, used for errors when input data is required to be not empty but is empty or nil.
internal let VGSSDKErrorInputDataRequired: VGSErrorInfoKey = "VGSSDKErrorInputDataRequired"

/// Error key, used for errors when input data is required to be valid is not valid.
internal let VGSSDKErrorInputDataRequiredValid: VGSErrorInfoKey = "VGSSDKErrorInputDataRequiredValid"

// MARK: - File data errors

/// Error key, used for errors when SDK can't find the file at file path. Can happened when file changes the path or doesn't exist.
internal let VGSSDKErrorFileNotFound: VGSErrorInfoKey = "VGSSDKErrorFileNotFound"

/// Error key, used for errors when file type is not supported by SDK.
internal let VGSSDKErrorFileTypeNotSupported: VGSErrorInfoKey = "VGSSDKErrorFileTypeNotSupported"

/// Error key, used for errors when file size exceeds maximum limit.
internal let VGSSDKErrorFileSizeExceedsTheLimit: VGSErrorInfoKey = "VGSSDKErrorFileSizeExceedsTheLimit"

// MARK: - Source errors

/// Error key, used for errors when SDK can't get access to specific source.
internal let VGSSDKErrorSourceNotAvailable: VGSErrorInfoKey = "VGSSDKErrorSourceNotAvailable"

// MARK: - Response errors
/// Error key, used for errors when response for SDK API request is in format that not supported by SDK.
internal let VGSSDKErrorUnexpectedResponseDataFormat: VGSErrorInfoKey = "VGSSDKErrorUnexpectedResponseDataFormat"
