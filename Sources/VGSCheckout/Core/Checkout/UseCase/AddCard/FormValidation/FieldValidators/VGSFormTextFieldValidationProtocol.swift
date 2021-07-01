//
//  VGSFormTextFieldValidationProtocol.swift
//  VGSCheckout

import Foundation

internal protocol VGSFormTextFieldValidationProtocol {
	func isTextFieldInputComplete(_ textField: VGSTextField) -> Bool
	func isTextFieldInputValid(_ textField: VGSTextField) -> Bool
}

internal extension VGSFormTextFieldValidationProtocol {
	func isTextFieldInputValid(_ textField: VGSTextField) -> Bool {return true}
}
