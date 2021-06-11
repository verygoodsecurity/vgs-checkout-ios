//
//  VGSAddCardUseCaseManager.swift
//  VGSCheckout

import Foundation
#if os(iOS)
import UIKit
#endif
import VGSCollectSDK


public enum VGSAddCardFlowVaultState {
	case success(_ data: Data)
	case failed
	case cancelled
}

public enum VGSAddCardFlowMultiplexingState {
	case success
	case failed
	case cancelled
}

public enum VGSCheckoutAddCardState {
	case vault(_ state: VGSAddCardFlowVaultState)
	case multiplexing(case: VGSAddCardFlowMultiplexingState)
}

internal protocol VGSAddCardUseCaseManagerDelegate: AnyObject {
	func addCardFlowDidChange(with state: VGSCheckoutAddCardState)
}

/// Handle add card form logic.
internal class VGSAddCardUseCaseManager: NSObject {

	internal weak var delegate: VGSAddCardUseCaseManagerDelegate?

	enum FormState {
		case invalid
		case valid
		case processing
	}

	var state = FormState.invalid {
		didSet {
			switch state {
			case .invalid:
				addCardSectionFormView.payButton.status = .disabled
			case .valid:
				addCardSectionFormView.payButton.status = .enabled
			case .processing:
				addCardSectionFormView.payButton.status = .processing
			}
		}
	}

	/// Payment instrument.
	internal let paymentInstrument: VGSPaymentInstrument

	/// Manager for card data logic.
	internal let cardDataSectionManager: VGSCardDataSectionManager

	/// Add card main view.
	internal let addCardSectionFormView: VGSAddCardSectionFormView

	/// `VGSCollect` object.
	internal let vgsCollect: VGSCollect

	// MARK: - Initialization

	init(paymentInstrument: VGSPaymentInstrument, vgsCollect: VGSCollect) {
		self.paymentInstrument = paymentInstrument
		self.vgsCollect = vgsCollect
		self.cardDataSectionManager = VGSCardDataSectionManager(paymentInstrument: paymentInstrument, vgsCollect: vgsCollect, validationBehavior: .onFocus)
		self.addCardSectionFormView = VGSAddCardSectionFormView(paymentInstrument: paymentInstrument, cardDetailsView: cardDataSectionManager.cardFormView, viewLayoutStyle: .fullScreen)
		super.init()
		self.addCardSectionFormView.payButton.status = .enabled
	}

	internal func buildCheckoutViewController() -> UIViewController {

		addCardSectionFormView.headerBarView.delegate = self
		let viewController = VGSFormViewController(formView: addCardSectionFormView)

		addCardSectionFormView.payButton.addTarget(self, action: #selector(payDidTap), for: .touchUpInside)
		cardDataSectionManager.delegate = self

		return viewController
	}

	// MARK: - Helpers

	@objc fileprivate func payDidTap() {
		addCardSectionFormView.payButton.status = .processing
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			self.addCardSectionFormView.payButton.status = .success
		}
	}
}

// MARK: - VGSHeaderBarViewDelegate

extension VGSAddCardUseCaseManager: VGSHeaderBarViewDelegate {
	func buttonDidTap(in header: VGSHeaderBarView) {
		switch paymentInstrument {
		case .vault:
			delegate?.addCardFlowDidChange(with: .vault(.cancelled))
		default:
			break
		}
	}
}

// MARK: - VGSFormItemControllerDelegate

extension VGSAddCardUseCaseManager: VGSFormSectionPresenterDelegate {
	func stateDidChange(_ state: VGSFormSectionState) {
		switch state {
		case .invalid:
			addCardSectionFormView.payButton.status = .disabled
		case .valid:
			addCardSectionFormView.payButton.status = .enabled
		}
	}
}
