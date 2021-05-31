//
//  VGSCardFormItemManager.swift
//  VGSCheckout
//

import Foundation
import UIKit
import VGSCollectSDK

/// Holds logic for card form setup and handling events.
final internal class VGSCardFormItemController {

	/// Card view.
	internal lazy var cardFormView: VGSCheckoutCardFormView = {
		let view = VGSCheckoutCardFormView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	/// Configuration type.
	internal let configurationType: VGSPaymentFlowConfigurationType

	// MARK: - Initialization

	init(configurationType: VGSPaymentFlowConfigurationType) {
		self.configurationType = configurationType
	}

	// MARK: - Interface

	internal func buildForm() {
		cardFormView.cardNumberComponentView.cardTextField.
	}
}
