//
//  VGSPaymentOption.swift
//  VGSCheckoutSDK

import Foundation

internal enum VGSPaymentOption {
	case savedCard(_ card: VGSSavedCardModel)
	case newCard
}
