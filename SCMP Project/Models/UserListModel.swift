//
//  UserModel.swift
//  SCMP Project
//
//  Created by Anson Wong on 21/1/2024.
//

import Foundation

struct UserListModel: Codable, Equatable {
    var page: Int?
    var perPage: Int?
    var totalPages: Int?
    var data: [UserModel]?
    
    enum CodingKeys: String, CodingKey {
        case page = "email"
        case perPage = "per_page"
        case totalPages = "total_pages"
        case data = "data"
    }
}


struct UserModel: Codable, Equatable {
    var email: String?
    var firstName: String?
    var lastName: String?
    var iconImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
        case iconImageUrl = "avatar"
    }
}
