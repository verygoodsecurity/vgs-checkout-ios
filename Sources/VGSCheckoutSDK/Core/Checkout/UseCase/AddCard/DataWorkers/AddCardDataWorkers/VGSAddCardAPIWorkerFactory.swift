//
//  VGSAddCardAPIWorkerFactory.swift
//  VGSCheckoutSDK

import Foundation

/// Factory class providers API workers for Add Card flow.
internal class VGSAddCardAPIWorkerFactory {
	static func buildAPIWorker(for paymentInstrument: VGSPaymentInstrument, vgsCollect: VGSCollect) -> VGSAddCreditCardAPIWorkerProtocol {
		switch paymentInstrument {
		case .vault(let configuration):
			return VGSAddCreditCardVaultAPIWorker(vgsCollect: vgsCollect, vaultConfiguration: configuration)
		case .paymentOrchestration(let multiplexingConfiguration):
			return VGSAddCreditCardMultiplexingAPIWorker(vgsCollect: vgsCollect, multiplexingConfiguration: multiplexingConfiguration)
		}
	}
}
