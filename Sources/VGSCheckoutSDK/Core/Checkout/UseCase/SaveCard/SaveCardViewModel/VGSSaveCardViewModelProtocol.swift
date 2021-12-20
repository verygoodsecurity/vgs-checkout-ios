//
//  VGSSaveCardViewModelProtocol.swift
//  VGSCheckoutSDK

import Foundation

internal protocol VGSSaveCardViewModelProtocol: AnyObject {
	var apiWorker: VGSSaveCardAPIWorkerProtocol {get}
	var submitButtonTitle: String { get }
	var rootNavigationTitle: String { get }
}
