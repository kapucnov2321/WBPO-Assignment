//
//  UserTableViewCell.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 12/04/2024.
//

import UIKit
import RxSwift

class UserTableViewCellDataModel {
    let user: User
    
    //INPUT
    let refreshFollowed: BehaviorSubject<()>
    
    //OUTPUT
    let onFollowTap: PublishSubject<Int>
    
    init(user: User, refreshFollowed: BehaviorSubject<()>, onFollowTap: PublishSubject<Int>) {
        self.user = user
        self.refreshFollowed = refreshFollowed
        self.onFollowTap = onFollowTap
    }
    
}

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    
    private let bag = DisposeBag()
    
    weak var data: UserTableViewCellDataModel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func tappedFollowButton(_ sender: UIButton) {
        guard let id = data?.user.id else {
            return
        }

        data?.onFollowTap.onNext(id)
    }

    func setupCell(data: UserTableViewCellDataModel) {
        self.data = data

        let userData = data.user
        userNameLabel.text = "\(userData.firstName) \(userData.lastName)"
        userEmailLabel.text = userData.email
    
        if let imageData = userData.imageData {
            userImage.image = UIImage(data: imageData)
        }
        
        data.refreshFollowed
            .subscribe(onNext: { [weak self] in
                guard let self, let data = self.data else { return }
    
                followButton.setTitle(checkIfUserFollowed(id: data.user.id) ? "Unfollow" : "Follow" , for: .normal)
            })
            .disposed(by: bag)
    }
    
    private func checkIfUserFollowed(id: Int) -> Bool {
        return UserDefaults.followedUsers.contains { $0 == id }
    }
    
}
