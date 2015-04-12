//
//  UpdatePartnerOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/07.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class UpdatePartnerOperation: UpdateProfileOperation {
    init(partnerId: String) {
        super.init()
        assert(MyProfile.read().hasPartner)
        pfProfile = PFUser.currentPartner(partnerId)
        profile = Partner.read()
    }
}
