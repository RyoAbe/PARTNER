//
//  UpdatePartnerOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/07.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class UpdatePartnerOperation: BaseOperation {
    init(partnerId: String) {
        super.init()
        self.executeSerialBlock = {
            let pfParter = PFUser.currentPartner(partnerId)
            if pfParter == nil {
                return .Failure(NSError.code(.Unknown))
            }

            // ???: なくていいかも
//            let profileImageData = pfParter!.profileImage.getData()
            let pfStatuses = pfParter!.statuses

            self.dispatchAsyncMainThread{
                let partner = Partner.read()
                partner.name = pfParter!.username
//                partner.image = UIImage(data: profileImageData)

                if let pfStatuses = pfStatuses {
                    let pfStatus = pfStatuses.last!
                    let status = PartnersStatus(types: pfStatus.types, date: pfStatus.date)
                    partner.statusDate = status.date
                    partner.statusType = status.types.statusType
                    
                    for pfStatus in pfStatuses {
                        let status = PartnersStatus(types: pfStatus.types, date: pfStatus.date)
                        partner.appendStatuses(status)
                    }
                }
                partner.save()
            }
            return .Success(nil)

        }
    }
}
