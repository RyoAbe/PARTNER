//
//  StatusView.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/02.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class StatusView: UIView {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var atLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var profile: Profile!{
        didSet{
            self.nameLabel.text = profile.name;
            self.profileImageView.image = UIImage(named: profile.imageName)
        }
    }
}
