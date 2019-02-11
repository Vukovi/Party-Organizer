//
//  PartyDetailsNameCell.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/10/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import UIKit

protocol PartyNameDelegate: class {
    func party(name: String)
}

class PartyDetailsNameCell: UITableViewCell, UITextFieldDelegate {
    
    weak var delegate: PartyNameDelegate?
    
    lazy var info: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Party name"
        lbl.textColor = .lightGray
        lbl.font = UIFont(name: ".SFUIText-Medium", size: 17)
        lbl.textAlignment = .right
        return lbl
    }()
    
    lazy var enterParty: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.textAlignment = .left
        tf.textColor = .black
        tf.placeholder = "Enter party here..."
        return tf
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func saved() {
        textFieldShouldReturn(enterParty)
        textFieldDidEndEditing(enterParty)
        delegate?.party(name: enterParty.text!)
        enterParty.text = ""
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.selectionStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(saved), name: NSNotification.Name(rawValue: NotificationConstants.PartyDetails), object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ending))
        self.superview?.addGestureRecognizer(tap)
        
        self.addSubview(info)
        self.addSubview(enterParty)
        
        info.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        info.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        info.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        info.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
        
        enterParty.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        enterParty.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        enterParty.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        enterParty.trailingAnchor.constraint(equalTo: self.info.leadingAnchor).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.superview?.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.party(name: enterParty.text!)
        self.superview?.endEditing(true)
    }

    @objc func ending() {
        textFieldDidEndEditing(self.enterParty)
    }
}
