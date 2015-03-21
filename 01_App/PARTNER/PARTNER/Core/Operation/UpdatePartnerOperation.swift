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
                    let types = pfParter["statusType"] as? NSInteger
                    let date = pfParter["statusDate"] as? NSDate
                    if types != nil && date != nil {
                        let t = StatusTypes(rawValue: types!)
                        let status = PartnersStatus(types: t!, date: date!)
                        partner.statuses.append(status)
                    }
                    partner.save()
                })
                return .Success(nil)
            }
            return .Failure(error == nil ? NSError.code(.NotFoundUser) : error)
        }
    }
}
