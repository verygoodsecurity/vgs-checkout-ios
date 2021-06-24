//
//  CharacterSet+extension.swift
//  VGSCheckout
//
//  Created by Dima on 17.12.2019.
//

import Foundation

extension CharacterSet {

	  /// :nodoc: Ascii decimal digits set.
    internal static var vgsAsciiDecimalDigits: CharacterSet {
        return self.init(charactersIn: "0123456789")
    }
}
