//
//  _CountryISOPostalCodes.swift
//  VGSCheckoutTests
//

import Foundation
@testable import VGSCheckout

extension VGSCountriesISO {
    
    var validPostalCodes: [String] {
        switch self {
        case .us:
            return [
                "36104",
                "99801",
                "85001",
                "72201",
                "06103",
                "19901",
                "02201",
                "04330",
                "55102",
                "00802",
                "00901"
            ]
        case .ca:
            return [
              "C0B7V4",
              "E7G9G2",
              "T1G6H3",
              "T4J 4L7",
              "H4C 9C6",
              "T7S 7L5"
          ]
        case .gb:
          // source https://en.wikipedia.org/wiki/Postcodes_in_the_United_Kingdom
          return [
            "SW1W 0NY",
            "DN55 1PT",
            "PO16 7GZ",
            "GU16 7HF",
            "CR2 6XH",
            "B33 8TH",
            "W1A 0AX",
            "M1 1AE",
            "L1 8JQ"
            ]
        case .au:
          return ["1000",
                  "6797",
                  "9999",
                  "0200",
                  "0900"
          ]
        case .nz:
          return ["1023",
                  "4774",
                  "5040",
                  "7843",
                  "9302"]
        default:
          return [String]()
        }
    }
  
    var invalidPostalCodes: [String] {
        switch self {
        case .us:
            return [
                "C0B7V4",
                "T7S 7L5",
                "361044",
                "3610",
                "1",
                "12",
                "a"
            ]
        case .ca:
            return [
              "72201",
              "1000",
              "T4J",
              "H4C 9C",
              "1",
              "12",
              "a"
          ]
        case .gb:
          // source https://en.wikipedia.org/wiki/Postcodes_in_the_United_Kingdom
          return [
            ""
            ]
        case .au, .nz:
          return ["SW1W 0NY",
                  "36104",
                  "361",
                  "1",
                  "12",
                  "a"
          ]
        default:
          return [String]()
        }
    }
}
