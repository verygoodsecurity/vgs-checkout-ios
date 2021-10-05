//
//  VGSCheckoutSaveCardBaseTestCase.swift
//  VGSCheckoutDemoAppUITests

import Foundation
import XCTest

// swiftlint:disable nesting

class VGSCheckoutSaveCardBaseTestCase: VGSCheckoutDemoAppBaseTestCase {

	/// VGSTextFields.
	enum VGSTextField {

		/// Card Details fields.
		enum CardDetails {
			/// Card holder name.
			static let cardHolderName: VGSUITestElement = .init(type: .textField, identifier: "Joe Business")

			/// Card number.
			static let cardNumber: VGSUITestElement = .init(type: .textField, identifier: "4111 1111 1111 1111")

			/// Expiration date.
			static let expirationDate: VGSUITestElement = .init(type: .textField, identifier: "MM/YY")

			/// CVC.
			static let cvc: VGSUITestElement = .init(type: .secureTextField, identifier: "3 digits")
		}

		/// Billing address fields.
		enum BillingAddress {
			/// Country. Default value is `US`.
			static let country: VGSUITestElement = .init(type: .textField, identifier: "United States")

			/// Address line 1.
			static let addressLine1: VGSUITestElement = .init(type: .textField, identifier: "Address line 1")

			/// Address line 2.
			static let addressLine2: VGSUITestElement = .init(type: .textField, identifier: "Address line 2 (Optional)")

			/// City.
			static let city: VGSUITestElement = .init(type: .textField, identifier: "City")

			/// Zip code.
			static let zip: VGSUITestElement = .init(type: .textField, identifier: "12345")

			/// Postal code.
			static let postalCode: VGSUITestElement = .init(type: .textField, identifier: "Postal code")
		}
	}

	/// Screens.
	enum Screens {
		/// Custom config view.
		static let customFlow: VGSUITestElement = .init(type: .other, identifier: "VGSDemoApp.Screens.CustomConfigFlow")
	}

	/// Buttons.
	enum Buttons {
		/// Save card button on demo screen.
		static let startCheckout: VGSUITestElement = .init(type: .button, identifier: "VGSDemoApp.Screens.CustomConfigFlow.SaveCardButton")

		/// Save card button (custom `UIControl`) in checkout.
		static let checkoutSaveCard: VGSUITestElement = .init(type: .label, identifier: "Save Card")
	}

	/// Labels.
	enum Labels {

		/// Checkout section titles.
		enum CheckoutSectionTitles {
			/// Card details.
			static let cardDetails: VGSUITestElement = .init(type: .label, identifier: "Card Details")

			/// Billing address.
			static let billingAddress: VGSUITestElement = .init(type: .label, identifier: "Billing Address")
		}

		/// Alert success title.
		static let alertSuccessTitle = "Checkout status: Success!"

		/// Checkout error labels.
		enum CheckoutErrorLabels {

			/// Card details.
			enum CardDetails {
				/// Invalid card number.
				static let invalidCardNumber: VGSUITestElement = .init(type: .label, identifier: "Invalid card number")

				/// Invalid expiry date.
				static let invalidExpiryDate: VGSUITestElement = .init(type: .label, identifier: "Invalid expiry date")

				/// Invalid CVC format.
				static let invalidCVC: VGSUITestElement = .init(type: .label, identifier: "Invalid CVC/CVV format")
			}

			/// Billing address.
			enum BillingAddress {
				/// City is empty.
				static let emptyCity: VGSUITestElement = .init(type: .label, identifier: "City is empty")

				/// Invalid ZIP.
				static let invalidZIP: VGSUITestElement = .init(type: .label, identifier: "ZIP is invalid")
			}
		}

		/// Checkout hints.
		enum CheckoutHints {

			/// Billing address hints.
			enum BillingAddress {
				/// Postal code hint.
				static let postalCodeHint: VGSUITestElement = .init(type: .label, identifier: "POSTAL CODE")

				/// Zip hint.
				static let zipHint: VGSUITestElement = .init(type: .label, identifier: "ZIP")
			}
		}
	}

	/// Fill in correct data.
	func fillInCorrectCardData() {
		VGSTextField.CardDetails.cardHolderName.find(in: app).type("Joe Business")
		wait(forTimeInterval: 0.2)
		VGSTextField.CardDetails.cardNumber.find(in: app).type("4111111111111111")
		VGSTextField.CardDetails.expirationDate.find(in: app).type("10")
		VGSTextField.CardDetails.expirationDate.find(in: app).type("25", shouldClear: false)
		VGSTextField.CardDetails.cvc.find(in: app).type("333", shouldClear: false)

		// Tap on view to close keyboard.
		// Tap on card details section label to close keyboard.
		Labels.CheckoutSectionTitles.cardDetails.find(in: app).tap()
	}

	/// Fill in correct billing address.
	func fillInCorrectBillingAddress() {
		VGSTextField.BillingAddress.addressLine1.find(in: app).type("1555 Lake Woodlands Dr")

		// Tap on billing address section label to close keyboard.
		Labels.CheckoutSectionTitles.billingAddress.find(in: app).tap()

		// Swipe up to make other address fields visible.
		app.swipeUp()

		VGSTextField.BillingAddress.city.find(in: app).type("Spring")
		VGSTextField.BillingAddress.zip.find(in: app).type("77380")

		// Tap on billing address section label to close keyboard.
		Labels.CheckoutSectionTitles.billingAddress.find(in: app).tap()
	}

	/// Fill in correct billing address with no postal code.
	func fillInCorrectBillingAddressWithNoPostalCode() {
		// Select Bolivia (country without postal code).
		selectCountry("Bolivia", currentCounryName: "United States")

		// Type in address line 1.
		VGSTextField.BillingAddress.addressLine1.find(in: app).type("c. Andres Muñoz # 1078")

		// Tap on billing address section label to close keyboard.
		Labels.CheckoutSectionTitles.billingAddress.find(in: app).tap()

		// Swipe up to make other address fields visible.
		app.swipeUp()

		// Type in City.
		VGSTextField.BillingAddress.city.find(in: app).type("La Paz")

		// Verify postal code/zip is not displayed.
		XCTAssertFalse(Labels.CheckoutHints.BillingAddress.zipHint.exists(in: app))
		XCTAssertFalse(Labels.CheckoutHints.BillingAddress.zipHint.exists(in: app))

		// Tap on billing address section label to close keyboard.
		Labels.CheckoutSectionTitles.billingAddress.find(in: app).tap()
	}

	/// Fill in wrong card data.
	func fillInWrongCardData() {
		VGSTextField.CardDetails.cardHolderName.find(in: app).type("Joe Business")
		wait(forTimeInterval: 0.2)

		VGSTextField.CardDetails.cardNumber.find(in: app).type("12345678")
		VGSTextField.CardDetails.expirationDate.find(in: app).type("10")
		VGSTextField.CardDetails.expirationDate.find(in: app).type("20", shouldClear: false)
		VGSTextField.CardDetails.cvc.find(in: app).type("3", shouldClear: false)

		// Tap on view to close keyboard.
		// Tap on card details section label to close keyboard.
		Labels.CheckoutSectionTitles.cardDetails.find(in: app).tap()
	}

	/// Fill in invalid billing address.
	func fillInInvalidBillingAddress() {
		VGSTextField.BillingAddress.addressLine1.find(in: app).type("1555 Lake Woodlands Dr")

		// Swipe up to make other address fields visible.
		app.swipeUp()

		VGSTextField.BillingAddress.zip.find(in: app).type("AABB12")

		// Tap on billing address section label to close keyboard.
		Labels.CheckoutSectionTitles.billingAddress.find(in: app).tap()
	}

	/// Check whether success alert is presented.
	func verifySuccessAlertExists() {
		XCTAssertEqual(app.alerts.element.label, Labels.alertSuccessTitle)
	}

	/// Selects country name in country picker.
	/// - Parameter countryName: `String` object, country name.
	/// - Parameter currentCounryName: `String` object, country name displayed now.
	func selectCountry(_ countryName: String, currentCounryName: String) {

		// Tap to activate picker view in country field.
		let countryField: VGSUITestElement = .init(type: .textField, identifier: currentCounryName)
		countryField.find(in: app).tap()

		// Wait for keyboard.
		wait(forTimeInterval: 0.5)

		// Select country by name.
		app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: countryName)
		app.pickerWheels.element(boundBy: 0).tap()

		// Tap on billing address section label to close keyboard.
		Labels.CheckoutSectionTitles.billingAddress.find(in: app).tap()
	}

	/// Verify postal code UI.
	func verifyPostalCodeUI() {
		// Verify postal code hint exists.
		XCTAssert(Labels.CheckoutHints.BillingAddress.postalCodeHint.exists(in: app))
	}

	/// Verify UI for ZIP.
	func verifyZIPUI() {
		// Verify postal code hint exists.
		XCTAssert(Labels.CheckoutHints.BillingAddress.zipHint.exists(in: app))
	}

	/// Veify UI on country change.
	func verifyChangeCountryFlowUI() {
		// Verify zip code is visible.
		verifyZIPUI()

		// Select Australia.
		selectCountry("Australia", currentCounryName: "United States")

		// Swipe up.
		app.swipeUp()

		// Verify zip error is disappeared and ZIP hint changed to postal code.
		verifyPostalCodeUI()

		// Verify zip code error was disappeared.
		XCTAssertFalse(Labels.CheckoutErrorLabels.BillingAddress.invalidZIP.exists(in: app))

		// Select country without postal code.
		selectCountry("Bolivia", currentCounryName: "Australia")

		// Swipe up.
		app.swipeUp()

		// Verify postal code/zip field view is disappeared.
		XCTAssertFalse(Labels.CheckoutHints.BillingAddress.postalCodeHint.exists(in: app))
		XCTAssertFalse(Labels.CheckoutHints.BillingAddress.zipHint.exists(in: app))

		// Select USA.
		selectCountry("United States", currentCounryName: "Bolivia")

		// Swipe up.
		app.swipeUp()

		// Verify zip code is visible.
		verifyZIPUI()
	}

	/// Check whether card details errors are presented.
	func verifyCardDetailsValidationErrors() {
		XCTAssert(Labels.CheckoutErrorLabels.CardDetails.invalidCardNumber.exists(in: app))
		XCTAssert(Labels.CheckoutErrorLabels.CardDetails.invalidExpiryDate.exists(in: app))
		XCTAssert(Labels.CheckoutErrorLabels.CardDetails.invalidCVC.exists(in: app))
	}

	/// Check whether billing address errors are presented.
	func verifyBillingAddressValidationErrors() {
		XCTAssert(Labels.CheckoutErrorLabels.BillingAddress.emptyCity.exists(in: app))
		XCTAssert(Labels.CheckoutErrorLabels.BillingAddress.invalidZIP.exists(in: app))
	}

	/// Tap to start checkout.
	func startCheckout() {
		// Tap on collect button to send data.
		Buttons.startCheckout.find(in: app).tap()

		// Wait for checkout screen.
		wait(forTimeInterval: 1.5)
	}

	/// Tap to save card data.
	func tapToSaveCardInCheckout() {
		// Tap on save card button to send data.
		Buttons.checkoutSaveCard.find(in: app).tap()

		// Wait some time for submit data.
		wait(forTimeInterval: 2.5)
	}
}

// swiftlint:enable nesting
