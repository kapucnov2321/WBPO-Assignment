//
//  RegisterRequest.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 11/04/2024.
//

import Foundation

struct RegisterRequestModel {
    let email: String
    let password: String
    
    var parameterRepresentation: [String: Any] {
        return [
            "email" : email,
            "password" : password
        ]
    }
}
