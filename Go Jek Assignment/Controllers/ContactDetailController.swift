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
        let edit : UIBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editButtonPressed))
        self.navigationItem.rightBarButtonItem = edit
        
        setupTableView()
        fetchContactDetail()
        updateUI()
    }
    @objc func editButtonPressed(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddContactController") as! AddContactController
        viewController.screen = ScreenType.Edit
        viewController.contact = contactDetail
        self.present(viewController, animated:false, completion: nil)
    }
    
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
    fileprivate func updateUI(){
        contactName?.text = contactViewModel.name
        contactImage?.imageFromServerURL(contactViewModel.imageUrl, placeHolder: nil)
        contactImage.layer.cornerRadius = contactImage.frame.size.width/2
        isMarked = contactViewModel.isFavorite
        markFavorite(marked: isMarked)
    }
    fileprivate func setupTableView() {
        contactInfoTable.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        contactInfoTable.separatorColor = .mainTextBlue
        contactInfoTable.rowHeight = UITableView.automaticDimension
        contactInfoTable.estimatedRowHeight = 50
        contactInfoTable.tableFooterView = UIView()
    }
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
    func sendMessage(){
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.recipients = [contactDetail.phoneNumber]
        
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            self.dismiss(animated: true, completion: nil)
        default:
            break;
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
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
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
}
