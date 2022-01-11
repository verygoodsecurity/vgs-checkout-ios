//
//  PostalCodeValidationTest.swift
//  VGSCheckoutSDKTests
//

import Foundation
import XCTest
@testable import VGSCheckoutSDK

/// Test postal codes validation
class VGSPostalCodeValidationTest: VGSCheckoutBaseTestCase {
  
  struct CountryStrings {
    let placeholder: String
    let invalidErrorText: String
    let emptyErrorText: String
  }
  
  var configuration: VGSCheckoutCustomConfiguration!
  var checkout: VGSCheckout!
  
  lazy var testCountryData: [VGSCountriesISO: CountryStrings] = {
    return prepareCountryStringsData()
  }()
  
  override func setUp() {
    super.setUp()
    
    configuration = VGSCheckoutCustomConfiguration(vaultID: "test", environment: "sandbox")
    checkout = VGSCheckout(configuration: configuration)

		let viewController = UIViewController()
		checkout.present(from: viewController)
  }
  
  func testValidPostalCodesReturnsTrue() {
    guard let postalCodeField = getAddressDataSectionViewModel()?.postalCodeFieldView?.textField else {
      XCTFail("ERROR: NO PostalCodeField")
      return
    }
      
    let countries = VGSCountriesISO.all
    
    for country in countries {
      let validPostalCodes = country.validPostalCodes
      
      //select country in checkout textfield
			getAddressDataSectionViewModel()?.updatePostalCodeField(with: country)

      for postalCode in validPostalCodes {
        postalCodeField.setText(postalCode)
        
        XCTAssertTrue(postalCodeField.state.isValid, "VALIDATION ERROR: \(postalCode) - postal code is invalid for country \(country), but should be valid!")
      }
    }
  }
  
  func testEmptyPostalCodesReturnsFalse() {
    guard let postalCodeField = getAddressDataSectionViewModel()?.postalCodeFieldView?.textField else {
      XCTFail("ERROR: NO PostalCodeField")
      return
    }
    postalCodeField.setText("")

    let countries = VGSCountriesISO.all

    for country in countries {
      // set selected country in checkout textfield
			getAddressDataSectionViewModel()?.updatePostalCodeField(with: country)
      
      XCTAssertTrue(!postalCodeField.state.isValid, "VALIDATION ERROR: Empty postal code is valid for country \(country), but should be not valid!")
    }
  }
  
  func testInvalidPostalCodesReturnsFalse() {
    guard let postalCodeField = getAddressDataSectionViewModel()?.postalCodeFieldView?.textField else {
      XCTFail("ERROR: NO PostalCodeField")
      return
    }
      
    let countries = VGSCountriesISO.all
    
    for country in countries {
      let validPostalCodes = country.invalidPostalCodes
      
      //select country in checkout textfield
			getAddressDataSectionViewModel()?.updatePostalCodeField(with: country)

      for postalCode in validPostalCodes {
        postalCodeField.setText(postalCode)
        
        XCTAssertFalse(postalCodeField.state.isValid, "VALIDATION ERROR: \(postalCode) - postal code is valid for country \(country), but should be invalid!")
      }
    }
  }
  
  func testDynamicPlaceholderChanges() {
    guard let postalCodeField = getAddressDataSectionViewModel()?.postalCodeFieldView?.textField else {
      XCTFail("ERROR: NO PostalCodeField")
      return
    }
      
    for (country, countryData) in testCountryData {
			getAddressDataSectionViewModel()?.updatePostalCodeField(with: country)
      XCTAssertTrue(postalCodeField.textField.placeholder == countryData.placeholder, "Placeholder error: wrong placeholder for country \(country) - \(String(describing: postalCodeField.textField.placeholder))")
    }
  }
  
  func testEmptyPostalCodeErrorsPerCountry() {
    guard let postalCodeField = getAddressDataSectionViewModel()?.postalCodeFieldView?.textField else {
      XCTFail("ERROR: NO PostalCodeField")
      return
    }
      
    for (country, countryData) in testCountryData {
			getAddressDataSectionViewModel()?.updatePostalCodeField(with: country)
      guard let errorText = postalCodeField.state.validationErrors.first else {
        XCTFail("ERROR: no empty field error message for country \(country)")
        return
      }
      XCTAssertTrue(errorText == countryData.emptyErrorText, "Empty field error message for country \(country) error: \n expected - \(countryData.emptyErrorText)  \n current: \(errorText)")
    }
  }
  
  func testWrongPostalCodeErrorsPerCountry() {
    guard let postalCodeField = getAddressDataSectionViewModel()?.postalCodeFieldView?.textField else {
      XCTFail("ERROR: NO PostalCodeField")
      return
    }
      
    for (country, countryData) in testCountryData {
			getAddressDataSectionViewModel()?.updatePostalCodeField(with: country)
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

	func getAddressDataSectionViewModel() -> VGSAddressDataSectionViewModel? {
		guard let navVC = checkout.checkoutCoordinator?.rootController as? UINavigationController, let cardVC = navVC.viewControllers.first as? VGSBaseCardViewController else {return nil}
		return cardVC.addressDataSectionViewModel
	}
}
