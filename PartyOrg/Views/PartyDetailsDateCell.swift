//
//  PartyDetailsDateCell.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/10/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import UIKit

protocol PartyDateDelegate: class {
    func party(date: String)
}

class PartyDetailsDateCell: UITableViewCell {
    
    weak var delegate: PartyDateDelegate?
    
    lazy var info: UILabel = {
        let lbl = UILabel()
        lbl.isUserInteractionEnabled = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Start date and time"
        lbl.textColor = .lightGray
        lbl.font = UIFont(name: ".SFUIText-Medium", size: 17)
        lbl.textAlignment = .right
        return lbl
    }()
    
    lazy var enterDate: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textAlignment = .left
        tf.textColor = .black
        tf.text = Date().toString()
        return tf
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        NotificationCenter.default.addObserver(self, selector: #selector(saved), name: NSNotification.Name(rawValue: NotificationConstants.PartyDetails), object: nil)
        showDatePicker()
        self.addSubview(info)
        self.addSubview(enterDate)
        
        self.selectionStyle = .none
        
        info.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        info.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        info.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        info.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        
        enterDate.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        enterDate.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        enterDate.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        enterDate.trailingAnchor.constraint(equalTo: self.info.leadingAnchor).isActive = true
    }
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }()
    
    func showDatePicker(){
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        enterDate.inputAccessoryView = toolbar
        enterDate.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        enterDate.text = datePicker.date.toString()
        delegate?.party(date: datePicker.date.toString())
        self.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.endEditing(true)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc func saved(){
        delegate?.party(date: Date().toString())
        enterDate.text = Date().toString()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
