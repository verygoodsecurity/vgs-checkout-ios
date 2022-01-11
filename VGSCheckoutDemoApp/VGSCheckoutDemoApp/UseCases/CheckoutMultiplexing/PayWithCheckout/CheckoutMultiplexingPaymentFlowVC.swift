//
//  CheckoutMultiplexingPaymentFlowVC.swift
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
 Multiplexing payment flow use case demo.

 Step 1: Setup your custom backend for multiplexing.
 Step 2: Send request to your backend to create an order and get order_id from response.
 Step 3: Send request to your backend and get access token required for multiplexing flow.
 Step 4: Create `VGSCheckoutMultiplexingPaymentConfiguration` with multiplexing token and order_id.
 Step 5: Create VGSCheckout with `VGSCheckoutMultiplexingPaymentConfiguration`.
 Step 6: Implement `VGSCheckoutDelegate` protocol to get notified when checkout flow will be finished.
 Step 7: Implement `checkoutDidFinish` method and parse response for required data.
*/
class CheckoutMultiplexingPaymentFlowVC: UIViewController {

	// MARK: - Vars

	/// Checkout instance.
	fileprivate var vgsCheckout: VGSCheckout?

	/// Sends request to your custom backend required for multiplexing setup.
	fileprivate let multiplexingCustomAPIClient = MultiplexingCustomBackendAPIClient()

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

	/// Load orders data.
	private func displayShoppingCartData() {
		let items = OrderDataProvider.provideOrders()
		mainView.shoppingCartView.configure(with: items)
	}
}

// MARK: - CheckoutFlowMainViewDelegate

extension CheckoutMultiplexingPaymentFlowVC: CheckoutFlowMainViewDelegate {

	func checkoutButtonDidTap(in view: CheckoutFlowMainView) {

		// Create order.
		guard let id = orderId else {
			// Start progress hud animation until token is fetched.
			SVProgressHUD.show()
			multiplexingCustomAPIClient.createOrder(with: "5300", currency: "USD") {[weak self] createdOrderId in
				guard let strongSelf = self else {return}
				strongSelf.orderId = createdOrderId
				strongSelf.mainView.responseTextView.isHidden = false
				strongSelf.mainView.responseTextView.text = "Order was created with id: \(createdOrderId) \n\nStarting fetch access token to build VGS Checkout..."

				// Fetch token.
				SVProgressHUD.show()
				strongSelf.multiplexingCustomAPIClient.fetchMultiplexingToken {[weak self]  checkoutAccessToken in
					SVProgressHUD.dismiss()

					// Uncomment the line below to simulate 401 error and set invalid token to multiplexing.
					// let invalidToken = "Some invalid token"
					guard let strongSelf = self else {return}

					strongSelf.mainView.responseTextView.text.append("\n\nManaged to fetch access token! Starting checkout with access token: \(checkoutAccessToken)")
					strongSelf.presentMultiplexingCheckout(with: checkoutAccessToken, orderId: createdOrderId)
				} failure: { errorText in
					SVProgressHUD.showError(withStatus: "Cannot fetch multiplexing token!")
					strongSelf.mainView.responseTextView.text = ""
				}

			} failure: {errorMessage in
				SVProgressHUD.showError(withStatus: "Cannot create orderId!")
			}
			return
		}


		return
	}

	/// Presents multiplexing checkout flow.
	/// - Parameter token: `String` object, should be valid multiplexing token.
	/// - Parameter orderId: `String` object, should be orderId.
	fileprivate func presentMultiplexingCheckout(with token: String, orderId: String) {
		// Create multiplexing payment configuration with access token and order id.
		VGSCheckoutMultiplexingPaymentConfiguration.createConfiguration(accessToken: token, orderId: orderId, tenantId: DemoAppConfiguration.shared.multiplexingTenantId) {[weak self] configuration in
			guard let strongSelf = self else {return}
			configuration.billingAddressVisibility = .visible
			strongSelf.vgsCheckout = VGSCheckout(configuration: configuration)
			strongSelf.vgsCheckout?.delegate = strongSelf
			// Present checkout configuration.
			strongSelf.vgsCheckout?.present(from: strongSelf)
		} failure: {[weak self] error in
			SVProgressHUD.showError(withStatus: "Cannot create add card multiplexing config! Error: \(error.localizedDescription)")
		}

		// Create multiplexing configuration with token.
//		if var multiplexingConfiguration = VGSCheckoutMultiplexingConfiguration(accessToken: token, tenantId: DemoAppConfiguration.shared.multiplexingTenantId, environment: DemoAppConfiguration.shared.environment) {
//
//			  let paymentFlow = VGSCheckoutMultiplexingPaymentFlow(orderId: "ORDER_ID")
//				multiplexingConfiguration.flow = paymentFlow
//			  vgsCheckout = VGSCheckout(configuration: multiplexingConfiguration)
//
//				// Present checkout configuration.
//				vgsCheckout?.present(from: self)
//
//				vgsCheckout?.delegate = self
//			}
	}
}

// MARK: - VGSCheckoutDelegate

extension CheckoutMultiplexingPaymentFlowVC: VGSCheckoutDelegate {

	func checkoutDidCancel() {
		orderId = nil
		mainView.responseTextView.text = ""
		CheckoutDemoDialogHelper.presentAlertDialog(with: "Checkout Multiplexing status: .cancelled", message: "User cancelled checkout.", okActionTitle: "Ok", in: self, completion: nil)
	}

	func checkoutDidFinish(with requestResult: VGSCheckoutRequestResult) {

		var title = ""
		var message = ""

		switch requestResult {
		case .success(let statusCode, let data, _, _):
			title = "Checkout Multiplexing status: Payment Success!"
			let text = DemoAppResponseParser.stringifySuccessResponse(from: data, rootJsonKey: "data") ?? ""
			mainView.responseTextView.isHidden = false
			mainView.responseTextView.text = text

//			if let id = multiplexingCustomAPIClient.multiplexingFinancialInstrumentID(from: data) {
//				financialInstrumentID = id
//				message = "status code is: \(statusCode). Press BUY to send payment!"
//				mainView.button.setTitle("BUY", for: .normal)
//			} else {
//				message = "status code is: \(statusCode). Card was saved successfully but cannot obtain financial instrument id"
//			}
		case .failure(let statusCode, _, _, let error, _):
			title = "Checkout Multiplexing status: Failed!"
			message = "status code is: \(statusCode) error: \(error?.localizedDescription ?? "Uknown error!")"

			// If not authorized - suggest user to retry and refetch token.
			if statusCode == 401 {
				if let id = orderId {
					CheckoutDemoDialogHelper.displayRetryDialog(with: "Error", message: "Session has been expired. Multilexping token is invalid", in: self) {
						SVProgressHUD.show()
						self.multiplexingCustomAPIClient.fetchMultiplexingToken { token in
							SVProgressHUD.dismiss()
							self.presentMultiplexingCheckout(with: token, orderId: id)
						} failure: { _ in
							SVProgressHUD.showError(withStatus: "Cannot fetch multiplexing token!")
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
}

// swiftlint:enable all
