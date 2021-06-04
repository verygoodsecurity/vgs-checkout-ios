//
//  VGSCheckoutHostnamePolicy.swift
//  VGSCheckout

import Foundation

/// Defines hostname policy to send data.
public enum VGSCheckoutHostnamePolicy {

	/// Use default vault.
	case vault

	/**
	 Custom host URL. Should be configured on the dashboard.

	 - Parameters:
			- hostname: `String` object, valid custom hostname.
	*/
	case customHostname(_ hostname: String)

	/**
	 Configuration for local testing with satellite.

	 - Parameters:
			- satelliteConfiguration: `VGSCheckoutSatelliteConfiguration` object, configuration for local testing.
	*/
	case local(_ satelliteConfiguration: VGSCheckoutSatelliteConfiguration)
}
