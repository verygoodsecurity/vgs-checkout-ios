//
//  VGSCheckoutSDKFormatSerializerProtocol.swift
//  VGSCheckoutSDK
//
//  Created by Dima on 25.03.2021.
//  Copyright © 2021 VGS. All rights reserved.
//

import Foundation

///:nodoc: Base protocol describing Content Serialization attributes
public protocol VGSCheckoutFormatSerializerProtocol {

}

/// Base protocol describing functionality for Content Serialization
internal protocol VGSCheckoutFormatSerializableProtocol {
  func serialize(_ content: String) -> [String: Any]
  var shouldSerialize: Bool { get }
}
