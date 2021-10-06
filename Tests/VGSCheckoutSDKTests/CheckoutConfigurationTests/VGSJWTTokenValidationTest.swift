//
//  VGSJWTTokenValidationTest.swift
//  VGSCheckoutSDKTests
//

import Foundation
import XCTest
@testable import VGSCheckoutSDK

/// Test payment orchestration token
class VGSJWTTokenValidationTest: VGSCheckoutBaseTestCase {
    /// VaultId  used in JWT token
    let vaultId = "tntxxxxxxx"
    
    func testValidJWTTokenReturnsTrue() {
        let multiplexingConfig = VGSCheckoutMultiplexingConfiguration(vaultID: vaultId, token: validJWTToken, environment: "sandbox")
        XCTAssertTrue(multiplexingConfig != nil, "ERROR: MultiplexingConfig init failed with valid JWT token")
    }
    
    func testInvalidJWTTokenScopeReturnsFalse() {
        let multiplexingConfig = VGSCheckoutMultiplexingConfiguration(vaultID: vaultId, token: invalidScopeJWTToken, environment: "sandbox")
        XCTAssertTrue(multiplexingConfig == nil, "ERROR: MultiplexingConfig init with invalid JWT token")
    }
    
    func testInvalidJWTTokenReturnsFalse() {
        for token in invalidJWTTokens {
            let multiplexingConfig = VGSCheckoutMultiplexingConfiguration(vaultID: vaultId, token: token, environment: "sandbox")
            XCTAssertTrue(multiplexingConfig == nil, "ERROR: MultiplexingConfig init with empty JWT token")
        }
    }
}

/// Test data
extension VGSJWTTokenValidationTest {
    
    var invalidJWTTokens: [String] {
        return ["", vaultId, "verygoodsecurity.com"]
    }
    
    var invalidScopeJWTToken: String {
      // swiftlint:disable:next line_length
      return  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MzA1MjIyODcsImlhdCI6MTYzMDUyMTk4NywianRpIjoiNWVjZGVyMzItOWM2My00YzAyLWE1MjMtYWE4MjRjYzI3NDRjIiwiaXNzIjoiaHR0cHM6Ly9hdXRoLnZlcnlnb29kc2VjdXJpdHkuY29tL2F1dGgvcmVhbG1zL3ZncyIsImF1ZCI6Im11bHRpcGxleGluZy1hcHAtdG50c2htbGpsYTciLCJzdWIiOiI3ZmZmZDFkZS1hM2UyLTRkMDAtYjAzZi00Mjg4MjJhMmFlOWYiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJtdWx0aXBsZXhpbmctYXBwLXRudHh4eHh4eHgtVVM2YmRQR3BGaGhqYml0eVFQd3JrZWNOIiwic2Vzc2lvbl9zdGF0ZSI6IjQzMTJkODcyLTNmZWUtNDlhMy05OGNmLTc1YjAwMDA5N2U0NiIsImFjciI6IjEiLCJyZXNvdXJjZV9hY2Nlc3MiOnsibXVsdGlwbGV4aW5nLWFwcC10bnR4eHh4eHh4Ijp7InJvbGVzIjpbImZpbmFuY2lhbC1pbnN0cnVtZW50czp3cml0ZSIsInRyYW5zZmVyczp3cml0ZSJdfSwibXVsdGlwbGV4aW5nLWFwcC10bnR5eXl5eXkiOnsicm9sZXMiOlsiZmluYW5jaWFsLWluc3RydW1lbnRzOndyaXRlIl19fSwic2NvcGUiOiJ1c2VyX2lkIHNlcnZpY2UtYWNjb3VudCIsInNlcnZpY2VfYWNjb3VudCI6dHJ1ZSwiY2xpZW50SWQiOiJtdWx0aXBsZXhpbmctYXBwLXRudHh4eHh4eHgtVVM2YmRQR3BGaGhqYml0eVFQd3JrZWNOIiwiY2xpZW50SG9zdCI6IjE3Ni4xMDAuMTA1LjIzNSIsImNsaWVudEFkZHJlc3MiOiIxNzYuMTAwLjEwNS4yMzUifQ.kcuPjn4oTRLf_ZIHAlhX-WArn-r6JL24WBPvfo5J3uE"
    }
  
    var validJWTToken: String {
      // swiftlint:disable:next line_length
      return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MzA1MjIyODcsImlhdCI6MTYzMDUyMTk4NywianRpIjoiNWVjZGVyMzItOWM2My00YzAyLWE1MjMtYWE4MjRjYzI3NDRjIiwiaXNzIjoiaHR0cHM6Ly9hdXRoLnZlcnlnb29kc2VjdXJpdHkuY29tL2F1dGgvcmVhbG1zL3ZncyIsImF1ZCI6Im11bHRpcGxleGluZy1hcHAtdG50c2htbGpsYTciLCJzdWIiOiI3ZmZmZDFkZS1hM2UyLTRkMDAtYjAzZi00Mjg4MjJhMmFlOWYiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJtdWx0aXBsZXhpbmctYXBwLXRudHh4eHh4eHgtVVM2YmRQR3BGaGhqYml0eVFQd3JrZWNOIiwic2Vzc2lvbl9zdGF0ZSI6IjQzMTJkODcyLTNmZWUtNDlhMy05OGNmLTc1YjAwMDA5N2U0NiIsImFjciI6IjEiLCJyZXNvdXJjZV9hY2Nlc3MiOnsibXVsdGlwbGV4aW5nLWFwcC10bnR4eHh4eHh4Ijp7InJvbGVzIjpbImZpbmFuY2lhbC1pbnN0cnVtZW50czp3cml0ZSJdfSwibXVsdGlwbGV4aW5nLWFwcC10bnR5eXl5eXl5Ijp7InJvbGVzIjpbImZpbmFuY2lhbC1pbnN0cnVtZW50czp3cml0ZSIsInRlc3Q6dGVzdCJdfX0sInNjb3BlIjoidXNlcl9pZCBzZXJ2aWNlLWFjY291bnQiLCJzZXJ2aWNlX2FjY291bnQiOnRydWUsImNsaWVudElkIjoibXVsdGlwbGV4aW5nLWFwcC10bnR4eHh4eHh4LVVTNmJkUEdwRmhoamJpdHlRUHdya2VjTiIsImNsaWVudEhvc3QiOiIxNzYuMTAwLjEwNS4yMzUiLCJjbGllbnRBZGRyZXNzIjoiMTc2LjEwMC4xMDUuMjM1In0.9UkqDWmw2ga_7nh5qB7Rj7yuXTLNNITUxIjk-e4YO1s"
    }
}
