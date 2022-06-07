//
//  CheckoutTransfersVC.swift
//  VGSCheckoutDemoApp
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCheckoutSDK
import SVProgressHUD

// swiftlint:disable all

/*
 Payment orchestration transfers flow use case demo.

 Step 1: Setup your custom backend for payment orchestration.
 Step 2: Send request to your backend to create an order and get order_id.
 Step 3: Send request to your backend and fetch access token required for payment orchestration flow.
 Step 4: Create `VGSCheckoutPaymentConfiguration` with access token and order_id.
 Step 5: Implement `VGSCheckoutDelegate` protocol to get notified when checkout flow will be finished.
 Step 6: Implement `checkoutTransferDidFinish` method and parse response for required data.
*/
class CheckoutTransfersVC: UIViewController {

	// MARK: - Vars

	/// Checkout instance.
	fileprivate var vgsCheckout: VGSCheckout?

	/// Sends request to your custom backend required for payment orchestration setup.
	fileprivate let paymentOrchestrationAPIClient = PaymentOrchestrationCustomBackendAPIClient()

	/// Order ID to start checkout flow.
	fileprivate var orderId: String?

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
		mainView.button.setTitle("CREATE ORDER", for: .normal)

		displayShoppingCartData()
	}

	// MARK: - Helpers

	/// Loads orders data.
	private func displayShoppingCartData() {
		let items = OrderDataProvider.provideOrders()
		mainView.shoppingCartView.configure(with: items)
	}
}

// MARK: - CheckoutFlowMainViewDelegate

extension CheckoutTransfersVC: CheckoutFlowMainViewDelegate {

	func checkoutButtonDidTap(in view: CheckoutFlowMainView) {

		// Create order.
		guard let newOrderId = orderId else {
			// Start progress hud animation until token is fetched.
			SVProgressHUD.show()
			paymentOrchestrationAPIClient.createOrder(with: "5300", currency: "USD") {[weak self] createdOrderId in
				guard let strongSelf = self else {return}
				SVProgressHUD.dismiss()
				strongSelf.orderId = createdOrderId

				// Fetch token.
				strongSelf.paymentOrchestrationAPIClient.fetchToken {[weak self]  token in

					// Uncomment the line below to simulate 401 error and set invalid token to payment orchestration.
					// let invalidToken = "Some invalid token"
					guard let strongSelf = self else {return}
					var options = VGSCheckoutPaymentOptions()
					options.methods = .savedCards([""])

					VGSCheckoutPaymentConfiguration.createConfiguration(accessToken: token, orderId: createdOrderId, tenantId: DemoAppConfiguration.shared.paymentOrchestrationTenantId, environment: DemoAppConfiguration.shared.environment, options: nil) { configuration in

						strongSelf.vgsCheckout = VGSCheckout(configuration: configuration)

						strongSelf.vgsCheckout?.delegate = strongSelf

						SVProgressHUD.dismiss()
						
						// Present checkout configuration.
						strongSelf.vgsCheckout?.present(from: strongSelf)

						print("Start checkout with payment configuration!")
					} failure: { error in
						SVProgressHUD.showError(withStatus: "Cannot create checkout configuration! Error: \(error)")
					}
				} failure: { errorText in
					SVProgressHUD.showError(withStatus: "Cannot fetch payment orchestration token!")
				}
				return

			} failure: { errorMessage in
				SVProgressHUD.showError(withStatus: "Cannot create orderId!")
			}
			return
		}
	}
}

// MARK: - VGSCheckoutDelegate

extension CheckoutTransfersVC: VGSCheckoutDelegate {

	func checkoutDidCancel() {
		CheckoutDemoDialogHelper.presentAlertDialog(with: "Checkout Payment configuration status: .cancelled", message: "User cancelled checkout.", okActionTitle: "Ok", in: self, completion: nil)
	}

	func checkoutTransferDidCreateNewCard(with newCardInfo: VGSCheckoutNewPaymentCardInfo, result: VGSCheckoutRequestResult) {
		switch result {
		case .success(let statusCode, let data, let response, let info):
			if let id = paymentOrchestrationAPIClient.financialInstrumentID(from: data) {
				print("Fin instrument id is: \(id)")
			}
			print("New card info: \(newCardInfo)")
		case .failure(let statusCode, _, _, let error, let info):
			print("Failed to create fin instrument id: \(error?.localizedDescription)")
		}
	}

	func checkoutTransferDidFinish(with requestResult: VGSCheckoutRequestResult) {

		var title = ""
		var message = ""

		switch requestResult {
		case .success(let statusCode, let data, _, _):
			title = "Checkout Payment configuration status: Payment Success!"
			let text = DemoAppResponseParser.stringifySuccessResponse(from: data, rootJsonKey: "data") ?? ""
			mainView.responseTextView.isHidden = false
			mainView.responseTextView.text = text

		case .failure(let statusCode, _, _, let error, _):
			title = "Checkout Multiplexing status: Failed!"
			message = "status code is: \(statusCode) error: \(error?.localizedDescription ?? "Uknown error!")"

			// If not authorized - suggest user to retry and refetch token.
			if statusCode == 401 {
				CheckoutDemoDialogHelper.displayRetryDialog(with: "Error", message: "Session has been expired. Payment orchestration token is invalid", in: self) {
					SVProgressHUD.show()
					self.paymentOrchestrationAPIClient.fetchToken { token in
						SVProgressHUD.dismiss()
					} failure: { _ in
						SVProgressHUD.showError(withStatus: "Cannot fetch payment orchestration token!")
					}
				}
				return
			}
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

// swiftlint:enable all
