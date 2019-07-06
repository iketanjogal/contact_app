//
//  ContactCell.swift
//  Go Jek Assignment
//
//  Created by jogi on 05/07/19.
//  Copyright © 2019 ketanDemo. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    var contactsViewModel: ContactsViewModel! {
        didSet {
            textLabel?.text = contactsViewModel.name
          //  detailTextLabel?.text = contactsViewModel.detailTextString
//            let image =  UIImage(data: NSData(contentsOf: NSURL(string:contactsViewModel.imageUrl)! as URL)! as Data)
//            DispatchQueue.main.async {
//                self.imageView?.image = image
//            }
        }
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        contentView.backgroundColor = isHighlighted ? .highlightColor : .white
        textLabel?.textColor = isHighlighted ? UIColor.white : .mainTextBlue
        detailTextLabel?.textColor = isHighlighted ? .white : .black
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        // cell customization
        textLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        textLabel?.numberOfLines = 0
        detailTextLabel?.textColor = .black
        detailTextLabel?.font = UIFont.systemFont(ofSize: 20, weight: .light)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}
