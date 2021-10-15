//
//  VGSCheckoutSDKHostnamePolicy.swift
//  VGSCheckoutSDK

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
	 Configuration for local testing with VGS Satellite.

	 - Parameters:
		- localhost: `String` object, Satellite localhost. IMPORTANT! Use only with .sandbox environment! Should be specified for valid http://localhost or in local IP format http://192.168.X.X.

	 - port: `Int` object, custom port for Satellite configuration.
	*/
	case local(_ localhost: String, port: Int)
}
