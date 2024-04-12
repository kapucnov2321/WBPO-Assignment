//
//  UserTableViewCell.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 12/04/2024.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(user: User) {
        userNameLabel.text = "\(user.firstName) \(user.lastName)"
        userEmailLabel.text = user.email
        
        if let imageData = user.imageData {
            userImage.image = UIImage(data: imageData)
        }
    }
}
