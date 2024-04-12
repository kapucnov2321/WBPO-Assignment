//
//  UserListViewModel.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 11/04/2024.
//

import Foundation
import RxSwift

class UserListViewModelType {
    
    //OUTPUT
    let userList = BehaviorSubject<[User]>(value: [])
    let showLoadingSpinner = PublishSubject<Bool>()

    func viewDidLoad() {}
    func fetchUserList() {}
}

class UserListViewModel: UserListViewModelType {
    private let coordinator: UserListCoordinatorType
    private let bag = DisposeBag()
    private var page = 1
    private var maxPage: Int? = nil
    private var isLoading: Bool = false

    init(coordinator: UserListCoordinatorType) {
        self.coordinator = coordinator
    }

    override func viewDidLoad() {
        coordinator.showLoader()
        fetchUserList()
    }
    
    override func fetchUserList() {
        guard (maxPage == nil || page <= maxPage ?? 0) && !isLoading  else {
            return
        }
        
        showLoadingSpinner.onNext(true)
        isLoading = true

        ApiClient.users(page: page)
            .flatMap { userResponse in
                let usersWithImages = userResponse
                    .users
                    .map { user in
                        ApiClient.image(urlString: user.avatar)
                            .map { imageData in
                                user.mapWithImageData(data: imageData)
                            }
                    }
                
                return Observable.zip(usersWithImages)
                    .map { users in
                        userResponse.remapUsers(remappedUsers: users)
                    }
                    
            }
            .observe(on: MainScheduler.instance)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] result in
                    guard let self else { return }
    
                    isLoading = false
                    page = result.page + 1
                    maxPage = result.totalPages
                    showLoadingSpinner.onNext(false)
                    coordinator.hideLoader()
                    
                    var currentUsers = (try? userList.value()) ?? []
                    currentUsers.append(contentsOf: result.users)
    
                    userList.onNext(currentUsers)
                },
                onError: { [weak self] error in
                    self?.showLoadingSpinner.onNext(false)
                    self?.coordinator.hideLoader()
                }
            )
            .disposed(by: bag)
    }
}
