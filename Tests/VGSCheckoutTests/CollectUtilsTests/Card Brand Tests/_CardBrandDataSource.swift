//
//  _CardBrandDataSource.swift
//  VGSCheckout

import Foundation
@testable import VGSCheckout

extension VGSCheckoutPaymentCards.CardBrand {
    
    var cardNumbers: [String] {
        switch self {
        case .amex:
            return [
                "340000099900036",
                "340000099900028",
                "340000099900044",
                "340000099900051",
                "343434343434343",
                "378282246310005",
                "371449635398431",
                "378734493671000",
                "370000000000002",
                "370000000100018"
            ]
        case .visaElectron:
            return [
                "4917300800000000",
                "4917300000000008"
            ]
        case .visa:
            return [
                "4000020000000000",
                "4000060000000006",
                "4000160000000004",
                "4000180000000002",
                "4000620000000007",
                "4000640000000005",
                "4000760000000001",
                "4002690000000008",
                "4003550000000003",
                "4005519000000006",
                "4017340000000003",
                "4035501000000008",
                "4111111111111111",
                "4111111145551142",
                "4131840000000003",
                "4151500000000008",
                "4166676667666746",
                "4199350000000002",
                "4293189100000008",
                "4400000000000008",
                "4444333322221111",
                "4484600000000004",
                "4571000000000001",
                "4607000000000009",
                "4646464646464644",
                "4977949494949497",
                "4988080000000000",
                "4988438843884305",
                "4462030000000000",
                "4242424242424242",
                "4444333322221111455",
                "4761000000000001"
            ]
        case .mastercard:
            return [
                "2222400010000008",
                "2222400030000004",
                "2222400050000009",
                "2222400060000007",
                "2222400070000005",
                "2222410700000002",
                "2222410740360010",
                "2223000048410010",
                "2223520443560010",
                "5100060000000002",
                "5100290029002909",
                "5100705000000002",
                "5101180000000007",
                "5103221911199245",
                "5106040000000008",
                "5136333333333335",
                "5424000000000015",
                "5500000000000004",
                "5555341244441115",
                "5555444433331111",
                "5555555555554444",
                "5577000055770004",
                "5585558555855583",
                "5454545454545454"
            ]
        case .discover:
            return [
                "6011000400000000",
                "6011100099900013",
                "6011111111111117",
                "6011000990139424",
                "6011601160116611",
                "6445644564456445"
            ]
        case .dinersClub:
            return [
                "30599900026332",
                "30599900026340",
                "38520000023237",
                "30569309025904",
                "36006666333344",
                "36070500001020",
                "36700102000000",
                "36148900647913",
                "3096000032340126",
                "3056930009020004"
            ]
        case .jcb:
            return [
                "3569990010095841",
                "3530111333300000",
                "3566002020360505",
                "3569990010030400"
            ]
        case .maestro:
            return [
                "6759649826438453",
                "6771798021000008",
                "6771798025000004",
                "6759156019808393",
                "6761000000000006",
                "5020620000000000",
                "6771830000000000006",
                "5611111111111113",
                "5711111111111112",
                "5811111111111111"
            ]
        case .unionpay:
            return [
                "6212345678901265",
                "6212345678901232",
                "62123456789000003",
                "621234567890000002",
                "6212345678900000003"
          ]
        case .dankort:
          return [
                "5019555544445555",
                "5019717010103742",
                "5019346126415137"]
        case .forbrugsforeningen:
          return [
                "6007220000000004"]
        case .elo:
          return [
                "6362970000457013",
                "5066991111111118",
                "6362970000457013"]
        case .hipercard:
          return [
                "6062826786276634",
                "6062828888666688"]
        case .unknown:
            return []
        case .custom(brandName:_):
          return []
      }
    }
  
  var firsDigitsInCardNumber: [String] {
      switch self {
      case .amex:
          return [
              "34", "37", "341", "379"
          ]
      case .visaElectron:
          return [
              "4026",
              "417500",
              "4405",
              "4508",
              "4844",
              "4913",
              "4917",
              "40261",
              "491790"
          ]
      case .visa:
          return [
              "4", "41", "40", "49"
          ]
      case .mastercard:
          return [
              "51", "52", "53",
              "54", "55",
              "222123", "22223456", "271923",
              "272000"
          ]
      case .discover:
          return [
              "6011", "65", "644",
              "645", "646", "647",
              "648", "649", "622",
              "60110", "659", "6456"
          ]
      case .dinersClub:
          return [
              "305", "300", "309",
              "36", "38", "39",
              "3000", "366", "391"
          ]
      case .jcb:
          return [
              "35", "350", "359"
          ]
      case .maestro:
          return [
              "6701234", "6790000",
              "6390012", "639099",
              "50181", "50201",
              "5018", "5020",
              "5038", "56", "57", "58"
          ]
      case .unionpay:
        return ["62", "621", "629", "620"]
      case .forbrugsforeningen:
        return ["600", "6001", "6009"]
      case .dankort:
        return ["5019", "50191", "50199"]
      case .elo:
        return ["401178", "4011789", "627780", "6277800"]
      case .hipercard:
        return ["384100", "3841009", "606282", "6062820", "637568"]
      case .unknown:
          return []
      case .custom(brandName: _):
          return []
    }
  }
}

extension VGSCheckoutPaymentCards {
    
    static var specificNotValidCardNumbers: [String] {
        return [
          "4",
          "41",
          "411",
          "4111",
          "41111",
          "411111",
          "4111111",
          "41111111",
          "411111111",
          "4111111111",
          "41111111111",
          "411111111111",
          "4111111111111",
          "41111111111111",
          "411111111111111",
          "0000000000000000",
          "1111111111111111",
          "2222222222222222",
          "3333333333333333",
          "4444444444444444",
          "5555555555555555",
          "6666666666666666",
          "7777777777777777",
          "8888888888888888",
          "9999999999999999",
          "1234123412342134",
          "1234567890000000",
          "0987654321111111",
          "4111111o1111111",
          "34000000000000000",
          "3400000000000000",
          "340000000000000",
          "601100040000000",
          "5555555555" ]
    }
}
