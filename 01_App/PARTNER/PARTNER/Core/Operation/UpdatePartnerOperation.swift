//
//  UpdatePartnerOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/07.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class UpdatePartnerOperation: BaseOperation {
    convenience init(partnerId: NSString) {
        self.init()
        self.executeSerialBlock = {
            var error: NSError?
            if let pfParter = PFUser.query().getObjectWithId(partnerId, error: &error) {
                let profileImageData = (pfParter["profileImage"] as PFFile).getData()
                self.dispatchAsyncMainThread({
                    // ???: なくていいかも
                    let partner = Partner.read()
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
