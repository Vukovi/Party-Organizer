//
//  SmallCell.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/10/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import UIKit

class SmallCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .darkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
