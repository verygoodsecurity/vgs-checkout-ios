//
//  VGSFieldViewsManager.swift
//  VGSCheckoutSDK

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds utils for managing form items.
internal class VGSFieldViewsManager {

	/// Form items.
	private (set) internal var fieldViews: [VGSTextFieldViewProtocol]

	/// Initializer.
	/// - Parameters:
	///   - fieldViews: `[VGSTextFieldViewProtocol]` object, an array of `VGSTextFieldViewProtocol` items.
	internal init(fieldViews: [VGSTextFieldViewProtocol]) {
		self.fieldViews = fieldViews
	}

	/// Form item containing current textField.
	/// - Parameter textField: `VGSTextField` object,
	/// - Returns: `VGSTextFieldViewProtocol?` object.
	internal func fieldView(with textField: VGSTextField) -> VGSTextFieldViewProtocol? {
		return fieldViews.first(where: {$0.textField === textField})
	}

	/// All text fields.
	internal var vgsTextFields: [VGSTextField] {
		return fieldViews.map({return $0.textField})
	}

	/// Append form items.
	/// - Parameter items: `[VGSTextFieldViewProtocol]` object, array of form items.
	internal func appendFieldViews(_ views: [VGSTextFieldViewProtocol]) {
		fieldViews = fieldViews + views
	}

	/// Removes field view from validation manager.
	/// - Parameter fieldView: `VGSTextFieldViewProtocol` object, field to remove.
	internal func removeFieldView(_ fieldView: VGSTextFieldViewProtocol) {
		fieldViews = fieldViews.filter({$0 !== fieldView})
	}
}
