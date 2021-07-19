//
//  VGSFieldViewsManager.swift
//  VGSCheckout

import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Holds utils for managing form items.
internal class VGSFieldViewsManager {

	/// Form items.
	private (set) internal var fieldViews: [VGSTextFieldViewProtocol]

	/// Form section views.
	private (set) internal var formSectionViews: [VGSFormSectionViewProtocol] = []

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

	/// All form blocks.
	internal var sectionBlocks: [VGSAddCardSectionBlock] {
		return Array(Set(fieldViews.map({return $0.fieldType.sectionBlock})))
	}

	/// Append form items.
	/// - Parameter items: `[VGSTextFieldViewProtocol]` object, array of form items.
	internal func appendFieldViews(_ views: [VGSTextFieldViewProtocol]) {
		fieldViews = fieldViews + views
	}

	/// Append form section views.
	/// - Parameter views: `[VGSTextFieldViewProtocol]` object, array of form section views.
	internal func appendFormSectionViews(_ views: [VGSFormSectionViewProtocol]) {
		formSectionViews = formSectionViews + views
	}
}
