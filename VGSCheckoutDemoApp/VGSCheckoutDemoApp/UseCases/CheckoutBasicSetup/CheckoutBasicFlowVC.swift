//
//  CheckoutBasicFlowVC.swift
//  VGSCheckoutDemoApp
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCheckout
//import VGSPaymentCards

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
		// Create vault configuration.
		var checkoutVaultConfiguration = VGSCheckoutConfiguration()

		checkoutVaultConfiguration.cardHolderFieldOptions.fieldNameType = .single("cardHolder_name")
		checkoutVaultConfiguration.cardNumberFieldOptions.fieldName = "card_number"
		checkoutVaultConfiguration.expirationDateFieldOptions.fieldName = "exp_data"
		checkoutVaultConfiguration.cvcFieldOptions.fieldName = "card_cvc"

		checkoutVaultConfiguration.routeConfiguration.path = "post"

		// Init Checkout with vault and ID.
		vgsCheckout = VGSCheckout(vaultID: DemoAppConfiguration.shared.vaultId, environment: DemoAppConfiguration.shared.environment, configuration: checkoutVaultConfiguration)

		/// Change default valid card number lengthes
//		VGSPaymentCards.visa.cardNumberLengths = [16]
//		/// Change default format pattern
//		VGSPaymentCards.visa.formatPattern = "#### #### #### ####"

		// Present checkout configuration.
		vgsCheckout?.present(from: self)

		vgsCheckout?.delegate = self
	}
}

// MARK: - VGSCheckoutDelegate

extension CheckoutBasicFlowVC: VGSCheckoutDelegate {
	func checkoutDidCancel() {

		let alert = UIAlertController(title: "Checkout status: .cancelled", message: "User cancelled checkout.", preferredStyle: UIAlertController.Style.alert)

		if let popoverController = alert.popoverPresentationController {
			popoverController.sourceView = self.view //to set the source of your alert
			popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
			popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
		}

		alert.addAction(UIAlertAction(title: "OK", style: .default))

		self.present(alert, animated: true, completion: nil)
	}

	func checkoutDidFinish(with requestResult: VGSCheckoutRequestResult) {

		var title = ""
		var message = ""

		switch requestResult {
		case .success(let statusCode, let data, let response):
			title = "Checkout status: Success!"
			message = "status code is: \(statusCode)"
			let text = DemoAppResponseParser.stringifySuccessResponse(from: data) ?? ""
			mainView.responseLabel.isHidden = false
			mainView.responseLabel.text = text
		case .failure(let statusCode, let data, let response, let error):
			title = "Checkout status: Failed!"
			message = "status code is: \(statusCode) error: \(error?.localizedDescription ?? "Uknown error!")"
		}

		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

		alert.addAction(UIAlertAction(title: "OK", style: .default))

		if let popoverController = alert.popoverPresentationController {
			popoverController.sourceView = self.view //to set the source of your alert
			popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
			popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
		}

		self.present(alert, animated: true, completion: nil)
	}
}
