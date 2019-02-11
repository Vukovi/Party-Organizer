//
//  PartyVC.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/9/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import UIKit

class PartyVC: UIViewController {
    
    var profileModels: [ProfileModel]?
    var partyModels: [PartyModel] = [PartyModel]() {
        didSet{
            partyModels.count > 0 ? yesParties() : noParties()
            partyTable.reloadData()
        }
    }
    var model: PartyModel?

    @IBOutlet weak var noPartyLabel: UILabel!
    @IBOutlet weak var createPartyButton: UIButton!
    @IBOutlet weak var partyTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Party.invitees.parties.count > 0 ? yesParties() : noParties()
        Api.manager.getProfiles { [weak self] (models) in
            DispatchQueue.main.async {
                self?.profileModels = models
                if let models = models {
                    Party.invitees.profiles = models
                }
            }
        }
        partyTable.delegate = self
        partyTable.dataSource = self
        partyTable.register(PartyInfoCell.self, forCellReuseIdentifier: PartyInfoCell.cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        if let navVC = self.navigationController, let barItems = navVC.navigationBar.items, let item = barItems.first {
            item.title = Parties
        }
        partyModels = Party.invitees.parties
    }

    @IBAction func addPressed(_ sender: Any) {
        performSegue(withIdentifier: Segue.PartyToPartyDetails, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.PartyToPartyDetails {
            if let partyDeatilVC: PartyDetailsVC = segue.destination as? PartyDetailsVC, let model = self.model {
                partyDeatilVC.partyModel = model
                partyDeatilVC.forwarded = true
            }
        }
    }
    
    func noParties() {
        partyTable.isHidden = true
        noPartyLabel.isHidden = false
        createPartyButton.isHidden = false
    }
    
    func yesParties() {
        partyTable.isHidden = false
        noPartyLabel.isHidden = true
        createPartyButton.isHidden = true
    }
    
}

extension PartyVC: PartyInfoDelegate {
    func editParty(model: PartyModel?) {
        var index: Int?
        for i in 0..<partyModels.count {
            if let model = model, (model.partyName == partyModels[i].partyName && model.partyDescription == partyModels[i].partyDescription && model.partyDate == partyModels[i].partyDate) {
                index = i
            }
        }
        self.model = model
        self.model?.index = index
        self.model?.profileModels = Party.invitees.parties[index!].profileModels
        performSegue(withIdentifier: Segue.PartyToPartyDetails, sender: self)
    }
}


extension PartyVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partyModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PartyInfoCell = tableView.dequeueReusableCell(withIdentifier: PartyInfoCell.cellIdentifier, for: indexPath) as! PartyInfoCell
        cell.partyModel = partyModels[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            Party.invitees.parties.remove(at: indexPath.row)
            partyModels = Party.invitees.parties
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = partyModels[indexPath.row]
        editParty(model: model)
    }

}
