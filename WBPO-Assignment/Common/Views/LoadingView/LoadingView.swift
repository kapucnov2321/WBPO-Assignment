//
//  LoadingView.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 11/04/2024.
//

import UIKit

class LoadingView: UIView {
    
    @IBOutlet weak var contentView: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    func initSubviews() {
        Bundle.main.loadNibNamed("LoadingView", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.embed(view: self)
    }

}
