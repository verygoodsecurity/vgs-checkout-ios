//
//  VGSCheckoutMutliplexingCredentialsValidator.swift
//  VGSCheckout
//

import Foundation

/// Check and Validates Multiplexing Token Scope.
internal class VGSCheckoutMultiplexingCredentialsValidator {
    
    /// Scope not allowed.
    static let restrictedRolesScope: Set<String> = ["transfers:write"]
    /// Multiplexing App id  prefix.
    static let multiplexingAppIdPrefix = "multiplexing-app-"
    
    /// Returns JWT scope validation result.
    static func isJWTScopeValid(_ jwtToken: String, vaultId: String) -> Bool {
        guard !jwtToken.isEmpty else {
            return false
        }
        let decodedToken = String.decode(jwtToken: jwtToken)
        let multiplexingAppId = multiplexingAppIdPrefix + vaultId
        
        guard let resourceAccess = decodedToken["resource_access"] as? JsonData,
              let multiplexingApp = resourceAccess[multiplexingAppId] as? JsonData,
              let rolesScope = multiplexingApp["roles"] as? [String] else {
            return false
        }
        let intersectionScope = Set(rolesScope).intersection(restrictedRolesScope)
        return intersectionScope.isEmpty
    }
}
