//
//  PartyDetailsVC.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/9/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import UIKit

class PartyDetailsVC: UIViewController {
    
    @IBOutlet weak var partyTable: UITableView!
    var partyModel = PartyModel()
    var height: CGFloat = CGFloat()
    var cellExpanded = false {
        didSet{
            partyTable.reloadData()
        }
    }
    var pressedSaved = false
    var forwarded = false
    var members: [ProfileModel] = [ProfileModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        partyTable.delegate = self
        partyTable.dataSource = self
        partyTable.register(PartyDetailsNameCell.self, forCellReuseIdentifier: PartyDetailsNameCell.cellIdentifier)
        partyTable.register(PartyDetailsDateCell.self, forCellReuseIdentifier: PartyDetailsDateCell.cellIdentifier)
        partyTable.register(PartyDetailsMembersCell.self, forCellReuseIdentifier: PartyDetailsMembersCell.cellIdentifier)
        partyTable.register(PartyDetailsDescriptionCell.self, forCellReuseIdentifier: PartyDetailsDescriptionCell.cellIdentifier)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationSettings(title: Home, selector: #selector(save))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.PartyDetailToMembers {
            if let membersVC: PartyMembersVC = segue.destination as? PartyMembersVC {
                membersVC.tabbedMembers = false
                membersVC.savedMembers = members
                membersVC.profileModels = Party.invitees.profiles
            }
        }
    }
    
}

// MARK: - Navigation Settings

extension PartyDetailsVC: NavigationSettings {
    @objc func save() {
        
        var index: Int?
        for model in Party.invitees.parties {
            if model.index == partyModel.index && !pressedSaved{
                index = model.index
                break
            }
        }
        
        pressedSaved = true
        forwarded = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationConstants.PartyDetails), object: nil, userInfo: nil)
        
        
        if index == nil {
            partyModel.index = Party.invitees.parties.count
            Party.invitees.parties.append(partyModel)
        } else {
            Party.invitees.parties.remove(at: index!)
            Party.invitees.parties.insert(partyModel, at: index!)
        }
    }
}

// MARK: - PartyNameDelegate

extension PartyDetailsVC: PartyNameDelegate {
    func party(name: String) {
        partyModel.partyName = name
    }
}

// MARK: - PartyDateDelegate

extension PartyDetailsVC: PartyDateDelegate {
    func party(date: String) {
        partyModel.partyDate = date
    }
}

// MARK: - PartyMembersDelegate

extension PartyDetailsVC: PartyMembersDelegate {
    
    func party(members: [ProfileModel]) {
        partyModel.profileModels = members
    }
    
    func cell(expand: Bool, height: CGFloat) {
        cellExpanded = expand
        self.height = height
    }
    
    func goTo(members: [ProfileModel]) {
        self.members = members
        performSegue(withIdentifier: Segue.PartyDetailToMembers, sender: self)
    }
    
}

// MARK: - PartyDescriptionDelegate

extension PartyDetailsVC: PartyDescriptionDelegate {
    func party(description: String) {
        partyModel.partyDescription = description
    }
}

// MARK: - Tabel Settings

extension PartyDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: PartyDetailsNameCell = tableView.dequeueReusableCell(withIdentifier: PartyDetailsNameCell.cellIdentifier, for: indexPath) as! PartyDetailsNameCell
            if let partyName = partyModel.partyName, forwarded {
                cell.enterParty.text = partyName
            }
            cell.delegate = self
            return cell
        case 1:
            let cell: PartyDetailsDateCell = tableView.dequeueReusableCell(withIdentifier: PartyDetailsDateCell.cellIdentifier, for: indexPath) as! PartyDetailsDateCell
            if let partyDate = partyModel.partyDate, forwarded {
                cell.enterDate.text = partyDate
            }
            cell.delegate = self
            return cell
        case 2:
            let cell: PartyDetailsMembersCell = tableView.dequeueReusableCell(withIdentifier: PartyDetailsMembersCell.cellIdentifier, for: indexPath) as! PartyDetailsMembersCell
            cell.delegate = self
            if let profileModels = partyModel.profileModels, forwarded {
                cell.members = profileModels
            }
            cell.colapsedCellHeight = self.partyTable.frame.height * 0.15
            return cell
        case 3:
            let cell: PartyDetailsDescriptionCell = tableView.dequeueReusableCell(withIdentifier: PartyDetailsDescriptionCell.cellIdentifier, for: indexPath) as! PartyDetailsDescriptionCell
            if let partyDescription = partyModel.partyDescription, forwarded {
                cell.textInfo.text = partyDescription
            }
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return self.partyTable.frame.height * 0.15
        case 1:
            return self.partyTable.frame.height * 0.15
        case 2:
            if !cellExpanded {
                return self.partyTable.frame.height * 0.15
            } else {
                return (self.partyTable.frame.height * 0.15 + height)
            }
        case 3:
            if !cellExpanded {
                return UIScreen.main.bounds.height * 0.5
            } else {
                return UIScreen.main.bounds.height * 0.5 - height
            }
            
        default:
            return 50
        }
    }
    
}
