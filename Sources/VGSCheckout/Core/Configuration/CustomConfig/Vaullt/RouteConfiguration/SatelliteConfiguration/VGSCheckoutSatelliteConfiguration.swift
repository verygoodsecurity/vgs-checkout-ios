//
//  VGSCheckoutSatelliteConfiguration.swift
//  VGSCheckout

import Foundation

/// Holds configuration for local testing with VGS Satellite.
public struct VGSCheckoutSatelliteConfiguration {
	/**
	Satellite localhost. IMPORTANT! Use only with .sandbox environment! Should be specified for valid http://localhost or in local IP format http://192.168.X.X.
	*/
	public let localhost: String

	/// Custom port for Satellite configuration.
	public let port: Int

	/// Initialization.
	/// - Parameters:
	///   - ip: `String` object, Satellite localhost. IMPORTANT! Use only with .sandbox environment! Should be specified for valid http://localhost or in local IP format http://192.168.X.X.
	///   - port: Custom port for Satellite configuration.
	public init(localhost: String, port: Int) {
		self.localhost = localhost
		self.port = port
	}
}
