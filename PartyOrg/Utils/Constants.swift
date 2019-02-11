//
//  Constants.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/9/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import UIKit

struct NotificationConstants {
    static let PartyDetails = "PartyDetailsSaved"
    static let MembersPassedBackToPartyDetails = "MembersPassedBackToPartyDetails"
}

let Parties = "Parties"
let Home = "Home"
let Members = "Members"
let Profile = "Profile"
let BASE_URL = "http://api-coin.quantox.tech/profiles.json"
let forward: UIImage = UIImage(named: "forward")!
let CreateParty = "Create party"
let BackMemebers = "BackMemebers"

struct Segue {
    static let PartyToPartyDetails = "party2partyDetails"
    static let PartyDetailToMembers = "party2members"
    static let PartyMembersToProfile = "partyMembers2profile"
    static let MembersToProfile = "members2Profile"
    static let InviteToParty = "invite2party"
}

protocol NavigationSettings {
    func navigationSettings(title: String, selector: Selector)
}

extension NavigationSettings where Self: UIViewController {
    func navigationSettings(title: String, selector: Selector) {
        
        var btnTitle: String = String()
        if let navVC = self.navigationController, let barItems = navVC.navigationBar.items, let item = barItems.first {
            item.title = title
            
            if let title = item.title, title != Home {
                self.navigationItem.title = title
            } else {
                self.navigationItem.title = ""
            }
            
            if self.navigationItem.title == Profile {
                navVC.navigationBar.topItem?.title = ""
                navVC.navigationBar.backItem?.title = ""
                self.navigationItem.title = Profile
                btnTitle = "Call"
            } else {
                btnTitle = "Save"
            }
            

        }
        
        self.tabBarController?.tabBar.isHidden = true
        let saveButton = UIBarButtonItem(title: btnTitle, style: .bordered, target: self, action: selector)
        self.navigationItem.rightBarButtonItem = saveButton
    }
}
