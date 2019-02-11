//
//  TabController.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/9/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import UIKit

class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        guard let membersVC: PartyMembersVC = (self.viewControllers?.last as? UINavigationController)?.topViewController as? PartyMembersVC else {
            return
        }
        
        guard let partyVC: PartyVC = (self.viewControllers?.first as? UINavigationController)?.topViewController as? PartyVC else {
            return
        }
        
        if self.selectedIndex == 0 {
            membersVC.profileModels = partyVC.profileModels
        }
        
    }
    

}
