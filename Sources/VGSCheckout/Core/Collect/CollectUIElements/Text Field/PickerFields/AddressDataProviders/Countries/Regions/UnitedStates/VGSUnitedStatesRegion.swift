//
//  VGSUnitedStatesRegion.swift
//  VGSCheckout

import Foundation

internal enum VGSUnitedStatesRegion : String, CaseIterable {
		case alabama            = "AL"
		case alaska             = "AK"
		case arizona            = "AZ"
		case arkansas           = "AR"
		case california         = "CA"
		case colorado           = "CO"
		case connecticut        = "CT"
		case delaware           = "DE"
		case districtOfColumbia = "DC"
		case florida            = "FL"
		case georgia            = "GA"
		case hawaii             = "HI"
		case idaho              = "ID"
		case illinois           = "IL"
		case indiana            = "IN"
		case iowa               = "IA"
		case kansas             = "KS"
		case kentucky           = "KY"
		case louisiana          = "LA"
		case maine              = "ME"
		case maryland           = "MD"
		case massachusetts      = "MA"
		case michigan           = "MI"
		case minnesota          = "MN"
		case mississippi        = "MS"
		case missouri           = "MO"
		case montana            = "MT"
		case nebraska           = "NE"
		case nevada             = "NV"
		case newHampshire       = "NH"
		case newJersey          = "NJ"
		case newMexico          = "NM"
		case newYork            = "NY"
		case northCarolina      = "NC"
		case northDakota        = "ND"
		case ohio               = "OH"
		case oklahoma           = "OK"
		case oregon             = "OR"
		case pennsylvania       = "PA"
		case rhodeIsland        = "RI"
		case southCarolina      = "SC"
		case southDakota        = "SD"
		case tennessee          = "TN"
		case texas              = "TX"
		case utah               = "UT"
		case vermont            = "VT"
		case virginia           = "VA"
		case washington         = "WA"
		case westVirginia       = "WV"
		case wisconsin          = "WI"
		case wyoming            = "WY"

		var displayName: String {
				switch self {
				case .alabama: return NSLocalizedString("Alabama", comment: "")
				case .alaska: return NSLocalizedString("Alaska", comment: "")
				case .arizona: return NSLocalizedString("Arizona", comment: "")
				case .arkansas: return NSLocalizedString("Arkansas", comment: "")
				case .california: return NSLocalizedString("California", comment: "")
				case .colorado: return NSLocalizedString("Colorado", comment: "")
				case .connecticut: return NSLocalizedString("Connecticut", comment: "")
				case .delaware: return NSLocalizedString("Delaware", comment: "")
				case .districtOfColumbia: return NSLocalizedString("District of Columbia", comment: "")
				case .florida: return NSLocalizedString("Florida", comment: "")
				case .georgia: return NSLocalizedString("Georgia", comment: "")
				case .hawaii: return NSLocalizedString("Hawaii", comment: "")
				case .idaho: return NSLocalizedString("Idaho", comment: "")
				case .illinois: return NSLocalizedString("Illinois", comment: "")
				case .indiana: return NSLocalizedString("Indiana", comment: "")
				case .iowa: return NSLocalizedString("Iowa", comment: "")
				case .kansas: return NSLocalizedString("Kansas", comment: "")
				case .kentucky: return NSLocalizedString("Kentucky", comment: "")
				case .louisiana: return NSLocalizedString("Louisiana", comment: "")
				case .maine: return NSLocalizedString("Maine", comment: "")
				case .maryland: return NSLocalizedString("Maryland", comment: "")
				case .massachusetts: return NSLocalizedString("Massachusetts", comment: "")
				case .michigan: return NSLocalizedString("Michigan", comment: "")
				case .minnesota: return NSLocalizedString("Minnesota", comment: "")
				case .mississippi: return NSLocalizedString("Mississippi", comment: "")
				case .missouri: return NSLocalizedString("Missouri", comment: "")
				case .montana: return NSLocalizedString("Montana", comment: "")
				case .nebraska: return NSLocalizedString("Nebraska", comment: "")
				case .nevada: return NSLocalizedString("Nevada", comment: "")
				case .newHampshire: return NSLocalizedString("New Hampshire", comment: "")
				case .newJersey: return NSLocalizedString("New Jersey", comment: "")
				case .newMexico: return NSLocalizedString("New Mexico", comment: "")
				case .newYork: return NSLocalizedString("New York", comment: "")
				case .northCarolina: return NSLocalizedString("North Carolina", comment: "")
				case .northDakota: return NSLocalizedString("North Dakota", comment: "")
				case .ohio: return NSLocalizedString("Ohio", comment: "")
				case .oklahoma: return NSLocalizedString("Oklahoma", comment: "")
				case .oregon: return NSLocalizedString("Oregon", comment: "")
				case .pennsylvania: return NSLocalizedString("Pennsylvania", comment: "")
				case .rhodeIsland: return NSLocalizedString("Rhode Island", comment: "")
				case .southCarolina: return NSLocalizedString("South Carolina", comment: "")
				case .southDakota: return NSLocalizedString("South Dakota", comment: "")
				case .tennessee: return NSLocalizedString("Tennessee", comment: "")
				case .texas: return NSLocalizedString("Texas", comment: "")
				case .utah: return NSLocalizedString("Utah", comment: "")
				case .vermont: return NSLocalizedString("Vermont", comment: "")
				case .virginia: return NSLocalizedString("Virginia", comment: "")
				case .washington: return NSLocalizedString("Washington", comment: "")
				case .westVirginia: return NSLocalizedString("West Virginia", comment: "")
				case .wisconsin: return NSLocalizedString("Wisconsin", comment: "")
				case .wyoming: return NSLocalizedString("Wyoming", comment: "")
				}
		}
}
