//
//  VGSFormComponent.swift
//  VGSCheckout
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

internal enum VGSFormComponentType {
	case card
	case expDate
	case cvc
}

internal protocol VGSFormComponent: UIView {
	var childComponents: [UIView] {get}
}
