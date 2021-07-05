//
//  VGSFormTextFieldValidationProtocol.swift
//  VGSCheckout

import Foundation

internal protocol VGSFormTextFieldValidationProtocol {
	func isTextFieldInputComplete(_ textField: VGSTextField) -> Bool
	func errorMessage(for textField: VGSTextField, fieldType: VGSAddCardFormFieldType) -> String?
}

internal extension VGSFormTextFieldValidationProtocol {
	func errorMessage(for textField: VGSTextField, fieldType: VGSAddCardFormFieldType) -> String? {return nil}
}
