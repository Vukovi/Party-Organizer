//
//  Party.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/9/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import Foundation

class Party {
    static var invitees = Party()
    private init() {}
    
    var profiles: [ProfileModel] = [ProfileModel]()
    var parties: [PartyModel] = [PartyModel]()
}
