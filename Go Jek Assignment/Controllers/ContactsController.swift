//
//  ViewController.swift
//  Go Jek Assignment
//
//  Created by jogi on 04/07/19.
//  Copyright © 2019 ketanDemo. All rights reserved.
//

import UIKit

class ContactsController: UITableViewController {
    var contactsSection = [String]()
    var contactsDict = [String:[Contacts]]()
   
    let cellIdentifier = "ContactCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        fetchContacts()
        setupTableView()
    }
    
    //MARK: Network Request
    
    func fetchContacts (){
        RequestManager.shared.getContacts { (res) in
            switch res {
            case .success(let contacts):
                // creating dictionary for indexing
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
    
    //MARK: UITableViewDelegates
    
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
        
        let contactsViewModels = ContactsViewModel(contacts: contact[indexPath.row])
          cell.contactViewModel = contactsViewModels
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "contactDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactDetail"{
            let destinationVC = segue.destination as! ContactDetailController
            if let indexPath = tableView.indexPathForSelectedRow{
                let contactKey = contactsSection[indexPath.section]
                if let contact = contactsDict[contactKey.uppercased()]{
                    let contactsViewModels = ContactsViewModel(contacts: contact[indexPath.row])
                    destinationVC.contactViewModel = contactsViewModels
                }
            }
        }
    }
    
    //MARK: Private Methods
    
    fileprivate func setupTableView() {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.isTranslucent = false
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddContactController") as! AddContactController
        self.present(viewController, animated:true, completion: nil)
    }
}

extension UIColor {
    static let mainTextBlue = UIColor.rgb(r: 7, g: 71, b: 89)
    static let highlightColor = UIColor.rgb(r: 50, g: 199, b: 242)
    static let buttonBackground = UIColor.rgb(r: 0, g: 150, b: 255)

    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

