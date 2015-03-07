//
//  SendMyStatusOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/04.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

class SendMyStatusOperation: BaseOperation {

    let statusType: StatusType!

    init(statusType : StatusType){
        super.init()
        self.statusType = statusType
    }

    override func main() {
        super.main()
        assert(MyProfile.read().isAuthenticated && MyProfile.read().hasPartner, "ログイン出来てないし、パートナーもいない")

        let myProfile = MyProfile.read()
        let statusDate = NSDate()
        PFUser.query().getObjectInBackgroundWithId(myProfile.id, block: { object, error in
            object["statusType"] = self.statusType.type.rawValue
            object["statusDate"] = statusDate
            object.saveInBackgroundWithBlock{ succeeded, error in
                myProfile.statusType = self.statusType
                myProfile.statusDate = statusDate
                myProfile.save()
                self.notify()
            }
        })
    }

    func notify() {
        let myProfile = MyProfile.read()

        let userQuery = PFUser.query().whereKey("objectId", equalTo: Partner.read().id)
        let pushQuery = PFInstallation.query().whereKey("user", matchesQuery:userQuery)

        let push = PFPush()
        push.setQuery(pushQuery)
        push.setData(["alert"           : "\(myProfile.name):「\(myProfile.statusType!.name)」",
                      "notificationType": "Status",
                      "type"            : myProfile.statusType!.type.rawValue,
                      "date"            : "\(myProfile.statusDate!.timeIntervalSince1970)"])

        // TODO: errorのハンドリング
        push.sendPushInBackgroundWithBlock(nil)
        self.finished = true
    }
}
