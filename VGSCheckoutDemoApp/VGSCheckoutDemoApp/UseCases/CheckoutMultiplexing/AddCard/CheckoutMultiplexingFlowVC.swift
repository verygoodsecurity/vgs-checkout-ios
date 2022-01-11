//
//  CheckoutMultiplexingAddCardFlowVC.swift
//  VGSCheckoutDemoApp

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCheckoutSDK
import SVProgressHUD

// swiftlint:disable all
/*
 Multiplexing add card flow use case demo.

 Step 1: Setup your custom backend for multiplexing.
 Step 2: Send request to your backend and fetch access token required for multiplexing flow.
 Step 3: Create `VGSCheckoutMultiplexingConfiguration` with fetched token and present Checkout.
				 Implement `VGSCheckoutDelegate` protocol to get notified when checkout flow will be finished.
 Step 4: Implement `checkoutDidFinish` method and parse response to get financial instrument `id` in response json.
 Step 5: Initiate `/transfer` request with financial instrument using your backend by sending request from mobile app.
*/
class CheckoutMultiplexingAddCardFlowVC: UIViewController {

	// MARK: - Vars

	/// Checkout instance.
	fileprivate var vgsCheckout: VGSCheckout?

	/// Sends request to your custom backend required for multiplexing setup.
	fileprivate let multiplexingCustomAPIClient = MultiplexingCustomBackendAPIClient()

	/// ID to start payment transfer.
	fileprivate var financialInstrumentID: String?

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
	}

	// MARK: - Helpers

	/// Load orders data.
	private func displayShoppingCartData() {
		let items = OrderDataProvider.provideOrders()
		mainView.shoppingCartView.configure(with: items)
	}
}

// MARK: - CheckoutFlowMainViewDelegate

extension CheckoutMultiplexingAddCardFlowVC: CheckoutFlowMainViewDelegate {

	func checkoutButtonDidTap(in view: CheckoutFlowMainView) {

		guard let id = financialInstrumentID else {
			// Start progress hud animation until token is fetched.
			SVProgressHUD.show()
			multiplexingCustomAPIClient.fetchMultiplexingToken { token in
				SVProgressHUD.dismiss()

				// Uncomment the line below to simulate 401 error and set invalid token to multiplexing.
				// let invalidToken = "Some invalid token"

				self.presentMultiplexingCheckout(with: token)
			} failure: { errorText in
				SVProgressHUD.showError(withStatus: "Cannot fetch multiplexing token!")
			}
			return
		}

		// Start progress hud animation until payment transfer is finished.
		SVProgressHUD.show()
		multiplexingCustomAPIClient.initiateTransfer(with: id, amount: "53", currency: "USD") { responseText in
			SVProgressHUD.showSuccess(withStatus: "Successfully finished multiplexing transfer!")
			self.mainView.responseTextView.text = responseText
		} failure: { errorMessage in
			SVProgressHUD.showError(withStatus: "Cannot complete transfer!")
		}
	}

	/// Presents multiplexing checkout flow.
	/// - Parameter token: `String` object, should be valid access multiplexing token.
	fileprivate func presentMultiplexingCheckout(with accessToken: String) {
		// Create multiplexing add configuration with access token.
		VGSCheckoutMultiplexingAddCardConfiguration.createConfiguration(accessToken: accessToken, tenantId: DemoAppConfiguration.shared.multiplexingTenantId) {[weak self] configuration in
			guard let strongSelf = self else {return}
			configuration.billingAddressVisibility = .visible
			strongSelf.vgsCheckout = VGSCheckout(configuration: configuration)
			strongSelf.vgsCheckout?.delegate = strongSelf
			// Present checkout configuration.
			strongSelf.vgsCheckout?.present(from: strongSelf)
		} failure: {[weak self] error in
			SVProgressHUD.showError(withStatus: "Cannot create add card multiplexing config! Error: \(error.localizedDescription)")
		}
	}
}

// MARK: - VGSCheckoutDelegate

extension CheckoutMultiplexingAddCardFlowVC: VGSCheckoutDelegate {

	func checkoutDidCancel() {
		CheckoutDemoDialogHelper.presentAlertDialog(with: "Checkout Multiplexing status: .cancelled", message: "User cancelled checkout.", okActionTitle: "Ok", in: self, completion: nil)
	}

	func checkoutDidFinish(with requestResult: VGSCheckoutRequestResult) {

		var title = ""
		var message = ""

		switch requestResult {
		case .success(let statusCode, let data, let response, let info):
			title = "Checkout Multiplexing status: Success!"
			let text = DemoAppResponseParser.stringifySuccessResponse(from: data, rootJsonKey: "data") ?? ""
			mainView.responseTextView.isHidden = false
			mainView.responseTextView.text = text

			if let id = multiplexingCustomAPIClient.multiplexingFinancialInstrumentID(from: data) {
				financialInstrumentID = id
				message = "status code is: \(statusCode). Press BUY to send payment!"
				mainView.button.setTitle("BUY", for: .normal)
			} else {
				message = "status code is: \(statusCode). Card was saved successfully but cannot obtain financial instrument id"
			}
		case .failure(let statusCode, _, _, let error, let info):
			title = "Checkout Multiplexing status: Failed!"
			message = "status code is: \(statusCode) error: \(error?.localizedDescription ?? "Uknown error!")"

			// If not authorized - suggest user to retry and refetch token.
			if statusCode == 401 {
				CheckoutDemoDialogHelper.displayRetryDialog(with: "Error", message: "Session has been expired. Multilexping token is invalid", in: self) {
					SVProgressHUD.show()
					self.multiplexingCustomAPIClient.fetchMultiplexingToken { token in
						SVProgressHUD.dismiss()
						self.presentMultiplexingCheckout(with: token)
					} failure: { _ in
						SVProgressHUD.showError(withStatus: "Cannot fetch multiplexing token!")
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
