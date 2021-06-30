//
//  VGSFormTextFieldValidationProtocol.swift
//  VGSCheckout

import Foundation

internal protocol VGSFormTextFieldValidationProtocol {
	func isTextFieldInputComplete(_ textField: VGSTextField) -> Bool
}
