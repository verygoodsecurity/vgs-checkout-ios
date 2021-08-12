//
//  PostalCodeValidationTest.swift
//  VGSCheckoutTests
//

import Foundation
import XCTest
@testable import VGSCheckout

/// Test postal codes validation
class VGSPostalCodeValidationTest: XCTestCase {
  
  struct CountryStrings {
    let placeholder: String
    let invalidErrorText: String
    let emptyErrorText: String
  }
  
  var configuration: VGSCheckoutConfiguration!
  var checkout: VGSCheckout!
  
  lazy var testCountryData: [VGSCountriesISO: CountryStrings] = {
    return prepareCountryStringsData()
  }()
  
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
  
  func testDynamicPlaceholderChanges() {
    guard let postalCodeField = checkout.addCardUseCaseManager.addressDataSectionViewModel.postalCodeFieldView?.textField else {
      XCTFail("ERROR: NO PostalCodeField")
      return
    }
      
    for (country, countryData) in testCountryData {
      checkout.addCardUseCaseManager.addressDataSectionViewModel.updatePostalCodeField(with: country)
      XCTAssertTrue(postalCodeField.textField.placeholder == countryData.placeholder, "Placeholder error: wrong placeholder for country \(country) - \(String(describing: postalCodeField.textField.placeholder))")
    }
  }
  
  func testEmptyPostalCodeErrorsPerCountry() {
    guard let postalCodeField = checkout.addCardUseCaseManager.addressDataSectionViewModel.postalCodeFieldView?.textField else {
      XCTFail("ERROR: NO PostalCodeField")
      return
    }
      
    for (country, countryData) in testCountryData {
      checkout.addCardUseCaseManager.addressDataSectionViewModel.updatePostalCodeField(with: country)
      guard let errorText = postalCodeField.state.validationErrors.first else {
        XCTFail("ERROR: no empty field error message for country \(country)")
        return
      }
      XCTAssertTrue(errorText == countryData.emptyErrorText, "Empty field error message for country \(country) error: \n expected - \(countryData.emptyErrorText)  \n current: \(errorText)")
    }
  }
  
  func testWrongPostalCodeErrorsPerCountry() {
    guard let postalCodeField = checkout.addCardUseCaseManager.addressDataSectionViewModel.postalCodeFieldView?.textField else {
      XCTFail("ERROR: NO PostalCodeField")
      return
    }
      
    for (country, countryData) in testCountryData {
      checkout.addCardUseCaseManager.addressDataSectionViewModel.updatePostalCodeField(with: country)
      postalCodeField.setText(country.invalidPostalCodes.first)
      
      guard let errorText = postalCodeField.state.validationErrors.first else {
        XCTFail("ERROR: no empty field error message for country \(country)")
        return
      }
      XCTAssertTrue(errorText == countryData.invalidErrorText, "Invalid error message for country \(country) error: \n expected - \(countryData.invalidErrorText)  \n current: \(errorText)")
    }
  }
  
  private func prepareCountryStringsData() -> [VGSCountriesISO: CountryStrings] {
    return [
      VGSCountriesISO.us: CountryStrings(placeholder:
                                                    VGSAddressPostalCode.zip.textFieldPlaceholder,
                                                  invalidErrorText: VGSAddressPostalCode.zip.invalidErrorText,
                                                  emptyErrorText: VGSAddressPostalCode.zip.emptyErrorText),
      VGSCountriesISO.au: CountryStrings(placeholder:
                                                    VGSAddressPostalCode.postalCode.textFieldPlaceholder,
                                                  invalidErrorText: VGSAddressPostalCode.postalCode.invalidErrorText,
                                                  emptyErrorText: VGSAddressPostalCode.postalCode.emptyErrorText)
    ]
  }
}
