//
//  PostalCodeValidationTest.swift
//  VGSCheckoutTests
//

import Foundation
import XCTest
@testable import VGSCheckout

/// Test postal codes validation
class VGSPostalCodeValidationTest: XCTestCase {
  
  var configuration: VGSCheckoutConfiguration!
  var checkout: VGSCheckout!
  
  override func setUp() {
    super.setUp()
    
    configuration = VGSCheckoutConfiguration(vaultID: "test", environment: "sandbox")
    checkout = VGSCheckout(configuration: configuration)
  }
  
  func testValidPostalCodesReturnsTrue() {
    guard let postalCodeField = checkout.addCardUseCaseManager.addressDataSectionViewModel.postalCodeFieldView?.textField else {
      XCTFail("ERROR: NO PostalCodeField")
      return
    }
      
    let countries = VGSCountriesISO.all
    
    for country in countries {
      let validPostalCodes = country.validPostalCodes
      
      //select country in checkout textfield
      checkout.addCardUseCaseManager.addressDataSectionViewModel.updatePostalCodeField(with: country)

      for postalCode in validPostalCodes {
        postalCodeField.setText(postalCode)
        
        XCTAssertTrue(postalCodeField.state.isValid, "VALIDATION ERROR: \(postalCode) - postal code is invalid for country \(country), but should be valid!")
      }
    }
  }
  
  func testEmptyPostalCodesReturnsFalse() {
    guard let postalCodeField = checkout.addCardUseCaseManager.addressDataSectionViewModel.postalCodeFieldView?.textField else {
      XCTFail("ERROR: NO PostalCodeField")
      return
    }
    postalCodeField.setText("")

    let countries = VGSCountriesISO.all

    for country in countries {
      // set selected country in checkout textfield
      checkout.addCardUseCaseManager.addressDataSectionViewModel.updatePostalCodeField(with: country)
      
      XCTAssertTrue(!postalCodeField.state.isValid, "VALIDATION ERROR: Empty postal code is valid for country \(country), but should be not valid!")
    }
  }
  
  func testInvalidPostalCodesReturnsFalse() {
    guard let postalCodeField = checkout.addCardUseCaseManager.addressDataSectionViewModel.postalCodeFieldView?.textField else {
      XCTFail("ERROR: NO PostalCodeField")
      return
    }
      
    let countries = VGSCountriesISO.all
    
    for country in countries {
      let validPostalCodes = country.invalidPostalCodes
      
      //select country in checkout textfield
      checkout.addCardUseCaseManager.addressDataSectionViewModel.updatePostalCodeField(with: country)

      for postalCode in validPostalCodes {
        postalCodeField.setText(postalCode)
        
        XCTAssertFalse(postalCodeField.state.isValid, "VALIDATION ERROR: \(postalCode) - postal code is valid for country \(country), but should be invalid!")
      }
    }
  }
  
}
