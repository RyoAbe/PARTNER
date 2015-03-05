//
//  UpdatePartnerOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2014/09/07.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

import UIKit

class UpdatePartnerOperation: BaseOperation {

    override func main() {
        super.main()

        let partner = Partner.read()
        PFUser.query().getObjectInBackgroundWithId(partner.id, block: { object, error in

            // TODO: あったほうがいいかなー？
//            partner.name = object["name"] as NSString
//            partner.image = UIImage(data: (object["profileImage"] as PFFile).getData())
            if let type = object["statusType"] as? NSInteger {
                partner.statusType = StatusTypes(rawValue: type)?.status() as StatusType!
            }
            if let date = object["statusDate"] as? NSDate {
                partner.statusDate = date
            }
            partner.save()
            self.finished = true
        })
    }
}
