//
//  VGSCheckoutSDKFormAnanlyticsDetails.swift
//  VGSCheckoutSDK
//
//  Created by Dima on 26.11.2020.
//  Copyright © 2020 VGS. All rights reserved.
//

import Foundation

///:nodoc:  VGSCheckout Form Analytics Details
internal struct VGSCheckoutFormAnanlyticsDetails {
  public let formId: String
  public let tenantId: String
  public let environment: String
  public let routeId: String?
	internal (set) public var isSatelliteMode: Bool = false

  public init(formId: String, tenantId: String, environment: String, routeId: String?, isSatelliteMode: Bool = false) {
		self.formId = formId
		self.tenantId = tenantId
		self.environment = environment
    self.routeId = routeId
		self.isSatelliteMode
		 = isSatelliteMode
	}
}
