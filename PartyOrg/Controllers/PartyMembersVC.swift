//
//  PartyMembersVC.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/9/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import UIKit


class PartyMembersVC: UIViewController {
    
    var tabbedMembers = true
    var profileModels: [ProfileModel]?
    @IBOutlet weak var memberTable: UITableView!
    var passingMember: ProfileModel?
    var savedMembers: [ProfileModel] = [ProfileModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberTable.delegate = self
        memberTable.dataSource = self
        memberTable.register(MembersCell.self, forCellReuseIdentifier: MembersCell.cellIdentifier)
        memberTable.allowsMultipleSelection = true
        memberTable.allowsMultipleSelectionDuringEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !tabbedMembers {
            navigationSettings(title: Members, selector: #selector(save))
        } else {
            self.tabBarController?.tabBar.isHidden = false
            if let navVC = self.navigationController, let barItems = navVC.navigationBar.items, let item = barItems.first {
                item.title = Members
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.MembersToProfile || segue.identifier == Segue.PartyMembersToProfile {
            if let profileVC: ProfileVC = segue.destination as? ProfileVC {
                profileVC.member = passingMember
            }
        }
    }

}

extension PartyMembersVC: NavigationSettings {
    @objc func save() {
        let userInfo = [BackMemebers: savedMembers]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConstants.MembersPassedBackToPartyDetails), object: nil, userInfo: userInfo)
    }
}

extension PartyMembersVC: MembersCellDelegate {
    func forwardPressed() {
        tabbedMembers ? performSegue(withIdentifier: Segue.MembersToProfile, sender: self) : performSegue(withIdentifier: Segue.PartyMembersToProfile, sender: self)
    }
}

extension PartyMembersVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let models = profileModels {
            return models.count
        } else {return 1}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MembersCell = tableView.dequeueReusableCell(withIdentifier: MembersCell.cellIdentifier, for: indexPath) as! MembersCell
        cell.tabbedMembers = tabbedMembers
        if let models = profileModels {
            cell.member = models[indexPath.row]
            cell.configureCell()
            if !tabbedMembers {
                savedMembers.forEach {
                    if $0.username == models[indexPath.row].username {
                        cell.accessoryType = .checkmark
                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.bottom)
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let member = profileModels?[indexPath.row] {
            passingMember = member
        }
        
        if tabbedMembers {
            forwardPressed()
        } else {
            let cell: MembersCell = tableView.cellForRow(at: indexPath) as! MembersCell
            cell.accessoryType = .checkmark
            savedMembers.append(profileModels![indexPath.row])
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if !tabbedMembers {
            let cell: MembersCell = tableView.cellForRow(at: indexPath) as! MembersCell
            cell.accessoryType = .none
//            savedMembers.remove(at: indexPath.row)
            
            savedMembers = savedMembers.filter {
                if $0.username == cell.member?.username {
                    return false
                } else {
                    return true
                }
            }
            
    
        }
    }

    
}

