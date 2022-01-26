//
//  CheckoutTransfersVC.swift
//  VGSCheckoutDemoApp

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
 Step 2: Send request to your backend to create an order and get order_id from response.
 Step 3: Send request to your backend and get access token required for transfers flow.
 Step 4: Create `VGSCheckoutPaymentConfiguration` with access token and order_id.
 Step 5: Create VGSCheckout with `VGSCheckoutPaymentConfiguration`.
 Step 6: Implement `VGSCheckoutDelegate` protocol to get notified when checkout flow will be finished.
 Step 7: Implement `checkoutDidFinish` method and parse response for required data.
*/
class CheckoutTransfersVC: UIViewController {

	// MARK: - Vars

	/// Checkout instance.
	fileprivate var vgsCheckout: VGSCheckout?

	/// Sends request to your custom backend required for payment orchestration setup.
	fileprivate let customAPIClient = PaymentOrchestrationCustomBackendAPIClient()

	/// Order ID to start checkout flow.
	fileprivate var orderId: String?

	/// Main view.
	fileprivate lazy var mainView: CheckoutFlowMainView = {
		let view = CheckoutFlowMainView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	// MARK: - Lifecycle

	// no:doc
	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(mainView)
		mainView.checkoutDemo_constraintViewToSuperviewEdges()
		mainView.delegate = self
		mainView.button.setTitle("CREATE ORDER", for: .normal)

		displayShoppingCartData()
	}

	// MARK: - Helpers

	/// Load orders data.
	private func displayShoppingCartData() {
		let items = OrderDataProvider.provideOrders()
		mainView.shoppingCartView.configure(with: items)
	}
}

// MARK: - CheckoutFlowMainViewDelegate

extension CheckoutTransfersVC: CheckoutFlowMainViewDelegate {

	func checkoutButtonDidTap(in view: CheckoutFlowMainView) {

		// Create order.
		guard let id = orderId else {
			// Start progress hud animation until token is fetched.
			SVProgressHUD.show()
			customAPIClient.createOrder(with: "5300", currency: "USD") {[weak self] createdOrderId in
				guard let strongSelf = self else {return}
				strongSelf.orderId = createdOrderId
				strongSelf.mainView.responseTextView.isHidden = false
				strongSelf.mainView.responseTextView.text = "Order was created with id: \(createdOrderId) \n\nStarting fetch access token to build VGS Checkout..."

				// Fetch token.
				SVProgressHUD.show()
				strongSelf.customAPIClient.fetchToken {[weak self]  checkoutAccessToken in
					SVProgressHUD.dismiss()

					// Uncomment the line below to simulate 401 error and set invalid token.
					// let invalidToken = "Some invalid token"
					guard let strongSelf = self else {return}

					strongSelf.mainView.responseTextView.text.append("\n\nManaged to fetch access token! Starting checkout with access token: \(checkoutAccessToken)")
					strongSelf.presentCheckout(with: checkoutAccessToken, orderId: createdOrderId)
				} failure: { errorText in
					SVProgressHUD.showError(withStatus: "Cannot fetch access token!")
					strongSelf.mainView.responseTextView.text = ""
				}

			} failure: {errorMessage in
				SVProgressHUD.showError(withStatus: "Cannot create orderId!")
			}
			return
		}


		return
	}

	/// Presents payopt transfers checkout flow.
	/// - Parameter token: `String` object, should be valid access token.
	/// - Parameter orderId: `String` object, should be orderId.
	fileprivate func presentCheckout(with token: String, orderId: String) {

		// Creates payment orchestration payment configuration with access token and order id.
		VGSCheckoutPaymentConfiguration.createConfiguration(accessToken: token, orderId: orderId, tenantId: DemoAppConfiguration.shared.paymentOrchestrationTenantId) {[weak self] configuration in
			guard let strongSelf = self else {return}
			configuration.billingAddressVisibility = .visible
			strongSelf.vgsCheckout = VGSCheckout(configuration: configuration)
			strongSelf.vgsCheckout?.delegate = strongSelf
			// Present checkout configuration.
			strongSelf.vgsCheckout?.present(from: strongSelf)
		} failure: {[weak self] error in
			SVProgressHUD.showError(withStatus: "Cannot create payment config! Error: \(error.localizedDescription)")
		}
	}
}

// MARK: - VGSCheckoutDelegate

extension CheckoutTransfersVC: VGSCheckoutDelegate {

	func checkoutDidCancel() {
		orderId = nil
		mainView.responseTextView.text = ""
		CheckoutDemoDialogHelper.presentAlertDialog(with: "Checkout Payment Configuration status: .cancelled", message: "User cancelled checkout.", okActionTitle: "Ok", in: self, completion: nil)
	}

	func checkoutDidFinish(with requestResult: VGSCheckoutRequestResult) {

		var title = ""
		var message = ""

		switch requestResult {
		case .success(let statusCode, let data, _, _):
			title = "Checkout Payment Configuration status: Payment Success!"
			let text = DemoAppResponseParser.stringifySuccessResponse(from: data, rootJsonKey: "data") ?? ""
			mainView.responseTextView.isHidden = false
			mainView.responseTextView.text = text

		case .failure(let statusCode, _, _, let error, let info):
			if let extraInfo = info {
				if let paymentResultInfo = extraInfo as? VGSCheckoutPaymentResultInfo {
					let paymentMethod = paymentResultInfo.paymentMethod
					switch paymentMethod {
					case .newCard(let newCardInfo):
						print(newCardInfo)
					}
				}
			}
			title = "Checkout status: Failed!"
			message = "status code is: \(statusCode) error: \(error?.localizedDescription ?? "Uknown error!")"

			// If not authorized - suggest user to retry and refetch token.
			if statusCode == 401 {
				if let id = orderId {
					CheckoutDemoDialogHelper.displayRetryDialog(with: "Error", message: "Session has been expired. Access token is invalid", in: self) {
						SVProgressHUD.show()
						self.customAPIClient.fetchToken { token in
							SVProgressHUD.dismiss()
							self.presentCheckout(with: token, orderId: id)
						} failure: { _ in
							SVProgressHUD.showError(withStatus: "Cannot fetch access token!")
						}
					}
					return
				}
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

		orderId = nil
	}

	func saveCardDidSuccess(with data: Data?, response: URLResponse?) {
		let savedCardInfo = DemoAppResponseParser.stringifySuccessResponse(from: data, rootJsonKey: "data") ?? ""
		print("Saved card instrument: \(savedCardInfo)")
	}
}

// swiftlint:enable all
