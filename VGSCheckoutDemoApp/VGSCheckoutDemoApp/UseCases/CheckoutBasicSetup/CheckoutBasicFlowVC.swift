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

	}
}

// MARK: - CheckoutFlowMainViewDelegate

extension CheckoutBasicFlowVC: CheckoutFlowMainViewDelegate {
	func checkoutButtonDidTap(in view: CheckoutFlowMainView) {
		// Init Checkout with vault and ID.
		vgsCheckout = VGSCheckout(vaultID: DemoAppConfiguration.shared.vaultId, environment: DemoAppConfiguration.shared.environment)

		// Create vault configuration.
		var checkoutVaultConfiguration = VGSCheckoutVaultConfiguration()
//		checkoutVaultConfiguration.formConfiguration =
//			VGSCheckoutFormConfiguration(fieldnames: "card_numner", expDate: "exp_date", cvc: "cvc", cardholderFieldNameType: .single("cardholder_name"))

		checkoutVaultConfiguration.cardNumberField.fieldName = "card_number"
		checkoutVaultConfiguration.expirationDateField.fieldName = "exp_data"
		checkoutVaultConfiguration.cardHolderField.filedNameStyle = .single("first")

		// Create card details.
//		var cardDetailsOptions = VGSCheckoutCardDetailsOptions()
//		cardDetailsOptions.cardHolderNameFieldType = .single("cardHolder_name")
//
//		cardDetailsOptions.cardNumberFieldName = "card_number"
//		cardDetailsOptions.expirationDateFieldName = "card_expirationDate"
//		cardDetailsOptions.cvcFieldName = "card_cvc"
//
//		checkoutVaultConfiguration.cardDetailsOptions = cardDetailsOptions
//
//		// Present checkout configuration.
//		vgsCheckout?.present(with: checkoutVaultConfiguration, from: self)
	}
}
