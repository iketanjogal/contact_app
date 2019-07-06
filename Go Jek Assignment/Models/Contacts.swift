//
//  Contacts.swift
//  Go Jek Assignment
//
//  Created by jogi on 05/07/19.
//  Copyright © 2019 ketanDemo. All rights reserved.
//

import Foundation
struct Contacts:Decodable {
    
    let isFavorite: Bool
    let firstName: String
    let contactId: Int
    let lastName: String
    let imageUrl: String
    let profileUrl: String
    
    enum CodingKeys : String, CodingKey {
        case isFavorite = "favorite"
        case firstName = "first_name"
        case contactId = "id"
        case lastName = "last_name"
        case imageUrl = "profile_pic"
        case profileUrl = "url"
    }
}
