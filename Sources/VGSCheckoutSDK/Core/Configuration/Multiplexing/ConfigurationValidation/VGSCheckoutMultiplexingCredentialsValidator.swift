//
//  VGSCheckoutSDKMutliplexingCredentialsValidator.swift
//  VGSCheckoutSDK
//

import Foundation

/// Check and Validates Multiplexing Token Scope.
internal class VGSMultiplexingCredentialsValidator {

	/// Scope not allowed.
	static let restrictedRolesScope: Set<String> = ["transfers"]
	
	/// Multiplexing App id  prefix.
	static let multiplexingAppIdPrefix = "multiplexing-app-"

	/// Returns JWT scope validation result.
	static func isJWTScopeValid(_ jwtToken: String, vaultId: String, environment: String) -> Bool {
		guard !jwtToken.isEmpty else {
			trackInvalidJWTError(with: vaultId, environment: environment, debugErrorText: "JWT token is empty!")
			return false
		}
		let decodedToken = String.decode(jwtToken: jwtToken)
		let multiplexingAppId = multiplexingAppIdPrefix + vaultId

		guard let resourceAccess = decodedToken["resource_access"] as? JsonData,
					let multiplexingApp = resourceAccess[multiplexingAppId] as? JsonData,
					let rolesScope = multiplexingApp["roles"] as? [String] else {
						trackInvalidJWTError(with: vaultId, environment: environment, debugErrorText: "Cannot parse token resource!")
						return false
					}
		let intersectionScope = Set(rolesScope).intersection(restrictedRolesScope)
		if !intersectionScope.isEmpty {
			trackInvalidJWTError(with: vaultId, environment: environment, debugErrorText: "Invalid token scope!")
		}

		return intersectionScope.isEmpty
	}

	/// Track JWTValidation error.
	/// - Parameters:
	///   - vaultId: `String` object, vaultID.
	///   - environment: `String` object, environment.
	///   - debugErrorText: `String` object, debug error text.
	internal static func trackInvalidJWTError(with vaultId: String, environment: String, debugErrorText: String) {
		let extraData: [String: Any] = [
			"tnt": vaultId,
			"env": environment
		]

		// Print JWT error to console if logger is disabled since it is critical but we do not want to trigger asserts.
		if VGSCheckoutLogger.shared.configuration.level == .none {
			print("[VGSCheckout - ❌ ERROR! JWT TOKEN IS INVALID: \(debugErrorText). Multiplexing configuration cannot start without valid JWT token!]")
		}
		let event = VGSLogEvent(level: .warning, text: debugErrorText, severityLevel: .error)
		VGSCheckoutLogger.shared.forwardLogEvent(event)
		VGSCheckoutAnalyticsClient.shared.trackEvent(.jwtValidation, status: .failed, extraData: extraData)
	}
}
