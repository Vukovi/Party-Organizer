//
//  Models.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/9/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import Foundation

struct ProfileModel: Decodable {
    let gender: String?
    let id: Int?
    let aboutMe: String?
    let cell: String?
    let username: String?
    let email: String?
    let photo: String?
}

struct Profiles: Decodable {
    let profiles: [ProfileModel]?
}

struct PartyModel {
    var partyName: String?
    var partyDate: String?
    var profileModels: [ProfileModel]?
    var partyDescription: String?
    var index: Int?
}

