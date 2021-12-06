//
//  CharacterSet+extension.swift
//  VGSCheckoutSDK
//
//  Created by Dima on 17.12.2019.
//

import Foundation

internal extension CharacterSet {

	  /// :nodoc: Ascii decimal digits set.
    static var vgsAsciiDecimalDigits: CharacterSet {
        return self.init(charactersIn: "0123456789")
    }
}
