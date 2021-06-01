//
//  CheckoutBasicFlowVC.swift
//  VGSCheckoutDemoApp
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCheckout

class CheckoutBasicFlowVC: UIViewController {

	// MARK: - Vars

	/// Checkout instance.
	fileprivate var vgsCheckout: VGSCheckout?

	/// Main view.
	fileprivate lazy var mainView: CheckoutFlowMainView = {
		let view = CheckoutFlowMainView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(mainView)
		mainView.checkoutDemo_constraintViewToSuperviewEdges()
		mainView.delegate = self

		displayShoppingCartData()
		setupCheckout()
	}

	// MARK: - Helpers

	/// Load orders data.
	private func displayShoppingCartData() {
		let items = OrderDataProvider.provideOrders()
		mainView.shoppingCartView.configure(with: items)
	}

	/// Setup VGS Checkout configuration.
	private func setupCheckout() {
		var checkoutVaultConfiguration = VGSCheckoutVaultConfiguration(vaultID: DemoAppConfiguration.shared.vaultId, environment: DemoAppConfiguration.shared.environment, path: "post")

		var cardDetailsOptions = VGSCheckoutCardDetailsOptions()
		cardDetailsOptions.cardHolderNameFieldType = .single("cardHolder_name")

		cardDetailsOptions.cardNumberFieldName = "card_number"
		cardDetailsOptions.expirationDateFieldName = "card_expirationDate"
		cardDetailsOptions.cvcFieldName = "card_cvc"

		checkoutVaultConfiguration.cardDetailsOptions = cardDetailsOptions

		vgsCheckout = VGSCheckout(configuration: checkoutVaultConfiguration)
	}
}

// MARK: - CheckoutFlowMainViewDelegate

extension CheckoutBasicFlowVC: CheckoutFlowMainViewDelegate {
	func checkoutButtonDidTap(in view: CheckoutFlowMainView) {
		vgsCheckout?.present(from: self, animated: true)
	}
}
