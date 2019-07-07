//
//  ContactCell.swift
//  Go Jek Assignment
//
//  Created by jogi on 05/07/19.
//  Copyright © 2019 ketanDemo. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    
    var contactViewModel: ContactsViewModel! {
        didSet {
            contactName?.text = contactViewModel.name
            if contactViewModel.isFavorite{
                contactImage.isHidden = false
            }
            contactImage?.imageFromServerURL(contactViewModel.imageUrl, placeHolder: nil)
            contactImage.setCornerRadius()
        }
    }
}
