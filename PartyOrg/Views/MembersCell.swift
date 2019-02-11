//
//  MembersCell.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/10/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import UIKit
import SDWebImage

protocol MembersCellDelegate: class {
    func forwardPressed()
}

class MembersCell: UITableViewCell {
    
    weak var delegate: MembersCellDelegate?
    
    var tabbedMembers = true
    var member: ProfileModel?
    
    lazy var imgView: RoundedImageView = {
        let imgV = RoundedImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.makeRounded()
        return imgV
    }()
    
    lazy var nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .lightGray
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
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.selectionStyle = .none
        
        self.addSubview(imgView)
        self.addSubview(nameLbl)
        self.addSubview(buttonForward)
        
        
        imgView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLbl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameLbl.leadingAnchor.constraint(equalTo: self.imgView.trailingAnchor, constant: 10).isActive = true
        nameLbl.widthAnchor.constraint(equalToConstant: 170).isActive = true
        
        buttonForward.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        buttonForward.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonForward.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        buttonForward.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @objc func forwardPressed() {
        delegate?.forwardPressed()
    }

    func configureCell(){
        if let imgStr = member?.photo, let imgPlaceholder = member?.username {
            imgView.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: imgPlaceholder))
        }
        imgView.contentMode = .scaleAspectFit
        
        if let name = member?.username {
            nameLbl.text = name
        }
        
        if tabbedMembers {
            buttonForward.isHidden = false
        } else {
            buttonForward.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.makeRounded()
    }
}
