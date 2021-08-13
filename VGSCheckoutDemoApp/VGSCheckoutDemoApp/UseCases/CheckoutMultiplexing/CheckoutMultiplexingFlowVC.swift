//
//  CheckoutMultiplexingFlowVC.swift
//  VGSCheckoutDemoApp

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCheckout
import SVProgressHUD

class CheckoutMultiplexingFlowVC: UIViewController {

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

extension CheckoutMultiplexingFlowVC: CheckoutFlowMainViewDelegate {

	func checkoutButtonDidTap(in view: CheckoutFlowMainView) {

		// Start progress hud animation until token is fetched.
		SVProgressHUD.show()

		// Use your own backend to fetch access_token token.
		var request = URLRequest(url: URL(string:  DemoAppConfiguration.shared.multiplexingServicePath)!)
		request.httpMethod = "POST"
		let task = URLSession.shared.dataTask(
				with: request,
				completionHandler: { [weak self] (data, response, error) in
						guard let data = data,
								let json = try? JSONSerialization.jsonObject(with: data, options: [])
										as? [String: Any],
								let token = json["access_token"] as? String else {
								// Handle error

							DispatchQueue.main.async {[weak self] in
								SVProgressHUD.showError(withStatus: "Cannot fetch multiplexing token!")
							}

							return
						}

					let multipexingToken = token
					DispatchQueue.main.async {[weak self] in
						print("access_token: \(token)")
						SVProgressHUD.dismiss()
						guard let strongSelf = self else {return}

						// Create multiplexing configuration with token.
						let multiplexingConfiguration = VGSCheckoutMultiplexingConfiguration(vaultID: DemoAppConfiguration.shared.multiplexingVaultId, token: multipexingToken, environment: DemoAppConfiguration.shared.environment)

						// Init Checkout with vaultID associated with your multiplexing configuration.
						strongSelf.vgsCheckout = VGSCheckout(configuration: multiplexingConfiguration)

						// Present checkout configuration.
						strongSelf.vgsCheckout?.present(from: strongSelf)

						strongSelf.vgsCheckout?.delegate = strongSelf
					}

				})
		task.resume()
	}
}

// MARK: - VGSCheckoutDelegate

extension CheckoutMultiplexingFlowVC: VGSCheckoutDelegate {

	func checkoutDidCancel() {

		let alert = UIAlertController(title: "Checkout Multiplexing status: .cancelled", message: "User cancelled checkout.", preferredStyle: UIAlertController.Style.alert)

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
			title = "Checkout Multiplexing status: Success!"
			message = "status code is: \(statusCode)"
			let text = DemoAppResponseParser.stringifySuccessResponse(from: data, rootJsonKey: "data") ?? ""
			mainView.responseTextView.isHidden = false
			mainView.responseTextView.text = text
		case .failure(let statusCode, let data, let response, let error):
			title = "Checkout Multiplexing status: Failed!"
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
