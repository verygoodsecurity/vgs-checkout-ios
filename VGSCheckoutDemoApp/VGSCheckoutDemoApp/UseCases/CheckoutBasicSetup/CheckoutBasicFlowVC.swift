//
//  CheckoutBasicFlowVC.swift
//  VGSCheckoutDemoApp
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import VGSCheckoutSDK

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

		setupIdentifiers()
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

	/// Setup identifiers.
	private func setupIdentifiers() {
		view.accessibilityIdentifier = "VGSDemoApp.Screens.CustomConfigFlow"
		mainView.button.accessibilityIdentifier = "VGSDemoApp.Screens.CustomConfigFlow.SaveCardButton"
	}

	/// Setup VGS Checkout configuration.
	private func setupCheckout() {

	}
}

// MARK: - CheckoutFlowMainViewDelegate

extension CheckoutBasicFlowVC: CheckoutFlowMainViewDelegate {

	func checkoutButtonDidTap(in view: CheckoutFlowMainView) {
		// Create custom configuration.
		var checkoutConfiguration = VGSCheckoutCustomConfiguration(vaultID: DemoAppConfiguration.shared.vaultId, environment: DemoAppConfiguration.shared.environment)

		checkoutConfiguration.cardHolderFieldOptions.fieldNameType = .single("cardHolder_name")
		checkoutConfiguration.cardNumberFieldOptions.fieldName = "card_number"
		checkoutConfiguration.expirationDateFieldOptions.fieldName = "exp_data"
		checkoutConfiguration.cvcFieldOptions.fieldName = "card_cvc"

		checkoutConfiguration.billingAddressVisibility = .visible
        
		checkoutConfiguration.billingAddressCountryFieldOptions.fieldName = "billing_address.country"
		checkoutConfiguration.billingAddressCityFieldOptions.fieldName = "billing_address.city"
		checkoutConfiguration.billingAddressLine1FieldOptions.fieldName = "billing_address.addressLine1"
		checkoutConfiguration.billingAddressLine2FieldOptions.fieldName = "billing_address.addressLine2"
		checkoutConfiguration.billingAddressPostalCodeFieldOptions.fieldName = "billing_address.postal_code"

		// Produce nested json for fields with `.` notation.
		checkoutConfiguration.routeConfiguration.requestOptions.mergePolicy = .nestedJSON

		checkoutConfiguration.routeConfiguration.path = "post"

		// Update configuration for UITests cases.
		UITestsConfigurationManager.updateCustomCheckoutConfigurationForUITests(&checkoutConfiguration)

		/* Set custom date user input/output JSON format.

		checkoutConfiguration.expirationDateFieldOptions.inputDateFormat = .shortYearThenMonth
		checkoutConfiguration.expirationDateFieldOptions.outputDateFormat = .longYearThenMonth

		let expDateSerializer = VGSCheckoutExpDateSeparateSerializer(monthFieldName: "card_date.month", yearFieldName: "card_date.year")
		checkoutConfiguration.expirationDateFieldOptions.serializers = [expDateSerializer]
		*/

		// Init Checkout with vault and ID.
		vgsCheckout = VGSCheckout(configuration: checkoutConfiguration)

		//VGSPaymentCards.visa.formatPattern = "#### #### #### ####"

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
		case .success(let statusCode, let data, let response, let info):
			title = "Checkout status: Success!"
			message = "status code is: \(statusCode)"
			let text = DemoAppResponseParser.stringifySuccessResponse(from: data) ?? ""
			mainView.responseTextView.isHidden = false
			mainView.responseTextView.text = text
		case .failure(let statusCode, let data, let response, let error, let info):
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
