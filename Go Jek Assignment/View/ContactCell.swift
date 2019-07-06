//
//  ContactCell.swift
//  Go Jek Assignment
//
//  Created by jogi on 05/07/19.
//  Copyright © 2019 ketanDemo. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    var contactsViewModel: ContactsViewModel! {
        didSet {
           // contactName?.text = contactsViewModel.name
          //  detailTextLabel?.text = contactsViewModel.detailTextString
//            let image =  UIImage(data: NSData(contentsOf: NSURL(string:contactsViewModel.imageUrl)! as URL)! as Data)
//            DispatchQueue.main.async {
//                self.imageView?.image = image
//            }
        }
    }
}
