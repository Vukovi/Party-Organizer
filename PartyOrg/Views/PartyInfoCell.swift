//
//  PartyInfoCell.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/10/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import UIKit

protocol PartyInfoDelegate: class {
    func editParty(model: PartyModel?)
}

class PartyInfoCell: UITableViewCell {
    
    weak var delegate: PartyInfoDelegate?
    var partyModel: PartyModel? {
        didSet {
            partyInfo.text = partyModel?.partyName
            partyDate.text = partyModel?.partyDate
            partyDescription.text = partyModel?.partyDescription
        }
    }
    
    lazy var partyInfo: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.text = partyModel?.partyName
        lbl.font = UIFont(name: ".SFUIText-Medium", size: 17)
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var buttonForward: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(forward, for: .normal)
        btn.addTarget(self, action: #selector(forwardPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var partyDate: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.text = partyModel?.partyDate
        lbl.font = UIFont(name: ".SFUIText-Medium", size: 17)
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var partyDescription: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .lightGray
        lbl.font = UIFont(name: ".SFUIText-Medium", size: 14)
        lbl.textAlignment = .left
        lbl.text = partyModel?.partyDescription
        lbl.numberOfLines = 0
        return lbl
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @objc func forwardPressed() {
        delegate?.editParty(model: partyModel)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.addSubview(partyInfo)
        self.addSubview(buttonForward)
        self.addSubview(partyDate)
        self.addSubview(partyDescription)
        
        partyInfo.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        partyInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        partyInfo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
        partyInfo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        buttonForward.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        buttonForward.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonForward.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        buttonForward.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        partyDate.topAnchor.constraint(equalTo: partyInfo.bottomAnchor, constant: 10).isActive = true
        partyDate.heightAnchor.constraint(equalToConstant: 30).isActive = true
        partyDate.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
        partyDate.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        partyDescription.topAnchor.constraint(equalTo: partyDate.bottomAnchor, constant: 10).isActive = true
        partyDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        partyDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        partyDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        self.selectionStyle = .none
    }

}
