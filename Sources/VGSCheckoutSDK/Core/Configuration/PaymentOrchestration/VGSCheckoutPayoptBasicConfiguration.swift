//
//  VGSCheckoutPayoptBasicConfiguration.swift
//  VGSCheckoutSDK

import Foundation

/// Interface for pay opt configurations.
internal protocol VGSCheckoutPayoptBasicConfiguration {

	/// Form configuration options.
	var formConfiguration: VGSPaymentOrchestrationFormConfiguration {get set}

	/// Country billing address options.
	var billingAddressCountryFieldOptions: VGSCheckoutBillingAddressCountryOptions {get set}

	/// Address line 1 billing address options.
	var billingAddressLine1FieldOptions: VGSCheckoutBillingAddressLine1Options {get set}

	/// Address line 2 billing address options.
	var billingAddressLine2FieldOptions: VGSCheckoutBillingAddressLine2Options {get set}

	/// City billing address options.
	var billingAddressCityFieldOptions: VGSCheckoutBillingAddressCityOptions {get set}

	/// Postal code billing address options.
	var billingAddressPostalCodeFieldOptions: VGSCheckoutBillingAddressPostalCodeOptions {get set}

	/// Billing address section visibility.
	var billingAddressVisibility: VGSCheckoutBillingAddressVisibility {get set}

	/// Enable save card option. If enabled - button with option to save card for future payments will be displayed. Default is `true`. Default **save card button** state is `selected`. **NOTE** User choice for save card option will not be stored on VGS side.
	var isSaveCardOptionEnabled: Bool {get set}

	/// A boolean flag indicating whether user can remove saved cards. Default is `true`.
	var isRemoveCardOptionEnabled: Bool {get set}

	/// An array of saved cards.
	var savedCards: [VGSSavedCardModel] {get set}

	/// An array of financial instruments ids representing saved cards.
	var savedPaymentCardsIds: [String] {get set}

	/// Payopt flow type.
	var payoptFlow: VGSCheckoutPayOptFlow {get}

	/// UI theme.
	var uiTheme: VGSCheckoutThemeProtocol {get set}

	/// VGSCollect object.
	var vgsCollect: VGSCollect {get}

	/// Access token.
	var accessToken: String {get}
  
  /// Default Inbound route route id created in vault during default integration with payopt on dashboard.
  static var defaultPayoptRouteId: String {get}
}

/// Defines payopt flow type.
internal enum VGSCheckoutPayOptFlow {

	/// Add card.
	case addCard

	/// Transfers.
	case transfers
}
