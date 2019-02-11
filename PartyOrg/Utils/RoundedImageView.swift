//
//  RoundedImageView.swift
//  PartyOrg
//
//  Created by Vuk Knezevic on 2/11/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import UIKit

protocol Roundable {}

extension Roundable where Self: UIView {  
    func makeRounded() {
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

class RoundedImageView: UIImageView, Roundable { }
