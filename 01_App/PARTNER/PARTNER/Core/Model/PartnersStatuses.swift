//
//  PartnersStatuses.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/11.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import Foundation

class PartnersStatuses: Statuses {
    init(){
        let partner = PFUser.currentUser()["Partner"] as PFUser
        super.init(pfUser: partner)
    }
}