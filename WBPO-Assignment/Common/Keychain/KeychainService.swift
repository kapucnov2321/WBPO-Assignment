//
//  KeychainService.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 11/04/2024.
//
import Foundation
import LocalAuthentication

enum KeychainLoadResult<T> {
    case success(T)
    case error(Error)
    case notExist
    case internalError
    case userCancelled
    case authFailed
}

enum KeychainSaveResult {
    case success
    case error(Error)
}

struct KeychainService {
    
    static func save<T: Encodable>(key: String, data: T?, securityQuery: [String: Any]? = nil) -> KeychainSaveResult {
        guard let data = data else {
            KeychainService.remove(key: key)
            return .success
        }
        do {
            let encoder = JSONEncoder()
            let encodedToData = try encoder.encode(data)
            var query: [String : Any] = [
                kSecClass       as String: kSecClassGenericPassword as String,
                kSecAttrAccount as String: key,
                kSecValueData   as String: encodedToData]
            
            if let securityQuery = securityQuery {
                query = query.merging(securityQuery, uniquingKeysWith: { (_, last) in last })
            }
            
            SecItemDelete(query as CFDictionary)
            let status = SecItemAdd(query as CFDictionary, nil)
            
            if status == noErr {
                return .success
            } else {
                return .error(NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil))
            }

        } catch (let error) {
            return .error(error)
        }
    }
    
    static func load<T: Decodable>(key: String, securityQuery: [String: Any]? = nil) -> KeychainLoadResult<T> {
        
        var query: [String : Any] = [
            kSecClass       as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData  as String: kCFBooleanTrue!,
            kSecMatchLimit  as String: kSecMatchLimitOne]
        
        if let securityQuery = securityQuery {
            query = query.merging(securityQuery, uniquingKeysWith: { (_, last) in last })
        }

        var dataTypeRef: CFTypeRef?

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        do {
            if status == noErr {
                let decoder = JSONDecoder()
                if let data = dataTypeRef as? Data {
                    let decodedData = try decoder.decode(T.self, from: data)
                    return .success(decodedData)
                } else {
                    return .internalError
                }
            } else if status == errSecUserCanceled {
                return .userCancelled
            } else if status == errSecAuthFailed {
                return .authFailed
            } else {
                
                if status == errSecItemNotFound {
                    return .notExist
                } else {
                    return .error(NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil))
                }
            }
        } catch (let error) {
            return .error(error)
        }
    }
    
    private static func contains(key: String, securityQuery: [String: Any]? = nil) -> Bool {
        let context = LAContext()
        context.interactionNotAllowed = true
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecUseAuthenticationContext as String: context,
            kSecReturnData  as String: kCFBooleanFalse!,
            kSecMatchLimit  as String: kSecMatchLimitOne
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)

        return status == errSecSuccess || status == errSecInteractionNotAllowed
    }
    
    static func remove(key: String, securityQuery: [String: Any]? = nil) {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        if let securityQuery = securityQuery {
            query = query.merging(securityQuery, uniquingKeysWith: { (_, last) in last })
        }
        
        SecItemDelete(query as CFDictionary)
    }
}
