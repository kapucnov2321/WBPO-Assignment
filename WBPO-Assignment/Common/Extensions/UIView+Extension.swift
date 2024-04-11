//
//  UIView+Extension.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 11/04/2024.
//

import UIKit

extension UIView {
    
    func hideView(completion: ((Bool) -> Void)? = nil) {
        setViewVisibility(isHidden: true, completion: completion)
    }
    
    func showView(completion: ((Bool) -> Void)? = nil) {
        setViewVisibility(isHidden: false, completion: completion)
    }
    
    private func setViewVisibility(isHidden: Bool, completion: ((Bool) -> Void)?) {
        UIView.transition(
            with: self,
            duration: 0.3,
            animations: { [weak self] in
                self?.isHidden = isHidden
            },
            completion: completion
        )
    }
}
