//
//  UpdatePartnerOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/07.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class UpdatePartnerOperation: BaseOperation {
    override init() {
        super.init()
        self.executeSerialBlock = {
            assert(MyProfile.read().hasPartner, "パートナーがいません")
            let partner = Partner.read()
            var error: NSError?
            let pfParter = PFUser.query().getObjectWithId(partner.id, error: &error)
            if let err = error {
                return .Failure(NSError.code(.NetworkOffline))
            }

            if pfParter == nil {
                return .Failure(NSError.code(.NotFoundUser))
            }

            self.dispatchAsyncMainThread({
                // ???: なくていいかも
                partner.name = pfParter["username"] as NSString
                partner.image = UIImage(data: (pfParter["profileImage"] as PFFile).getData())
                if let type = pfParter["statusType"] as? NSInteger {
                    partner.statusType = StatusTypes(rawValue: type)!.statusType
                }
                if let date = pfParter["statusDate"] as? NSDate {
                    partner.statusDate = date
                }
                partner.save()
            })
            return .Success(nil)
        }
    }
}
