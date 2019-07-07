//
//  ContactDetailController.swift
//  Go Jek Assignment
//
//  Created by jogi on 06/07/19.
//  Copyright © 2019 ketanDemo. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailController: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate {
    
    let cellIdentifier = "ContactInfoCell"
   
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var contactInfoTable: UITableView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    
    var contactDetail: ContactDetail!
    var contactViewModel: ContactsViewModel!
    
    let contactInfoCategory = ["Mobile","Email"]
    var contactInfoValue:[String] = []
    var isMarked: Bool = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchContactDetail()
        updateUI()
    }
    
    //MARK: UITableViewDelegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactInfoCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ContactInfoCell
            cell.categoryName?.text = contactInfoCategory[indexPath.row]
            cell.screen = ScreenType.View
            if contactInfoValue.count > 0{
                cell.categoryValue?.text = contactInfoValue[indexPath.row]
            }
        return cell
    }
    
    //MARK: Network Request
    
    func fetchContactDetail(){
        RequestManager.shared.getContactDetail(profileUrl:contactViewModel.profileUrl) { (res) in
            switch res {
            case .success(let contact):
            self.contactDetail = contact
            self.contactInfoValue.append(self.contactDetail.phoneNumber)
            self.contactInfoValue.append(self.contactDetail.email)
            self.contactInfoTable.reloadData()
            case .failure(let err):
                print("Failed to fetch courses:", err)
            }
        }
    }
    
    //MARK: IBActions
    
    @IBAction func stackViewButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            sendMessage()
        case 2:
            callNumber()
        case 3:
            sendEmail()
        case 4:
            if isMarked{
                isMarked = false
            }else{
                isMarked = true
            }
            markFavorite(marked: isMarked)
        default:
            print("nothing")
        }
    }
    
    @objc func editButtonPressed(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddContactController") as! AddContactController
        viewController.screen = ScreenType.Edit
        viewController.contact = contactDetail
        self.present(viewController, animated:false, completion: nil)
    }
    
    //MARK: Private Methods
    
    fileprivate func updateUI(){
        
        let edit : UIBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editButtonPressed))
        self.navigationItem.rightBarButtonItem = edit
        
        contactName?.text = contactViewModel.name
        contactImage?.imageFromServerURL(contactViewModel.imageUrl, placeHolder: nil)
        contactImage.setCornerRadius()
        isMarked = contactViewModel.isFavorite
        
        markFavorite(marked: isMarked)
    }
    fileprivate func setupTableView() {
        contactInfoTable.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        contactInfoTable.rowHeight = UITableView.automaticDimension
        contactInfoTable.estimatedRowHeight = 50
        contactInfoTable.tableFooterView = UIView()
    }
    
    func sendMessage(){
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.recipients = [contactDetail.phoneNumber]
        
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func sendEmail(){
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as MFMailComposeViewControllerDelegate
            mail.setToRecipients([contactDetail.email])
            present(mail, animated: true)
        }
    }
    
    func callNumber(){
        guard let number = URL(string: "tel://" + contactDetail.phoneNumber) else { return }
        UIApplication.shared.open(number)
    }
    
    func markFavorite(marked:Bool){
        if marked{
            favoriteButton.setImage(UIImage(named: "starFilled"), for: .normal)
        }else{
            favoriteButton.setImage(UIImage(named: "starEmpty"), for: .normal)
        }
    }
    
    //MARK:MFMessageComposeViewControllerDelegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
