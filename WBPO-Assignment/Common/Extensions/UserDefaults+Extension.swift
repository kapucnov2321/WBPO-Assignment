//
//  UserDefaultsService.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 12/04/2024.
//

import Foundation

extension UserDefaults {
    
    static var passedFirstRun: Bool? {
        get {
            UserDefaults.standard.bool(forKey: "passedFirstRun")
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "passedFirstRun")
        }
    }
    
    static var followedUsers: [Int] {
        get {
            UserDefaults.standard.array(forKey: "followedUsers") as? [Int] ?? []
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "followedUsers")
        }
    }
}
