//
//  ProfileVC.swift
//  PartyOrg
//
//  Created by Vuk Knežević on 2/9/19.
//  Copyright © 2019 Vuk Knežević. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileImg: RoundedImageView!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var aboutTV: UITextView!
    @IBOutlet weak var partyBtn: UIButton!
    
    var member: ProfileModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imgStr = member?.photo, let imgPlaceholder = member?.username, let gender = member?.gender, let email = member?.email, let about = member?.aboutMe {
            profileImg.sd_setImage(with: URL(string: imgStr), placeholderImage: UIImage(named: imgPlaceholder))
            fullNameLbl.text = "Full name: \(imgPlaceholder)"
            genderLbl.text = "Gender: \(gender)"
            emailLbl.text = "email: \(email)"
            aboutTV.text = about
        }
        profileImg.contentMode = .scaleAspectFit

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationSettings(title: Profile, selector: #selector(call))
        profileImg.makeRounded()
    }
    
    
    @IBAction func partyBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: Segue.InviteToParty, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.InviteToParty {
            if let invitationsVC: ProfileInvitationsVC = segue.destination as? ProfileInvitationsVC {
                invitationsVC.member = member
            }
        }
    }
}

extension ProfileVC: NavigationSettings {
    @objc func call() {
        print("CALL")
    }
}
