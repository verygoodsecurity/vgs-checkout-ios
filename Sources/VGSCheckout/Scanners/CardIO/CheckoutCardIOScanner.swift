//
//  CheckoutCardIOScanner.swift
//  
//

import Foundation
#if os(iOS)
import UIKit
#endif
//import VGSCollectSDK

// Holds VGSCheckout config.
public struct VGSCheckoutConfiguration {

	/// Collect config.
	public let collectConfig: VGSCheckoutCollectConfiguration

	/// Inbound rout path for your organization vault.
	public let path: String

	/// Card details options. Check `VGSCheckoutCardDetailsOptions` for default options.
	public var cardDetailsOptions: VGSCheckoutCardDetailsOptions = VGSCheckoutCardDetailsOptions()

	/// Route configuration, default is `VGSCheckoutRouteConfiguration` object.
	public var routeConfiguration: VGSCheckoutRouteConfiguration = VGSCheckoutRouteConfiguration()

	/// Initialization.
	/// - Parameters:
	///   - vaultID: `String` object, Organization vault id.
	///   - environemnt: `String` object
	///   - path: `String` object
	///   - cardDetailsOptions: `VGSCheckoutCardDetailsOptions` object, card details configuration.
	///   - routeConfiguration: `VGSCheckoutRouteConfiguration` object, route configuration.
	public init(vaultID: String, environemnt: String, path: String, cardDetailsOptions: VGSCheckoutCardDetailsOptions, routeConfiguration: VGSCheckoutRouteConfiguration) {
		self.collectConfig = VGSCheckoutCollectConfiguration(vaultID: vaultID, environemnt: environemnt)
		self.path = path
		self.cardDetailsOptions = cardDetailsOptions
		self.routeConfiguration = routeConfiguration
	}
}

/// Card details options.
public struct VGSCheckoutCardDetailsOptions {

	/// Defines how to display card holder name field.
	public enum CardHolderNameFieldType {
		/**
		 Custom host URL. Should be configured on the dashboard.

		 - Parameters:
				- hostname: `String` object, valid custom hostname.
		*/
		case hidden

		/**
		 Custom host URL. Should be configured on the dashboard.

		 - Parameters:
				- hostname: `String` object, valid custom hostname.
		*/
		case single(_ fieldName: String)

		/**
		 Card holder name is splitted to first and last name.

		 - Parameters:
				- firstFieldName: `String` object, first name fieldName.
				- lastFieldName: `String` object, last name firstName fieldName.
		*/
		case splitted(_ firstFieldName: String, _ lastFieldName: String)
	}

	/// Card number field name (should be configured in your route on the dashboard).
	public let cardNumberFieldName: String = ""

	/// Expiration date field name (should be configured in your route on the dashboard)
	public let expidationDateFieldName: String = ""

	/// CVC field name (should be configured in your route on the dashboard)
	public var cvcFieldName: String = ""

	/// A boolean flag indicating wether postal code is hidden.
	public var isPostalCodeHidden: Bool = true

	/// Postal code field name (should be configured in your route on the dashboard).
	public let postalCodeFieldName: String = ""

	/// A boolean flag indicating wether card icon is hidden. Default is `false`.
	public var isCardIconHidden: Bool = false

	/// Card holder name field type. Default is `hidden`.
	public var cardHolderNameFieldType: CardHolderNameFieldType = .hidden

//  Default value *all brands.
//	public var allowedCardBrands: VGSCollectCardBrands = Card

	/// no:doc
	public init() {}
}

/// Route configuration
public struct VGSCheckoutRouteConfiguration {

	/// Hostname policy (specifies different hosts how to send your data). Default is `vault`.
	public var hostnamePolicy: VGSCheckoutHostnamePolicy = .vault

	/// Request options, default `VGSCheckoutRequestOptions`.
	public var requestOptions = VGSCheckoutRequestOptions()

	/// A boolean flag indicating wether multiplexing (payment optimization) is enabled. Default is `false`.
	public let isMultiplexingEnabled: Bool = false

	/// no:doc
	public init() {}
}

/// Holds configuration for VGS Collect setup.
public struct VGSCheckoutCollectConfiguration {

	/// Organization vault id.
	public let vaultID: String

	/// Organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox").
	public let environment: String

	/// Initialization.
	/// - Parameters:
	///   - vaultID: `String` object, organization vault id.
	///   - environemnt: `String` object, organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox").
	public init(vaultID: String, environemnt: String) {
		self.vaultID = vaultID
		self.environment = environemnt
	}
}

/// Defines hostname policy to send data.
public enum VGSCheckoutHostnamePolicy {

	/// Use default vault.
	case vault

	/**
	 Custom host URL. Should be configured on the dashboard.

	 - Parameters:
			- hostname: `String` object, valid custom hostname.
	*/
	case customHostname(_ hostname: String)

	/**
	 Configuration for local testing with satellite.

	 - Parameters:
			- satelliteConfiguration: `VGSCheckoutSatelliteConfiguration` object, configuration for local testing.
	*/
	case local(_ satelliteConfiguration: VGSCheckoutSatelliteConfiguration)
}

/// Holds configuration for local testing with VGS Satellite.
public struct VGSCheckoutSatelliteConfiguration {
	/**
  Satellite localhost. IMPORTANT! Use only with .sandbox environment! Should be specified for valid http://localhost or in local IP format http://192.168.X.X.
	*/
	public let localhost: String

	/// Custom port for Satellite configuration.
	public let port: Int

	/// Initialization.
	/// - Parameters:
	///   - ip: `String` object, Satellite localhost. IMPORTANT! Use only with .sandbox environment! Should be specified for valid http://localhost or in local IP format http://192.168.X.X.
	///   - port: Custom port for Satellite configuration.
	public init(localhost: String, port: Int) {
		self.localhost = localhost
		self.port = port
	}
}

/// Additional options for request.
public struct VGSCheckoutRequestOptions {

	/// HTTP Method. Default is `post`.
	public var method: VGSCheckoutHTTPMethod = .post

	/// Extra data, should be valid `JSON`. Default is `nil`.
	public var extraData: [String: Any]?

	/// Merge options, default is `flat`.
	public var mergeOptions: VGSCheckoutDataMergePolicy = .flat

	/// no:doc
	public init() {}
}

/// Defines policy how to merge data.
public enum VGSCheckoutDataMergePolicy {
	/// FieldName will be treated as a flat key without any nested levels.
	/// data.cardNumber -> ["data.cardNumber" : "4111111111111111"]
	case flat

	/// Map data to the nested JSON.
	/// data.cardNumber -> ["data" : ["cardNumber" : "4111111111111111"]].
	case nestedJSON

	/**
	Map field name to nested JSON and array if array index is specified.
	Example:
	card_data[1].number => nested JSON with array

		{
			"card_data" :
				[
					null,

					{ "number" : "4111111111111111" }
				]
		}

	Completely overwrite extra data array with Collect Array data.

				// Collect fields JSON:
				[
				 { "cvc" : "555" }
				]

				// Extra data JSON:
				[
				 { "number" : "4111111111111111" },
				 { "id" : "1111" }
				]

				// JSON to submit:
				[
				 {
					"cvc" : "555",
				 }
				]
	*/
	case nestedWithArrayOverwrite

	/**
	Map field name to nested JSON and array if array index is specified.
	Example:
	card_data[1].number => nested JSON with array

		{
			"card_data" :
				[
					null,

					{ "number" : "4111111111111111" }
				]
		}

	Merge arrays content at the same nested level if possible.

				// Collect fields JSON:
				[
				 { "cvc" : "555" }
				]

				// Extra data JSON:
				[
				 { "number" : "4111111111111111" }
				]

				// JSON to submit:
				[
				 {
					"cvc" : "555",
					"number" : "4111111111111111"
				 }
				]
	*/
	case nestedWithArrayMerge
}

//#if canImport(CardIOSDK)
//import CardIOSDK
//#endif
//import CardIO

//let view = CardIOView(frame: .zero)

public class VGSCheckout {

	public enum CardScanner {
		case cardIO
		case bouncer
	}

	// MARK: - Initializer

	public init() {}

	// MARK: - Interface

	public func presentCheckout(from viewController: UIViewController, cardScanner: CardScanner?) {
		let checkoutVC = CheckoutViewController(cardScanner: cardScanner)
		checkoutVC.modalPresentationStyle = .fullScreen
		viewController.present(checkoutVC, animated: true, completion: nil)
	}

	public func present(from viewController: UIViewController, configuration: String) {

	}
}

internal class CheckoutViewController: UIViewController {

	fileprivate var cardScanner: VGSCheckout.CardScanner?

	internal init(cardScanner: VGSCheckout.CardScanner?) {
		self.cardScanner = cardScanner
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .yellow
		guard let scanner = cardScanner else {
			return
		}

		switch scanner {
		case .cardIO:
			#if canImport(CardIOSDK)
			  let view = CardIOView(frame: .zero)
			#endif
		case .bouncer:
			break
		}
	}
}

/// HTTP request methods
public enum VGSCheckoutHTTPMethod: String {
		/// GET method.
		case get     = "GET"
		/// POST method.
		case post    = "POST"
		/// PUT method.
		case put     = "PUT"
		/// PATCH method.
		case patch = "PATCH"
		/// DELETE method.
		case delete = "DELETE"
}
