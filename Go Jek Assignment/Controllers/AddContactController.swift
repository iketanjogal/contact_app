//
//  AddContactController.swift
//  Go Jek Assignment
//
//  Created by jogi on 06/07/19.
//  Copyright © 2019 ketanDemo. All rights reserved.
//

import UIKit

class AddContactController: UIViewController,UITableViewDelegate,UITableViewDataSource,ContactInfoCellDelegate {
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
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
        case 1 :
            lastName = textField.text ?? ""
        case 2 :
            if !(textField.text?.validatePhone())!{
                textField.textColor = UIColor.red
                isPhoneValid = false
            }else{
                textField.textColor = UIColor.black
                isPhoneValid = true
                phoneNumber = textField.text ?? ""
            }
        case 3 :
            if !(textField.text?.validateEmail())!{
                isEmailValid = false
                textField.textColor = UIColor.red
            }else{
                isEmailValid = true
                textField.textColor = UIColor.black
                email = textField.text ?? ""
            }
        default:
            print("nothing")
        }
        if isPhoneValid && isEmailValid{
            doneButton.isEnabled = true
        }else{
            doneButton.isEnabled = false
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
        if isPhoneValid && isEmailValid {
            if screen == ScreenType.Add{
                let contactToAdd = AddContact(firstName: firstName, lastName: lastName, email: email, phone: phoneNumber, isFavorite: false)
                addContactWithDetail(addContact: contactToAdd)
            }else{
                let contactToAdd = AddContact(firstName: firstName, lastName: lastName, email: email, phone: phoneNumber, isFavorite: false)
                editContactWithDetail(addContact: contactToAdd)
            }
           
        }
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Network Request
    
    func addContactWithDetail(addContact:AddContact) {
        RequestManager.shared.addContactWithDetail(contact: addContact, completion:{
            (res) in
             self.dismiss(animated: true, completion: nil)
            print(res)
        })
    }
    func editContactWithDetail(addContact:AddContact) {
        RequestManager.shared.editContactWithDetail(contact: addContact, contactId:contact.contactId, completion:{
            (res) in
            self.dismiss(animated: true, completion: nil)
            print(res)
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
        contactInfoTable.estimatedRowHeight = 50
    }
}
