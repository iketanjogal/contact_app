//
//  ContactsViewModel.swift
//  Go Jek Assignment
//
//  Created by jogi on 05/07/19.
//  Copyright © 2019 ketanDemo. All rights reserved.
//

import Foundation
struct ContactsViewModel {
    private var contacts: Contacts
    
    let name: String
    let id: Int
    let url: String
    let imageUrl: String
    let profileUrl: String
    let isFavorite: Bool
    
    init(contacts: Contacts) {
        self.contacts = contacts
        self.name = "\(contacts.firstName) \(contacts.lastName)"
        self.id = contacts.contactId
        self.url = contacts.profileUrl
        self.imageUrl = BASE_URL+contacts.imageUrl
        self.profileUrl = contacts.profileUrl
        self.isFavorite = contacts.isFavorite
    }
    
}
