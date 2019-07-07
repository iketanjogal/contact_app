//
//  AddContactController.swift
//  Go Jek Assignment
//
//  Created by jogi on 06/07/19.
//  Copyright © 2019 ketanDemo. All rights reserved.
//

import UIKit
import PKHUD

protocol AddContactControllerDelegate {
    func addContactControllerDelegateContactUpdated()
}

class AddContactController: UIViewController,UITableViewDelegate,UITableViewDataSource,ContactInfoCellDelegate {
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var delegate : AddContactControllerDelegate?
   
    let cellIdentifier = "ContactInfoCell"
    var screen : ScreenType = ScreenType.Add
    var contactInfoName = ["FirstName","LastName","Mobile","Email"]
    var contactInfoValue = ["","","",""]
    var contact :ContactDetail!{
        didSet{
            contactInfoValue = [contact.firstName,contact.lastName,contact.phoneNumber,contact.email]
        }
    }
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    
    var isEmailValid : Bool = false
    var isPhoneValid : Bool = false
   
    @IBOutlet weak var contactInfoTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setUpUIForScreen()
        setKeyBoardObserver()
    }
    
    //MARK: UITableviewDelegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ContactInfoCell
        cell.categoryName.text = contactInfoName[indexPath.row]
        cell.categoryValueTextField.text = contactInfoValue[indexPath.row]
        cell.categoryValueTextField.placeholder = contactInfoName[indexPath.row]
        cell.screen = screen
        cell.delegate = self
        cell.categoryValueTextField.tag = indexPath.row
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactInfoName.count
    }
    func contactInfoCelltextFieldDidChange(textField: UITextField) {
        
        switch textField.tag {
        case 0 :
            firstName = textField.text ?? ""
            if let contact = contact{
                doneButton.isEnabled = firstName != contact.firstName
            }
        case 1 :
            lastName = textField.text ?? ""
            if let contact = contact{
                doneButton.isEnabled = lastName != contact.lastName
            }
        case 2 :
            phoneNumber = textField.text ?? ""
            if let contact = contact{
                doneButton.isEnabled = phoneNumber != contact.phoneNumber && phoneNumber.validatePhone()
            }
        case 3 :
            email = textField.text ?? ""
            if let contact = contact{
                doneButton.isEnabled = email != contact.email && email.validateEmail()
            }
        default:
            print("nothing")
        }
        if screen == ScreenType.Add{
            if firstName.count > 0 && lastName.count > 0 && phoneNumber.validatePhone() && email.validateEmail(){
                doneButton.isEnabled = true
            }else{
                doneButton.isEnabled = false
            }
        }
        
    }
    
    //MARK: KeyBoard Observer selectors
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    //MARK: IBActions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
            if screen == ScreenType.Add{
                let contactToAdd = AddContact(firstName: firstName, lastName: lastName, email: email, phone: phoneNumber, isFavorite: false)
                addContactWithDetail(addContact: contactToAdd)
            }else{
                let contactToAdd = AddContact(firstName: firstName, lastName: lastName, email: email, phone: phoneNumber, isFavorite: false)
                editContactWithDetail(addContact: contactToAdd)
            }
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Network Request
    
    func addContactWithDetail(addContact:AddContact) {
        PKHUD.sharedHUD.show()
        RequestManager.shared.addContactWithDetail(contact: addContact, completion:{
            (res) in
            switch res {
            case .success(_):
                PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                PKHUD.sharedHUD.show()
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
                    self.delegate?.addContactControllerDelegateContactUpdated()
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let err):
                print("Failed to fetch courses:", err)
            }
            
            print(res)
        })
    }
    func editContactWithDetail(addContact:AddContact) {
        PKHUD.sharedHUD.show()
        RequestManager.shared.editContactWithDetail(contact: addContact, contactId:contact.contactId, completion:{
            (res) in
            switch res {
            case .success(let contactDetailResponse):
                print(contactDetailResponse)
                PKHUD.sharedHUD.contentView = PKHUDSuccessView()
                PKHUD.sharedHUD.show()
                PKHUD.sharedHUD.hide(afterDelay: 1.0) { success in
                    self.delegate?.addContactControllerDelegateContactUpdated()
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let err):
                print("Failed to fetch courses:", err)
            }
            
        })
    }
    
    //MARK: Private Methods
    
    func setUpUIForScreen(){
        doneButton.isEnabled = false
        if screen == ScreenType.Edit{
            contactImage?.imageFromServerURL(BASE_URL + contact.imageUrl, placeHolder: UIImage(named: "missing"))
        }
        contactImage.layer.cornerRadius = contactImage.frame.size.width/2
    }
    func setKeyBoardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func setupTableView() {
        contactInfoTable.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        contactInfoTable.rowHeight = UITableView.automaticDimension
        contactInfoTable.tableFooterView = UIView()
        contactInfoTable.estimatedRowHeight = 50
    }
}
