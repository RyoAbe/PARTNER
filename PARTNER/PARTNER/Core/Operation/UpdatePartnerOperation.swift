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
        pfProfile = PFUser.currentPartner(partnerId)
        profile = Partner.read()
    }
    override func status(types: StatusTypes, date: NSDate) -> Status {
        return PartnersStatus(types: types, date: date)
    }
}
