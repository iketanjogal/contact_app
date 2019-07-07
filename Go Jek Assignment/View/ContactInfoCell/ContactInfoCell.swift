//
//  ContactInfoCell.swift
//  Go Jek Assignment
//
//  Created by jogi on 06/07/19.
//  Copyright © 2019 ketanDemo. All rights reserved.
//

import UIKit
protocol ContactInfoCellDelegate {
    func contactInfoCelltextFieldDidChange(textField : UITextField)
}

class ContactInfoCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryValue: UILabel!
    @IBOutlet weak var categoryValueTextField: UITextField!
    
    var delegate : ContactInfoCellDelegate?
    var screen: ScreenType!{
        didSet {
            setCellForScreenType()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryValueTextField.delegate = self
        categoryValueTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    func setCellForScreenType(){
        switch screen! {
        
        case ScreenType.Add:
            categoryValue.isHidden = true
            categoryValueTextField.isHidden = false
        case ScreenType.Edit:
            categoryValue.isHidden = true
            categoryValueTextField.isHidden = false
        case ScreenType.View:
            categoryValue.isHidden = false
            categoryValueTextField.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @objc func textFieldDidChange(textField: UITextField) {
        delegate?.contactInfoCelltextFieldDidChange(textField:textField)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
}
