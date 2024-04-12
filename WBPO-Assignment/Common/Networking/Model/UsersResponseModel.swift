//
//  UsersResponseModel.swift
//  WBPO-Assignment
//
//  Created by jan.matoniak on 12/04/2024.
//

import Foundation

struct UsersResponseModel: Codable {
    let page, perPage, total, totalPages: Int
    let users: [User]

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case users = "data"
    }
    
    func remapUsers(remappedUsers: [User]) -> UsersResponseModel {
        return UsersResponseModel(page: page, perPage: perPage, total: total, totalPages: totalPages, users: remappedUsers)
    }
}

struct User: Codable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String
    var imageData: Data?

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
    
    func mapWithImageData(data: Data?) -> User {
        return User(id: id, email: email, firstName: firstName, lastName: lastName, avatar: avatar, imageData: data)
    }
}
