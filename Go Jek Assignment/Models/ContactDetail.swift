//
//  ContactDetail.swift
//  Go Jek Assignment
//
//  Created by jogi on 06/07/19.
//  Copyright © 2019 ketanDemo. All rights reserved.
//

import Foundation
struct ContactDetail: Decodable{
    
    let isFavorite: Bool
    let firstName: String
    let contactId: Int
    let lastName: String
    let imageUrl: String
    let email: String
    let createdAt: String
    let updatedAt: String
    let phoneNumber: String
    
    enum CodingKeys : String, CodingKey {
        case isFavorite = "favorite"
        case firstName = "first_name"
        case contactId = "id"
        case lastName = "last_name"
        case imageUrl = "profile_pic"
        case email = "email"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case phoneNumber = "phone_number"
    }
}
