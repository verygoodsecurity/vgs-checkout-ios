//
//  AddressLineTest.swift
//  VGSCheckoutSDKTests
//

import Foundation
import XCTest
@testable import VGSCheckoutSDK

/// Test postal codes validation
class VGSAddressLineTests: VGSCheckoutBaseTestCase {
  
  var configuration: VGSCheckoutConfiguration!
  var checkout: VGSCheckout!
  
  override func setUp() {
    super.setUp()
    
    configuration = VGSCheckoutConfiguration(vaultID: "test", environment: "sandbox")
    checkout = VGSCheckout(configuration: configuration)

		let viewController = UIViewController()
		checkout.present(from: viewController)
  }
  
  func testValidAddress() {
    let validAddressSource = ["City A, Street B, house 1, room 2",
                              "Street 1, phone +109379997",
                              "a, b, c",
                              "3333"]
    
		guard let addressLine1TextField = checkout.addCardUseCaseManager?.addressDataSectionViewModel.billingAddressFormView.addressLine1FieldView.textField else {
			return
		}
    
		guard let addressLine2TextField = checkout.addCardUseCaseManager?.addressDataSectionViewModel.billingAddressFormView.addressLine2FieldView.textField else {
			return
		}
    
    for address in validAddressSource {
      addressLine1TextField.setText(address)
      addressLine2TextField.setText(address)
      XCTAssertTrue(addressLine1TextField.state.isValid, "VALIDATION ERROR: \(address) - address is invalid for addressLine1TextField, but should be valid!")
      XCTAssertTrue(addressLine2TextField.state.isValid, "VALIDATION ERROR: \(address) - address is invalid for addressLine2TextField, but should be valid!")
    }
    
    func testEmptyAddress() {
			guard let addressLine1TextField = checkout.addCardUseCaseManager?.addressDataSectionViewModel.billingAddressFormView.addressLine1FieldView.textField else {
				return
			}

			guard let addressLine2TextField = checkout.addCardUseCaseManager?.addressDataSectionViewModel.billingAddressFormView.addressLine2FieldView.textField else {
				return
			}
      
        addressLine1TextField.setText("")
        addressLine2TextField.setText("")
      
        /// addressLine1TextField could not be empty!
        XCTAssertFalse(addressLine1TextField.state.isValid, "VALIDATION ERROR: address is valid for addressLine1TextFieldField, but should be invalid!")
        /// addressLine2TextField is optional!
        XCTAssertTrue(addressLine2TextField.state.isValid, "VALIDATION ERROR: address is invalid for addressLine2TextFieldField, but should be valid!")
    }
  }
}
