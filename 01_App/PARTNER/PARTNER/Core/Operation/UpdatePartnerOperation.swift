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
            if let pfParter = PFUser.query().getObjectWithId(partner.id, error: &error) {
                let profileImageData = (pfParter["profileImage"] as PFFile).getData()
                self.dispatchAsyncMainThread({
                    // ???: なくていいかも
                    partner.name = pfParter["username"] as NSString
                    partner.image = UIImage(data: profileImageData)
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
            return .Failure(error == nil ? NSError.code(.NotFoundUser) : error)
        }
    }
}
