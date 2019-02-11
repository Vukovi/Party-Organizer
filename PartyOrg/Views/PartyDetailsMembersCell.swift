//
//  PartyDetailsMembersCell.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/10/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import UIKit

protocol PartyMembersDelegate: class {
    func party(members: [ProfileModel])
    func cell(expand: Bool, height: CGFloat)
    func goTo(members: [ProfileModel])
}

class PartyDetailsMembersCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: PartyMembersDelegate?
    
    var expanded: Bool = false
    var tableConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var infoConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var buttonConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
    var height: CGFloat = CGFloat()
    var colapsedCellHeight = CGFloat()
    
    var members: [ProfileModel] = [ProfileModel]() {
        didSet {
            info.setTitle("Members (\(members.count))", for: .normal)
            tableMembers.reloadData()
        }
    }
    
    lazy var info: UIButton = {
        let lbl = UIButton()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.setTitle("Members (\(members.count))", for: .normal)
        lbl.setTitleColor(.black, for: .normal)
        lbl.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        lbl.titleLabel?.textAlignment = .left
        lbl.contentHorizontalAlignment = .left
        lbl.titleLabel?.frame = lbl.frame
        lbl.addTarget(self, action: #selector(expandingCell), for: .touchUpInside)
        return lbl
    }()
    
    lazy var tableMembers: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.isHidden = true
        tv.backgroundColor = .darkGray
        tv.register(SmallCell.self, forCellReuseIdentifier: SmallCell.cellIdentifier)
        return tv
    }()
    
    lazy var buttonForward: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(forward, for: .normal)
        btn.addTarget(self, action: #selector(forwardPressed), for: .touchUpInside)
        return btn
    }()
    
    @objc func forwardPressed() {
        delegate?.goTo(members: members)
    }
    
    @objc func expandingCell() {
        expanded = !expanded
        if expanded {
            expandedTable()
        } else {
            colapsedTable()
        }
        delegate?.cell(expand: expanded, height: height)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc func saved(){
        delegate?.party(members: members)
        members.removeAll()
        expandedTable()
        tableMembers.reloadData()
        delegate?.cell(expand: true, height: height)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func partyMemebers(notification: Notification) {
        members = notification.userInfo?[BackMemebers] as! [ProfileModel]
        delegate?.party(members: members)
        expandedTable()
        tableMembers.reloadData()
        delegate?.cell(expand: true, height: height)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.selectionStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(saved), name: NSNotification.Name(rawValue: NotificationConstants.PartyDetails), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(partyMemebers), name: NSNotification.Name(rawValue: NotificationConstants.MembersPassedBackToPartyDetails), object: nil)
        
        
        self.addSubview(info)
        self.addSubview(tableMembers)
        self.addSubview(buttonForward)
        
        colapsedTable()
    }
    
    func colapsedTable() {
        
        info.removeConstraints(infoConstraints)
        infoConstraints.removeAll()
        info.removeFromSuperview()
        self.addSubview(info)
        infoConstraints.append(info.topAnchor.constraint(equalTo: self.topAnchor))
        infoConstraints.append(info.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        infoConstraints.append(info.heightAnchor.constraint(equalToConstant: colapsedCellHeight))
        infoConstraints.append(info.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20))
        infoConstraints.append(info.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40))
        infoConstraints.forEach { $0.isActive = true }
        
        tableMembers.removeConstraints(tableConstraints)
        tableConstraints.removeAll()
        tableConstraints.append(tableMembers.topAnchor.constraint(equalTo: info.bottomAnchor))
        tableConstraints.append(tableMembers.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        tableConstraints.append(tableMembers.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        tableConstraints.append(tableMembers.heightAnchor.constraint(equalToConstant: 0))
        tableConstraints.forEach { $0.isActive = true }
        tableMembers.isHidden = true
        
        buttonForward.removeConstraints(buttonConstraints)
        buttonConstraints.removeAll()
        buttonForward.removeFromSuperview()
        self.addSubview(buttonForward)
        buttonConstraints.append(buttonForward.heightAnchor.constraint(equalToConstant: 30))
        buttonConstraints.append(buttonForward.centerYAnchor.constraint(equalTo: info.centerYAnchor))
        buttonConstraints.append(buttonForward.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10))
        buttonConstraints.append(buttonForward.widthAnchor.constraint(equalToConstant: 30))
        buttonConstraints.forEach { $0.isActive = true }
    }
    
    func expandedTable() {
        info.removeConstraints(infoConstraints)
        infoConstraints.removeAll()
        info.removeFromSuperview()
        self.addSubview(info)
        infoConstraints.append(info.topAnchor.constraint(equalTo: self.topAnchor))
        infoConstraints.append(info.heightAnchor.constraint(equalToConstant: colapsedCellHeight))
        infoConstraints.append(info.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20))
        infoConstraints.append(info.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40))
        infoConstraints.forEach { $0.isActive = true }
        
        tableMembers.removeConstraints(tableConstraints)
        tableConstraints.removeAll()
        height = CGFloat(members.count * 40)
        tableConstraints.append(tableMembers.topAnchor.constraint(equalTo: info.bottomAnchor))
        tableConstraints.append(tableMembers.leadingAnchor.constraint(equalTo: self.leadingAnchor))
        tableConstraints.append(tableMembers.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        tableConstraints.append(tableMembers.heightAnchor.constraint(equalToConstant: height))
        tableConstraints.forEach { $0.isActive = true }
        tableMembers.isHidden = false
        
        buttonForward.removeConstraints(buttonConstraints)
        buttonConstraints.removeAll()
        buttonForward.removeFromSuperview()
        self.addSubview(buttonForward)
        buttonConstraints.append(buttonForward.heightAnchor.constraint(equalToConstant: 30))
        buttonConstraints.append(buttonForward.centerYAnchor.constraint(equalTo: info.centerYAnchor))
        buttonConstraints.append(buttonForward.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10))
        buttonConstraints.append(buttonForward.widthAnchor.constraint(equalToConstant: 30))
        buttonConstraints.forEach { $0.isActive = true }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: SmallCell.cellIdentifier, for: indexPath)
        cell.textLabel?.text = members[indexPath.row].username
        cell.backgroundColor = .lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            members.remove(at: indexPath.row)
            expandedTable()
            delegate?.cell(expand: expanded, height: height)
        }
    }

}
