//
//  VGSAddCardAPIWorkerFactory.swift
//  VGSCheckoutSDK

import Foundation

/// Factory class providers API workers for Add Card flow.
internal class VGSAddCardAPIWorkerFactory {
	static func buildAPIWorker(for checkoutConfigurationType: VGSCheckoutConfigurationType, vgsCollect: VGSCollect) -> VGSSaveCardAPIWorkerProtocol {
		switch checkoutConfigurationType {
		case .custom(let configuration):
			return VGSSaveCardCustomConfigAPIWorker(vgsCollect: vgsCollect, vaultConfiguration: configuration)
		case .payoptAddCard(let configuration):
			return VGSSaveCardPayoptAddCardAPIWorker(vgsCollect: vgsCollect, configuration: configuration)
		case .payoptTransfers:
			fatalError("Invalid flow setup: Payment config is used in add card")
		}
	}
}
