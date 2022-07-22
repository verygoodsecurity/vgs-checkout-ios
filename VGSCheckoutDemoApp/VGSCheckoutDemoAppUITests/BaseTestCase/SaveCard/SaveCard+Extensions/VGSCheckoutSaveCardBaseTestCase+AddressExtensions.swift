//
//  VGSCheckoutSaveCardBaseTestCase+AddressExtensions.swift
//  VGSCheckoutDemoAppUITests

import Foundation

// no:doc
extension VGSCheckoutSaveCardBaseTestCase {

	// Verifies all address fields are hidden.
	func verifyAllAddressFieldsAreHidden() {
		// Verify billing address section hint doesn't exist.
		verifyIsAddressSectionVisible(false)

		// Verify address hint don't exists.
		verifyFieldsVisibility([.country, .addressLine1, .addressLine2, .city], isVisible: false)

		// Verify postal code doesn't exist.
		verifyIsPostalCodeVisible(false)

		// Verify zip doesn't exist.
		verifyIsZipVisible(false)
	}

	/// Verifies billing address fields visibility.
	/// - Parameters:
	///   - fields: `[VGSCheckoutUITestsAddressFields]` object, array of billing address fields.
	///   - isVisible: `Bool` object, `true` if should be visible.
	///   - shouldUseZIP: `Bool` object, `true` if should verify `zip` code instead of postal code, default is `false`.
	fileprivate func verifyFieldsVisibility(_ fields: [VGSCheckoutUITestsAddressFields], isVisible: Bool, shouldUseZIP: Bool = false) {
		fields.forEach { field in
			switch field {
			case .country:
				// Verify country hint.
				XCTAssert(Labels.CheckoutHints.BillingAddress.countryHint.exists(in: app) == isVisible)
			case .addressLine1:
				// Verify address line 1 hint.
				XCTAssert(Labels.CheckoutHints.BillingAddress.addressLine1Hint.exists(in: app) == isVisible)
			case .addressLine2:
				// Verify address line 2 hint.
				XCTAssert(Labels.CheckoutHints.BillingAddress.addressLine2Hint.exists(in: app) == isVisible)
			case .city:
				// Verify city hint.
				XCTAssert(Labels.CheckoutHints.BillingAddress.cityHint.exists(in: app) == isVisible)
			case .postalCode:
				// Verify zip or postal code hints.
				if shouldUseZIP {
					XCTAssert(Labels.CheckoutHints.BillingAddress.zipHint.exists(in: app) == isVisible)
				} else {
					XCTAssert(Labels.CheckoutHints.BillingAddress.postalCodeHint.exists(in: app) == isVisible)
				}
			}
		}
	}
}
