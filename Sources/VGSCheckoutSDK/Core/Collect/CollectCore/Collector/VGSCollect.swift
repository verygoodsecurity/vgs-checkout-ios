//
//  VGSForm.swift
//  VGSCheckoutSDK
//


import Foundation
#if os(iOS)
import UIKit
#endif

/// An object you use for observing `VGSTextField` `State` and send data to your organization vault.
internal class VGSCollect {
    internal let apiClient: APIClient
    internal let storage = Storage()
    internal let regionalEnvironment: String
    internal let tenantId: String

	  /// :nodoc: Form analytics details.
    internal (set) public var formAnalyticsDetails: VGSCheckoutFormAnanlyticsDetails
  
    /// Max file size limit by proxy. Is static and can't be changed!
    internal let maxFileSizeInternalLimitInBytes = 24_000_000
    /// Unique form identifier.
    internal let formId = UUID().uuidString
      
    // MARK: Custom HTTP Headers
    
    /// Set your custom HTTP headers.
    internal var customHeaders: [String: String]? {
        didSet {
            if customHeaders != oldValue {
                apiClient.customHeader = customHeaders
            }
        }
    }
    
    // MARK: Observe VGSTextField states
    
    /// Observe only focused `VGSTextField` on editing events.
		internal var observeFieldState: ((_ textField: VGSTextField) -> Void)?
    
    /// Observe  all `VGSTextField` on editing events.
		internal var observeStates: ((_ form: [VGSTextField]) -> Void)?
  
    // MARK: Get Registered VGSTextFields
    
    /// Returns array of `VGSTextField`s associated with `VGSCollect` instance.
    internal var textFields: [VGSTextField] {
      return storage.textFields
    }
  
    // MARK: - Initialzation
    
    /// Initialzation.
    ///
    /// - Parameters:
    ///   - id: `String` object, your organization vault id.
    ///   - environment: `String` object, your organization vault environment with data region.(e.g. "live", "live-eu1", "sandbox").
    ///   - routeId: `String?` object, inbound route id or `nil`.
    ///   - hostname: `String?` object, custom Hostname, if not set, data will be sent to Vault Url. Default is `nil`.
	  ///   - satellitePort: `Int?` object, custom port for satellite configuration.  Default is `nil`. **IMPORTANT! Use only with .sandbox environment! Hostname should be specified for valid http://localhost or in local IP format  http://192.168.X.X**.
  internal init(id: String, environment: String, routeId: String? = nil, hostname: String? = nil, satellitePort: Int? = nil) {
      self.tenantId = id
      self.regionalEnvironment = environment
    self.formAnalyticsDetails = VGSCheckoutFormAnanlyticsDetails(formId: formId, tenantId: tenantId, environment: regionalEnvironment, routeId: routeId)
    self.apiClient = APIClient(tenantId: id, regionalEnvironment: environment, routeId: routeId, hostname: hostname, formAnalyticsDetails: formAnalyticsDetails, satellitePort: satellitePort)

			if case .satelliteURL = self.apiClient.hostURLPolicy {
				self.formAnalyticsDetails.isSatelliteMode = true
			}
    }
      
    /// Initialzation.
    ///
    /// - Parameters:
    ///   - id: `String` object, your organization vault id.
    ///   - environment: `Environment` object, your organization vault environment. By default `Environment.sandbox`.
    ///   - routeId: `String?` object, inbound route id or `nil`.
    ///   - dataRegion: `String` object, id of data storage region (e.g. "eu-123").
    ///   - hostname: `String` object, custom Hostname, if not set, data will be sent to Vault Url. Default is `nil`.
	  ///   - satellitePort: `Int?` object, custom port for satellite configuration. Default is `nil`. **IMPORTANT! Use only with .sandbox environment! Hostname should be specified for valid http://localhost or in local IP format http://192.168.X.X**.
  internal convenience init(id: String, environment: Environment = .sandbox, routeId: String? = nil, dataRegion: String? = nil, hostname: String? = nil, satellitePort: Int? = nil) {
      let env = Self.generateRegionalEnvironmentString(environment, region: dataRegion)
    self.init(id: id, environment: env, routeId: routeId, hostname: hostname, satellitePort: satellitePort)
    }

    // MARK: - Manage VGSTextFields
    
    /// Returns `VGSTextField` with `VGSConfiguration.fieldName` associated with `VGCollect` instance.
	internal func getTextField(fieldName: String) -> VGSTextField? {
        return storage.textFields.first(where: { $0.fieldName == fieldName })
    }
  
    /// Unasubscribe `VGSTextField` from `VGSCollect` instance.
    ///
    /// - Parameters:
    ///   - textField: `VGSTextField` that should be unsubscribed.
	internal func unsubscribeTextField(_ textField: VGSTextField) {
      self.unregisterTextFields(textField: [textField])
    }
  
    /// Unasubscribe `VGSTextField`s from `VGSCollect` instance.
    ///
    /// - Parameters:
    ///   - textFields: an array of `VGSTextField`s that should be unsubscribed.
	internal func unsubscribeTextFields(_ textFields: [VGSTextField]) {
      self.unregisterTextFields(textField: textFields)
    }
  
    /// Unasubscribe  all `VGSTextField`s from `VGSCollect` instance.
	internal func unsubscribeAllTextFields() {
      self.unregisterAllTextFields()
    }
  
    // MARK: - Manage Files
  
    /// Detach files for associated `VGSCollect` instance.
	internal func cleanFiles() {
      self.unregisterAllFiles()
    }
}
