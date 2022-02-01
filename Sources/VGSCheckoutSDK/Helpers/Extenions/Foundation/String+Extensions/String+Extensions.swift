//
//  String+Extensions.swift
//  VGSCheckoutSDK

import Foundation

/// no:doc
internal extension String {

	/// Normalized card brand name.
	var normalizedCardBrandName: String {
		return lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
	}
}
