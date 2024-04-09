//
//  UIViewController+Extension.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 09/04/2024.
//

import UIKit

extension UIViewController {
    
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)

        guard let vc = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Storyboard Error: Class not set/Initial VC Not set")
        }
    
        return vc
    }
    
}
