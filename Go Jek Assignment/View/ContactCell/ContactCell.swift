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
            contactImage.layer.cornerRadius = contactImage.frame.size.width/2
        }
    }
}
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
