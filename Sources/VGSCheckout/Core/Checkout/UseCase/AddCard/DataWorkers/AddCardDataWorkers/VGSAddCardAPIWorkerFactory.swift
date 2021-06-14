//
//  VGSAddCardAPIWorkerFactory.swift
//  VGSCheckout

import Foundation
import VGSCollectSDK

/// Factory class providers API workers for Add Card flow.
internal class VGSAddCardAPIWorkerFactory {
	static func buildAPIWorker(for paymentInstrument: VGSPaymentInstrument, vgsCollect: VGSCollect) -> VGSAddCreditCardAPIWorkerProtocol {
		switch paymentInstrument {
		case .vault(let configuration):
			return VGSAddCreditCardVaultAPIWorker(vgsCollect: vgsCollect, vaultConfiguration: configuration)
		default:
			// TODO: - Add multiplexing here.
			break
		}
	}
}
