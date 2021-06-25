//
//  LuhnTests.swift
//  VGSCheckoutTests

import XCTest
@testable import VGSCheckout

class LuhnTests: VGSCheckoutBaseTestCase {
    var textField: VGSTextField!
    let cardNumer = "4111111111111111"
    
    override func setUp() {
			  super.setUp()
        textField = VGSTextField(frame: .zero)
    }

    override func tearDown() {
        textField = nil
    }

    func test1() {
        XCTAssert(VGSCheckoutPaymentCards.detectCardBrandFromAvailableCards(input: cardNumer) == .visa)
    }

    func test4() {
      XCTAssertTrue(VGSCheckoutCheckSumAlgorithmType.luhn.validate(cardNumer))
    }
    
    func test5() {
        let cardBrand = VGSCheckoutPaymentCards.detectCardBrandFromAvailableCards(input: cardNumer)
        XCTAssert(cardBrand.stringValue.lowercased() == "visa")
    }
}
