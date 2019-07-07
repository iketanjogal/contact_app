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
            print(contact.imageUrl)
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
        doneButton.isEnabled = false
        if screen == ScreenType.Edit{
             contactImage?.imageFromServerURL(BASE_URL + contact.imageUrl, placeHolder: UIImage(named: "missing"))
        }
        contactImage.layer.cornerRadius = contactImage.frame.size.width/2
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            if !validatePhone(phoneNumber: textField.text ?? ""){
                textField.textColor = UIColor.red
                isPhoneValid = false
            }else{
                textField.textColor = UIColor.black
                isPhoneValid = true
                phoneNumber = textField.text ?? ""
            }
        case 3 :
            if !validateEmail(email: textField.text ?? ""){
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
    func validatePhone(phoneNumber:String) -> Bool{
        let phoneNumberRegex = "^[6-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: phoneNumber)
        return isValidPhone
    }
    
    func validateEmail(email:String) -> Bool{
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
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
    
    
    
    fileprivate func setupTableView() {
        contactInfoTable.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        contactInfoTable.separatorColor = .mainTextBlue
        contactInfoTable.rowHeight = UITableView.automaticDimension
        contactInfoTable.estimatedRowHeight = 50
        contactInfoTable.tableFooterView = UIView()
    }
}
