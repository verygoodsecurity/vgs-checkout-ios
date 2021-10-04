//
//  CheckoutMultiplexingFlowVC.swift
//  VGSCheckoutDemoApp

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCheckoutSDK
import SVProgressHUD

// swiftlint:disable all

/// Custom API client for multiplexing.
final class MultiplexingCustomBackendAPIClient {

	/// Succcess completion for token fetch.
	typealias FetchTokenCompletionSuccess = (_ token: String) -> Void

	/// Fail completion for token fetch.
	typealias FetchTokenCompletionFail = (_ errorMessage: String) -> Void

	/// Success completion for transfer request.
	typealias SendTransferCompletionSuccess = () -> Void

	/// Fail completion for transfer request.
	typealias SendTransferCompletionFail = (_ errorMessage: String) -> Void

	// Use your own backend to fetch access_token token.
	fileprivate let yourCustomBackendTokenURL = URL(string:  DemoAppConfiguration.shared.multiplexingServicePath + "/get-auth-token")!

	// Use your own backend to send payment to multiplexing.
	fileprivate let yourCustomBackendSendPaymentURL = URL(string:  DemoAppConfiguration.shared.multiplexingServicePath + "/transfers")!

	/// Fetch multiplexing token from your own backend.
	/// - Parameters:
	///   - success: `FetchTokenCompletionSuccess` object, completion on success request with token.
	///   - failure: `FetchTokenCompletionFail` object, completion on failed request with error message.
	func fetchMultiplexingToken(with success: @escaping FetchTokenCompletionSuccess, failure: @escaping FetchTokenCompletionFail) {

		var request = URLRequest(url: yourCustomBackendTokenURL)
		request.httpMethod = "POST"
		let task = URLSession.shared.dataTask(
				with: request,
				completionHandler: { (data, response, error) in
						guard let data = data,
								let json = try? JSONSerialization.jsonObject(with: data, options: [])
										as? [String: Any],
								let token = json["access_token"] as? String else {
								// Handle error
							DispatchQueue.main.async {
								failure("Cannot fetch token")
							}
							return
						}

					let multipexingToken = token
					print("access_token: \(token)")
					DispatchQueue.main.async {
						success(multipexingToken)
					}
				})
		task.resume()
	}

	/// Initiate transfer request on multiplexing from your custom backend.
	/// - Parameters:
	///   - financialInstrumentID: `String` object, id of financial instrument.
	///   - amount: `String` object, amount of transaction.
	///   - currency: `String` object, currency of transaction.
	///   - success: `SendTransferCompletionSuccess` object, completion on success transfers.
	///   - failure: `SendTransferCompletionFail` object, completion on failed request with error message.
	func initiateTransfer(with financialInstrumentID: String, amount: String, currency: String, success: @escaping SendTransferCompletionSuccess, failure: @escaping FetchTokenCompletionFail) {

		var request = URLRequest(url: yourCustomBackendSendPaymentURL)
		request.httpBody = try? JSONSerialization.data(withJSONObject: [
			"amount": amount,
			"currency": currency,
			"source": financialInstrumentID
		])

		request.httpMethod = "POST"
		let task = URLSession.shared.dataTask(
				with: request,
				completionHandler: {(data, response, error) in
						guard let data = data,
								let json = try? JSONSerialization.jsonObject(with: data, options: [])
										as? [String: Any] else {
								// Handle error
							DispatchQueue.main.async {
								failure("Cannot send payment")
							}
							return
						}
					print("response json: \(json)")
					DispatchQueue.main.async {
						success()
					}
				})
		task.resume()
	}

	/// Financial instrument id from success multiplexing save card response.
	/// - Parameter data: `Data?` object, response data.
	/// - Returns: `String?` object, multiplexing financial instrument id or `nil`.
	func multiplexingFinancialInstrumentID(from data: Data?) -> String? {
		if let data = data, let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
			if let json = jsonData["json"] as? [String: Any] {
				if let dataJSON = json["data"] as? [String: Any] {
					if let financialInstumentID = dataJSON["id"] as? String {
						return financialInstumentID
					}
				}
			}
		}

		return nil
	}
}

/*
 Multiplexing flow use case demo.

 Step 1: Setup your custom backend for multiplexing.
 Step 2: Send request to your backend and fetch access token required for multiplexing flow.
 Step 3: Create `VGSCheckoutMultiplexingConfiguration` with fetched token and present Checkout.
         Implement `VGSCheckoutDelegate` protocol to get notified when checkout flow will be finished.
 Step 4: Implement `checkoutDidFinish` method and parse response to get financial instrument `id` in response json.

 Step 5: Initiate `/transfer` request with financial instrument using your backend by sending request from mobile app.
*/
class CheckoutMultiplexingFlowVC: UIViewController {

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

extension CheckoutMultiplexingFlowVC: CheckoutFlowMainViewDelegate {

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
		multiplexingCustomAPIClient.initiateTransfer(with: id, amount: "", currency: "USD") {
			SVProgressHUD.showSuccess(withStatus: "Successfully finished multiplexing transfer!")
		} failure: { errorMessage in
			SVProgressHUD.showError(withStatus: "Cannot complete transfer!")
		}
	}

	/// Presents multiplexing checkout flow.
	/// - Parameter token: `String` object, should be valid multiplexing token.
	fileprivate func presentMultiplexingCheckout(with token: String) {
		// Create multiplexing configuration with token.
        if let multiplexingConfiguration = VGSCheckoutMultiplexingConfiguration(vaultID: DemoAppConfiguration.shared.multiplexingVaultId, token: token, environment: DemoAppConfiguration.shared.environment) {
            // Init Checkout with vaultID associated with your multiplexing configuration.
            vgsCheckout = VGSCheckout(configuration: multiplexingConfiguration)

            // Present checkout configuration.
            vgsCheckout?.present(from: self)

            vgsCheckout?.delegate = self
        }
	}
}

// MARK: - VGSCheckoutDelegate

extension CheckoutMultiplexingFlowVC: VGSCheckoutDelegate {

	func checkoutDidCancel() {
		CheckoutDemoDialogHelper.presentAlertDialog(with: "Checkout Multiplexing status: .cancelled", message: "User cancelled checkout.", okActionTitle: "Ok", in: self, completion: nil)
	}

	func checkoutDidFinish(with requestResult: VGSCheckoutRequestResult) {

		var title = ""
		var message = ""

		switch requestResult {
		case .success(let statusCode, let data, _):
			title = "Checkout Multiplexing status: Success!"
			let text = DemoAppResponseParser.stringifySuccessResponse(from: data, rootJsonKey: "data") ?? ""
			mainView.responseTextView.isHidden = false
			mainView.responseTextView.text = text

			if let id = multiplexingCustomAPIClient.multiplexingFinancialInstrumentID(from: data) {
				financialInstrumentID = id
				message = "status code is: \(statusCode). Press BUY to send payment!"
				mainView.button.setTitle("BUY", for: .normal)
			} else {
				message = "status code is: \(statusCode). Card was saved successfully but cannot obtain financial id"
			}
		case .failure(let statusCode, _, _, let error):
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
