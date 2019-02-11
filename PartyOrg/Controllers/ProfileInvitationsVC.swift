//
//  ProfileInvitationsVC.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/9/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import UIKit

class ProfileInvitationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var member: ProfileModel?
    @IBOutlet weak var partyTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        partyTable.delegate = self
        partyTable.dataSource = self
        partyTable.register(SmallCell.self, forCellReuseIdentifier: SmallCell.cellIdentifier)
        partyTable.allowsMultipleSelection = true
        partyTable.allowsMultipleSelectionDuringEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = member?.username
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Party.invitees.parties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SmallCell = tableView.dequeueReusableCell(withIdentifier: SmallCell.cellIdentifier, for: indexPath) as! SmallCell
        cell.textLabel?.text = Party.invitees.parties[indexPath.row].partyName
            Party.invitees.parties.forEach {
                $0.profileModels?.forEach({
                    if $0.username == member?.username {
                        cell.accessoryType = .checkmark
                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.bottom)
                    }
                })
            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: SmallCell = tableView.cellForRow(at: indexPath) as! SmallCell
        cell.accessoryType = .checkmark
        Party.invitees.parties[indexPath.row].profileModels?.append(member!)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell: SmallCell = tableView.cellForRow(at: indexPath) as! SmallCell
        cell.accessoryType = .none
        
        Party.invitees.parties[indexPath.row].profileModels = Party.invitees.parties[indexPath.row].profileModels!.filter {
            if $0.username == member?.username {
                return false
            } else {
                return true
            }
        }
        
    }

}
