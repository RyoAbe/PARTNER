//
//  UpdatePartnerOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/07.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class UpdatePartnerOperation: BaseOperation {
    init(partnerId: NSString) {
        super.init()
        self.executeSerialBlock = {
            let pfParter = PFUser.currentPartner(partnerId)

            // ???: なくていいかも
            let profileImageData = pfParter.profileImage.getData()
            let pfStatuses = pfParter.statuses

            self.dispatchAsyncMainThread({
                let partner = Partner.read()
                partner.name = pfParter.username
                partner.image = UIImage(data: profileImageData)

                if let pfStatuses = pfStatuses {
                    let pfStatus = pfStatuses[0]
                    let status = PartnersStatus(types: pfStatus.types, date: pfStatus.date)
                    partner.statusDate = status.date
                    partner.statusType = status.types.statusType
                    
                    for pfStatus in pfStatuses {
                        let status = PartnersStatus(types: pfStatus.types, date: pfStatus.date)
                        partner.statuses.append(status)
                    }
                }
                partner.save()
            })
            return .Success(nil)

        }
    }
}
