//
//  VGSFormItemsManager.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds utils for managing form items.
internal class VGSFormItemsManager {

	/// Form items.
	internal let formItems: [VGSTextFieldFormItemProtocol]

	/// Initializer.
	/// - Parameters:
	///   - formItems: `[VGSTextFieldFormItemProtocol]` object, an array of `VGSTextFieldFormItemProtocol` items.
	internal init(formItems: [VGSTextFieldFormItemProtocol]) {
		self.formItems = formItems
	}

	/// Form item containing current textField.
	/// - Parameter textField: `VGSTextField` object,
	/// - Returns: `VGSTextFieldFormItemProtocol?` object.
	internal func fieldFormItem(for textField: VGSTextField) -> VGSTextFieldFormItemProtocol? {
		return formItems.first(where: {$0.textField === textField})
	}

	/// All text fields.
	internal var vgsTextFields: [VGSTextField] {
		return formItems.map({return $0.textField})
	}

	/// All form blocks.
	internal var formBlocks: [VGSAddCardFormBlock] {
		return Array(Set(formItems.map({return $0.fieldType.formBlock})))
	}
}