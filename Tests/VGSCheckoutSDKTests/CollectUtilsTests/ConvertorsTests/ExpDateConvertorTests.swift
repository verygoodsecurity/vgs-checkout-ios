//
//  ExpDateConvertorTests.swift
//  VGSCheckoutSDKTests

import Foundation
import XCTest
@testable import VGSCheckoutSDK

class ExpDateConvertorTests: VGSCheckoutBaseTestCase {
  var collector: VGSCollect!
  var textField: VGSExpDateTextField!

	struct TestDataType {
		let input: String
		let output: String
	}

  override func setUp() {
		  super.setUp()
      collector = VGSCollect(id: "any")
      textField = VGSExpDateTextField()
  }

  override func tearDown() {
      collector = nil
      textField = nil
  }

	func testConvertExpDate1() {
    var fieldOptions = VGSCheckoutExpirationDateOptions()
    fieldOptions.inputDateFormat = .longYear
    
    let config = VGSExpDateConfiguration(checkoutExpDateOptions: fieldOptions, collect: collector)
    // Update validation rules
    let expDateValidationRule = VGSValidationRuleCardExpirationDate(dateFormat: fieldOptions.inputDateFormat,
                                                                    error: VGSValidationErrorType.expDate.rawValue)
    config.validationRules = VGSValidationRuleSet(rules: [expDateValidationRule])
		textField.configuration = config

		let testDates1: [TestDataType] = [TestDataType(input: "12/2025", output: "12/25"),
																			TestDataType(input: "01/2050", output: "01/50"),
																			TestDataType(input: "05/2100", output: "05/00")]

		for date in testDates1 {
			textField.setText(date.input)
			if let outputText = textField.getOutputText() {
				XCTAssertTrue( outputText == date.output, "Expiration date convert error:\n - Input: \(date.input)\n - Output: \(date.output)\n - Result: \(outputText)")
			} else {
				print("failed: \(date.input) \(date.output)")
			}
      XCTAssertTrue(textField.state.isValid, "Expiration date state error:\n - Input: \(date.input) should be valid!")
		}
	}

	func testConvertExpDate2() {
    var fieldOptions = VGSCheckoutExpirationDateOptions()
    fieldOptions.outputDateFormat = .longYear
    
    let config = VGSExpDateConfiguration(checkoutExpDateOptions: fieldOptions, collect: collector)
    // Update validation rules
    let expDateValidationRule = VGSValidationRuleCardExpirationDate(dateFormat: fieldOptions.inputDateFormat,
                                                                    error: VGSValidationErrorType.expDate.rawValue)
    config.validationRules = VGSValidationRuleSet(rules: [expDateValidationRule])
    textField.configuration = config

		let testDates2: [TestDataType] = [TestDataType(input: "12/25", output: "12/2025"),
																			TestDataType(input: "01/30", output: "01/2030"),
																			TestDataType(input: "05/41", output: "05/2041")]

		for date in testDates2 {
			textField.setText(date.input)
			if let outputText = textField.getOutputText() {
				XCTAssertTrue(outputText == date.output, "Expiration date convert error:\n - Input: \(date.input)\n - Output: \(date.output)\n - Result: \(outputText)")
			} else {
				print("failed: \(date.input) \(date.output)")
			}
      XCTAssertTrue(textField.state.isValid, "Expiration date state error:\n - Input: \(date.input) should be valid!")
		}
	}

	func testConvertExpDate3() {
    var fieldOptions = VGSCheckoutExpirationDateOptions()
    fieldOptions.inputDateFormat = .longYear
    
    let config = VGSExpDateConfiguration(checkoutExpDateOptions: fieldOptions, collect: collector)
    config.divider = ""
    // Update validation rules
    let expDateValidationRule = VGSValidationRuleCardExpirationDate(dateFormat: fieldOptions.inputDateFormat,
                                                                    error: VGSValidationErrorType.expDate.rawValue)
    config.validationRules = VGSValidationRuleSet(rules: [expDateValidationRule])
    textField.configuration = config

		let testDates3: [TestDataType] = [TestDataType(input: "122025", output: "1225"),
																			TestDataType(input: "012050", output: "0150"),
																			TestDataType(input: "052030", output: "0530")]

		for date in testDates3 {
			textField.setText(date.input)
			if let outputText = textField.getOutputText() {
				XCTAssertTrue(outputText == date.output, "Expiration date convert error:\n - Input: \(date.input)\n - Output: \(date.output)\n - Result: \(outputText)")
			} else {
				print("failed: \(date.input) \(date.output)")
			}
      XCTAssertTrue(textField.state.isValid, "Expiration date state error:\n - Input: \(date.input) should be valid!")
		}
	}
  
  func testConvertExpDate4() {
    var fieldOptions = VGSCheckoutExpirationDateOptions()
    fieldOptions.outputDateFormat = .longYear
    
    let config = VGSExpDateConfiguration(checkoutExpDateOptions: fieldOptions, collect: collector)
    config.divider = "-/-"
    // Update validation rules
    let expDateValidationRule = VGSValidationRuleCardExpirationDate(dateFormat: fieldOptions.inputDateFormat,
                                                                    error: VGSValidationErrorType.expDate.rawValue)
    config.validationRules = VGSValidationRuleSet(rules: [expDateValidationRule])
    textField.configuration = config

		let testDates4: [TestDataType] = [TestDataType(input: "12-/-25", output: "12-/-2025"),
																			TestDataType(input: "01-/-30", output: "01-/-2030"),
																			TestDataType(input: "05-/-41", output: "05-/-2041")]
    
    for date in testDates4 {
			textField.setText(date.input)
			if let outputText = textField.getOutputText() {
				XCTAssertTrue(outputText == date.output, "Expiration date convert error:\n - Input: \(date.input)\n - Output: \(date.output)\n - Result: \(outputText)")
			} else {
				print("failed: \(date.input) \(date.output)")
			}
      XCTAssertTrue(textField.state.isValid, "Expiration date state error:\n - Input: \(date.input) should be valid!")
    }
  }
  
  func testConvertExpDate5() {
    var fieldOptions = VGSCheckoutExpirationDateOptions()
    fieldOptions.inputDateFormat = .shortYear
    fieldOptions.outputDateFormat = .shortYearThenMonth
    
    let config = VGSExpDateConfiguration(checkoutExpDateOptions: fieldOptions, collect: collector)
    config.divider = "-/-"
    // Update validation rules
    let expDateValidationRule = VGSValidationRuleCardExpirationDate(dateFormat: fieldOptions.inputDateFormat,
                                                                    error: VGSValidationErrorType.expDate.rawValue)
    config.validationRules = VGSValidationRuleSet(rules: [expDateValidationRule])
    textField.configuration = config

    let testDates5: [TestDataType] = [TestDataType(input: "12-/-41", output: "41-/-12"),
                                      TestDataType(input: "01-/-30", output: "30-/-01"),
                                      TestDataType(input: "05-/-41", output: "41-/-05")]
    
    for date in testDates5 {
      textField.setText(date.input)
      if let outputText = textField.getOutputText() {
        XCTAssertTrue(outputText == date.output, "Expiration date convert error:\n - Input: \(date.input)\n - Output: \(date.output)\n - Result: \(outputText)")
      } else {
        print("failed: \(date.input) \(date.output)")
      }
      XCTAssertTrue(textField.state.isValid, "Expiration date state error:\n - Input: \(date.input) should be valid!")
    }
  }
  
  func testConvertExpDate6() {
    var fieldOptions = VGSCheckoutExpirationDateOptions()
    fieldOptions.inputDateFormat = .shortYear
    fieldOptions.outputDateFormat = .longYearThenMonth
    
    let config = VGSExpDateConfiguration(checkoutExpDateOptions: fieldOptions, collect: collector)
    config.divider = "../"
    // Update validation rules
    let expDateValidationRule = VGSValidationRuleCardExpirationDate(dateFormat: fieldOptions.inputDateFormat,
                                                                    error: VGSValidationErrorType.expDate.rawValue)
    config.validationRules = VGSValidationRuleSet(rules: [expDateValidationRule])
    textField.configuration = config

    let testDates6: [TestDataType] = [TestDataType(input: "12../25", output: "2025../12"),
                                      TestDataType(input: "01../30", output: "2030../01"),
                                      TestDataType(input: "05../25", output: "2025../05")]
    
    for date in testDates6 {
      textField.setText(date.input)
      if let outputText = textField.getOutputText() {
        XCTAssertTrue(outputText == date.output, "Expiration date convert error:\n - Input: \(date.input)\n - Output: \(date.output)\n - Result: \(outputText)")
      } else {
        print("failed: \(date.input) \(date.output)")
      }
      XCTAssertTrue(textField.state.isValid, "Expiration date state error:\n - Input: \(date.input) should be valid!")
    }
  }
  
  func testConvertExpDate7() {
    var fieldOptions = VGSCheckoutExpirationDateOptions()
    fieldOptions.inputDateFormat = .longYear
    fieldOptions.outputDateFormat = .shortYearThenMonth
    
    let config = VGSExpDateConfiguration(checkoutExpDateOptions: fieldOptions, collect: collector)
    // Update validation rules
    let expDateValidationRule = VGSValidationRuleCardExpirationDate(dateFormat: fieldOptions.inputDateFormat,
                                                                    error: VGSValidationErrorType.expDate.rawValue)
    config.validationRules = VGSValidationRuleSet(rules: [expDateValidationRule])
    textField.configuration = config

    let testDates7: [TestDataType] = [TestDataType(input: "122025", output: "25/12"),
                                      TestDataType(input: "012030", output: "30/01"),
                                      TestDataType(input: "052025", output: "25/05")]
    
    for date in testDates7 {
      textField.setText(date.input)
      if let outputText = textField.getOutputText() {
        XCTAssertTrue(outputText == date.output, "Expiration date convert error:\n - Input: \(date.input)\n - Output: \(date.output)\n - Result: \(outputText)")
      } else {
        print("failed: \(date.input) \(date.output)")
      }
      XCTAssertTrue(textField.state.isValid, "Expiration date state error:\n - Input: \(date.input) should be valid!")
    }
  }
  
  func testConvertExpDate8() {
    var fieldOptions = VGSCheckoutExpirationDateOptions()
    fieldOptions.inputDateFormat = .longYear
    fieldOptions.outputDateFormat = .longYearThenMonth
    
    let config = VGSExpDateConfiguration(checkoutExpDateOptions: fieldOptions, collect: collector)
    config.formatPattern = "##-####"
    // Update validation rules
    let expDateValidationRule = VGSValidationRuleCardExpirationDate(dateFormat: fieldOptions.inputDateFormat,
                                                                    error: VGSValidationErrorType.expDate.rawValue)
    config.validationRules = VGSValidationRuleSet(rules: [expDateValidationRule])
    textField.configuration = config
    

    let testDates8: [TestDataType] = [TestDataType(input: "12 2025", output: "2025/12"),
                                      TestDataType(input: "01 2030", output: "2030/01"),
                                      TestDataType(input: "05 2025", output: "2025/05")]
    
    for date in testDates8 {
      textField.setText(date.input)
      if let outputText = textField.getOutputText() {
        XCTAssertTrue(outputText == date.output, "Expiration date convert error:\n - Input: \(date.input)\n - Output: \(date.output)\n - Result: \(outputText)")
      } else {
        print("failed: \(date.input) \(date.output)")
      }
      XCTAssertTrue(textField.state.isValid, "Expiration date state error:\n - Input: \(date.input) should be valid!")
    }
  }
  
  func testConvertExpDate9() {
    var fieldOptions = VGSCheckoutExpirationDateOptions()
    fieldOptions.inputDateFormat = .shortYearThenMonth
    fieldOptions.outputDateFormat = .longYearThenMonth
    
    let config = VGSExpDateConfiguration(checkoutExpDateOptions: fieldOptions, collect: collector)
    // Update validation rules
    let expDateValidationRule = VGSValidationRuleCardExpirationDate(dateFormat: fieldOptions.inputDateFormat,
                                                                    error: VGSValidationErrorType.expDate.rawValue)
    config.validationRules = VGSValidationRuleSet(rules: [expDateValidationRule])
    textField.configuration = config
    
    let testDates9: [TestDataType] = [TestDataType(input: "2512", output: "2025/12"),
                                      TestDataType(input: "3001", output: "2030/01"),
                                      TestDataType(input: "2505", output: "2025/05")]
    
    for date in testDates9 {
      textField.setText(date.input)
      if let outputText = textField.getOutputText() {
        XCTAssertTrue(outputText == date.output, "Expiration date convert error:\n - Input: \(date.input)\n - Output: \(date.output)\n - Result: \(outputText)")
      } else {
        print("failed: \(date.input) \(date.output)")
      }
      XCTAssertTrue(textField.state.isValid, "Expiration date state error:\n - Input: \(date.input) should be valid!")
    }
  }
  
  func testConvertExpDate10() {
    var fieldOptions = VGSCheckoutExpirationDateOptions()
    fieldOptions.inputDateFormat = .longYearThenMonth
    fieldOptions.outputDateFormat = .shortYearThenMonth
    
    let config = VGSExpDateConfiguration(checkoutExpDateOptions: fieldOptions, collect: collector)
    config.formatPattern = "####---##"
    // Update validation rules
    let expDateValidationRule = VGSValidationRuleCardExpirationDate(dateFormat: fieldOptions.inputDateFormat,
                                                                    error: VGSValidationErrorType.expDate.rawValue)
    config.validationRules = VGSValidationRuleSet(rules: [expDateValidationRule])
    textField.configuration = config
    
    let testDates10: [TestDataType] = [TestDataType(input: "202512", output: "25///12"),
                                      TestDataType(input: "203001", output: "30///01"),
                                      TestDataType(input: "202505", output: "25///05")]
    
    for date in testDates10 {
      textField.setText(date.input)
      if let outputText = textField.getOutputText() {
        XCTAssertTrue(outputText == date.output, "Expiration date convert error:\n - Input: \(date.input)\n - Output: \(date.output)\n - Result: \(outputText)")
      } else {
        print("failed: \(date.input) \(date.output)")
      }
      XCTAssertTrue(textField.state.isValid, "Expiration date state error:\n - Input: \(date.input) should be valid!")
    }
  }
  
  func testConvertExpDate11() {
    var fieldOptions = VGSCheckoutExpirationDateOptions()
    fieldOptions.inputDateFormat = .shortYearThenMonth
    fieldOptions.outputDateFormat = .shortYear
    
    let config = VGSExpDateConfiguration(checkoutExpDateOptions: fieldOptions, collect: collector)
    // Update validation rules
    let expDateValidationRule = VGSValidationRuleCardExpirationDate(dateFormat: fieldOptions.inputDateFormat,
                                                                    error: VGSValidationErrorType.expDate.rawValue)
    config.validationRules = VGSValidationRuleSet(rules: [expDateValidationRule])
    textField.configuration = config

    let testDates11: [TestDataType] = [TestDataType(input: "25/12", output: "12/25"),
                                      TestDataType(input: "30/01", output: "01/30"),
                                      TestDataType(input: "41/05", output: "05/41")]
    
    for date in testDates11 {
      textField.setText(date.input)
      if let outputText = textField.getOutputText() {
        XCTAssertTrue(outputText == date.output, "Expiration date convert error:\n - Input: \(date.input)\n - Output: \(date.output)\n - Result: \(outputText)")
      } else {
        print("failed: \(date.input) \(date.output)")
      }
      XCTAssertTrue(textField.state.isValid, "Expiration date state error:\n - Input: \(date.input) should be valid!")
    }
  }
  
  func testConvertExpDate12() {
    var fieldOptions = VGSCheckoutExpirationDateOptions()
    fieldOptions.inputDateFormat = .longYearThenMonth
    fieldOptions.outputDateFormat = .longYear
    
    let config = VGSExpDateConfiguration(checkoutExpDateOptions: fieldOptions, collect: collector)
    config.formatPattern = "#### ##"
    config.divider = "."
    
    // Update validation rules
    let expDateValidationRule = VGSValidationRuleCardExpirationDate(dateFormat: fieldOptions.inputDateFormat,
                                                                    error: VGSValidationErrorType.expDate.rawValue)
    config.validationRules = VGSValidationRuleSet(rules: [expDateValidationRule])
    textField.configuration = config
    
    let testDates11: [TestDataType] = [TestDataType(input: "202512", output: "12.2025"),
                                       TestDataType(input: "203001", output: "01.2030"),
                                       TestDataType(input: "202505", output: "05.2025")]
    
    for date in testDates11 {
      textField.setText(date.input)
      if let outputText = textField.getOutputText() {
        XCTAssertTrue(outputText == date.output, "Expiration date convert error:\n - Input: \(date.input)\n - Output: \(date.output)\n - Result: \(outputText)")
      } else {
        print("failed: \(date.input) \(date.output)")
      }
      XCTAssertTrue(textField.state.isValid, "Expiration date state error:\n - Input: \(date.input) should be valid!")
    }
  }
}
