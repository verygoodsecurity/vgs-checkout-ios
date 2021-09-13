//
//  VGSCheckoutMutliplexingCredentialsValidator.swift
//  VGSCheckout
//

import Foundation

/// Check and Validates Multiplexing Token Scope.
internal class VGSMultiplexingCredentialsValidator {
    
    /// Scope not allowed.
    static let restrictedRolesScope: Set<String> = ["transfers:write"]
    /// Multiplexing App id  prefix.
    static let multiplexingAppIdPrefix = "multiplexing-app-"
    
    /// Returns JWT scope validation result.
    static func isJWTScopeValid(_ jwtToken: String, vaultId: String) -> Bool {
			guard !jwtToken.isEmpty else {
					let eventText = "Token is empty!"
					let event = VGSLogEvent(level: .warning, text: eventText, severityLevel: .error)
					VGSCheckoutLogger.shared.forwardLogEvent(event)
					return false
        }
        let decodedToken = String.decode(jwtToken: jwtToken)
        let multiplexingAppId = multiplexingAppIdPrefix + vaultId
        
        guard let resourceAccess = decodedToken["resource_access"] as? JsonData,
              let multiplexingApp = resourceAccess[multiplexingAppId] as? JsonData,
              let rolesScope = multiplexingApp["roles"] as? [String] else {
					let eventText = "Cannot parse token resouse!"
					let event = VGSLogEvent(level: .warning, text: eventText, severityLevel: .error)
					VGSCheckoutLogger.shared.forwardLogEvent(event)
            return false
        }
        let intersectionScope = Set(rolesScope).intersection(restrictedRolesScope)
				if !intersectionScope.isEmpty {
					let eventText = "Invalid token scope!"
					let event = VGSLogEvent(level: .warning, text: eventText, severityLevel: .error)
					VGSCheckoutLogger.shared.forwardLogEvent(event)
				}

        return intersectionScope.isEmpty
    }
}
