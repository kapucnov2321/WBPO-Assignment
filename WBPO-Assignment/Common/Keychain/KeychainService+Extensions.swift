//
//  KeychainService+Extensions.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 11/04/2024.
//

import Foundation

extension KeychainService {
    
    static var credentials: UserCredentials? {
        get {
            let keychainResult: KeychainLoadResult<UserCredentials> = KeychainService.load(key: "credentials")
            
            switch keychainResult {
            case .success(let credentials):
                return credentials
            default:
                return nil
            }
        }
        set {
            _ = KeychainService.save(key: "credentials", data: newValue)
        }
    }
}
