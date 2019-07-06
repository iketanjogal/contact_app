//
//  ViewController.swift
//  Go Jek Assignment
//
//  Created by jogi on 04/07/19.
//  Copyright © 2019 ketanDemo. All rights reserved.
//

import UIKit

class ContactsController: UITableViewController {
    var contactsViewModels = [ContactsViewModel]()
    
    var contactsSection = [String]()
    var contactsDict = [String:[Contacts]]()
   
    let cellIdentifier = "ContactCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavBar()
        fetchContacts()
        setupTableView()
    }
    func fetchContacts (){
        RequestManager.shared.getContacts { (res) in
            switch res {
            case .success(let contacts):
                for contact in contacts{
                    let key = "\(contact.firstName[contact.firstName.startIndex])"
                    let upper = key.uppercased()
                    if var contactValues = self.contactsDict[upper]{
                        contactValues.append(contact)
                        self.contactsDict[upper] = contactValues
                    }else{
                        self.contactsDict[upper] = [contact]
                    }
                }
                self.contactsSection = [String](self.contactsDict.keys)
                self.contactsSection = self.contactsSection.sorted()
                self.tableView.reloadData()
            case .failure(let err):
                print("Failed to fetch courses:", err)
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactsSection.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contactKey = contactsSection[section]
        if let contactValues = contactsDict[contactKey]{
            return contactValues.count
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactsSection[section]
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactsSection
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ContactCell
        let contactKey = contactsSection[indexPath.section]
        if let contact = contactsDict[contactKey.uppercased()]{
            cell.textLabel?.text = contact[indexPath.row].firstName
        }
        return cell
    }
    
    fileprivate func setupTableView() {
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        tableView.separatorColor = .mainTextBlue
        tableView.backgroundColor = UIColor.rgb(r: 12, g: 47, b: 57)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .yellow
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.rgb(r: 50, g: 199, b: 242)
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
}

class CustomNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension UIColor {
    static let mainTextBlue = UIColor.rgb(r: 7, g: 71, b: 89)
    static let highlightColor = UIColor.rgb(r: 50, g: 199, b: 242)
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

