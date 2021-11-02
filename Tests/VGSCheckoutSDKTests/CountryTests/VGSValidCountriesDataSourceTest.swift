//
//  VGSValidCountriesTest.swift
//  VGSCheckoutSDKTests
//


import Foundation
import XCTest
@testable import VGSCheckoutSDK

///VGSCountryPickerDataSource
/// Test postal codes validation
class VGSValidCountriesDataSourceTest: VGSCheckoutBaseTestCase {
  
  struct TestCountriesDataSource {
    let inputCodes: [String]?
    let expectedResult: [String]
  }
    
  func testValidCountryCodesReturnsTrue() {
    
    let testDataSource = [TestCountriesDataSource(inputCodes: ["AU", "UA", "US"],
                                              expectedResult: ["AU", "UA", "US"]),
                          TestCountriesDataSource(inputCodes: ["ZW", "ID", "AD"],
                                              expectedResult: ["ZW", "ID", "AD"])
    
    ]
    
    for testCase in testDataSource {
      let countryModelSource = VGSCountryPickerDataSource(validCountries: testCase.inputCodes)
      let countryModelsISOCodes = countryModelSource.countries.compactMap({$0.code})
      XCTAssertTrue(testCase.expectedResult == countryModelsISOCodes, "VALIDATION ERROR: different country codes in \n expectedResult: \n \(testCase.expectedResult.description) \n countryModelsISOCodes: \n \(countryModelsISOCodes)")
    }
  }
  
  func testValidWithInvalidCountryCodesReturnsTrue() {
    let testDataSource = [TestCountriesDataSource(inputCodes: ["AU", "xxxx", "https://vgs.com", "IT"],
                                              expectedResult: ["AU", "IT"]),
                          TestCountriesDataSource(inputCodes: ["ZZZ", "00", "TR", "HU", "it", ""],
                                              expectedResult: ["TR", "HU"])
    
    ]
    
    for testCase in testDataSource {
      let countryModelSource = VGSCountryPickerDataSource(validCountries: testCase.inputCodes)
      let countryModelsISOCodes = countryModelSource.countries.compactMap({$0.code})
      XCTAssertTrue(testCase.expectedResult == countryModelsISOCodes, "VALIDATION ERROR: different country codes in \n expectedResult: \n \(testCase.expectedResult.description) \n countryModelsISOCodes: \n \(countryModelsISOCodes)")
    }
  }
  
  func testInvalidCountryCodesReturnsAllCountries() {
    let allCountriesCodes = VGSAddressCountriesDataProvider.provideAllCountries().compactMap{ $0.code }
    guard !allCountriesCodes.isEmpty else {
      XCTFail("FAILED: allCountriesCodes - is EMPTY array!")
      return
    }

    let testDataSource = [TestCountriesDataSource(inputCodes: [],
                                                  expectedResult: allCountriesCodes),
                          TestCountriesDataSource(inputCodes: nil,
                                              expectedResult: allCountriesCodes),
                          TestCountriesDataSource(inputCodes: ["ZZZ", "00", "it", ""],
                                              expectedResult: allCountriesCodes)
    ]
    
    for testCase in testDataSource {
      let countryModelSource = VGSCountryPickerDataSource(validCountries: testCase.inputCodes)
      let countryModelsISOCodes = countryModelSource.countries.compactMap({$0.code})
      XCTAssertTrue(testCase.expectedResult == countryModelsISOCodes, "VALIDATION ERROR: different country codes in \n expectedResult: \n \(testCase.expectedResult.description) \n countryModelsISOCodes: \n \(countryModelsISOCodes)")
    }
  }
}
