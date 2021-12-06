//
//  VGSCheckoutSDKMutliplexingCredentialsValidator.swift
//  VGSCheckoutSDK
//

import Foundation

/// Check and Validates Multiplexing Token Scope.
internal class VGSMultiplexingCredentialsValidator {

	/// Multiplexing Role Scope not allowed for Save Card flow.
	static let restrictedRolesScope: String = "transfers:"

	/// Returns JWT scope validation result.
	static func isJWTScopeValid(_ jwtToken: String, vaultId: String, environment: String) -> Bool {
		guard !jwtToken.isEmpty else {
			trackInvalidJWTError(with: vaultId, environment: environment, debugErrorText: "JWT token is empty!")
			return false
		}
		let decodedToken = String.decode(jwtToken: jwtToken)
    guard let resourceAccess = decodedToken["resource_access"] as? JsonData else {
      trackInvalidJWTError(with: vaultId, environment: environment, debugErrorText: "JWT token has invalid resource_access!")
      return false
    }
    
    for key in resourceAccess.keys {
      if let resource = resourceAccess[key] as? JsonData,
        let roles = resource["roles"] as? [String] {
        // Check invalid token scope
        let rolesWithInvalidScope = roles.filter({$0.contains(restrictedRolesScope)})
        if !rolesWithInvalidScope.isEmpty {
          trackInvalidJWTError(with: vaultId, environment: environment, debugErrorText: "JWT token has invalid role scope!")
          return false
        }
      }
    }
		return true
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
		let event = VGSLogEvent(level: .warning, text: debugErrorText, severityLevel: .error)
		VGSCheckoutLogger.shared.forwardCriticalLogEvent(event)
		VGSCheckoutAnalyticsClient.shared.trackEvent(.jwtValidation, status: .failed, extraData: extraData)
	}
}
