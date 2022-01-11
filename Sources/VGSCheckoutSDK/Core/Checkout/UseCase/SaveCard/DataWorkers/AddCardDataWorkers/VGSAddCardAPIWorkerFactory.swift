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
		case .multiplexingAddCard(let multiplexingConfiguration):
			return VGSSaveCardMultiplexingConfigAPIWorker(vgsCollect: vgsCollect, multiplexingConfiguration: multiplexingConfiguration)
		case .multiplexingPayment:
			fatalError("Invalid flow setup: Payment config is used in add card")
		}
	}
}
