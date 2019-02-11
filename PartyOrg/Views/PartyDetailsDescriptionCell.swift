//
//  PartyDetailsDescriptionCell.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/10/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import UIKit

protocol PartyDescriptionDelegate: class {
    func party(description: String)
}

class PartyDetailsDescriptionCell: UITableViewCell, UITextViewDelegate {
    
    weak var delegate: PartyDescriptionDelegate?
    
    lazy var info: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Description:"
        lbl.textColor = .black
        lbl.font = UIFont(name: ".SFUIText-Medium", size: 17)
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var textInfo: UITextView = {
        let tf = UITextView()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.textAlignment = .left
        tf.textColor = .lightGray
        return tf
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc func saved(){
        self.superview?.endEditing(true)
        delegate?.party(description: textInfo.text!)
        textInfo.text = ""
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        NotificationCenter.default.addObserver(self, selector: #selector(saved), name: NSNotification.Name(rawValue: NotificationConstants.PartyDetails), object: nil)
        
        self.addSubview(info)
        self.addSubview(textInfo)
        
        self.selectionStyle = .none
        
        info.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        info.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        info.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        info.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        textInfo.topAnchor.constraint(equalTo: info.bottomAnchor, constant: 20).isActive = true
        textInfo.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textInfo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        textInfo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.party(description: textInfo.text!)
        self.superview?.endEditing(true)
    }
    
    @objc func ending() {
        textViewDidEndEditing(self.textInfo)
    }
}
