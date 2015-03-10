//
//  SendMyStatusOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/04.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

// ???: Parseから返ってくるエラーをちゃんと拾いたいかも
class SendMyStatusOperation: BaseOperation {

    let statusType: StatusType!

    init(statusType : StatusType){
        super.init()
        self.statusType = statusType
        self.executeSerialBlock = {
            assert(MyProfile.read().isAuthenticated && MyProfile.read().hasPartner, "ログイン出来てないし、パートナーもいない")
            let myProfile = MyProfile.read()
            let statusDate = NSDate()

            var error: NSError?
            if let pfMyProfile = PFUser.query().getObjectWithId(myProfile.id, error: &error) {
                pfMyProfile["statusType"] = statusType.type.rawValue
                pfMyProfile["statusDate"] = statusDate
                pfMyProfile.save(&error)
                if error != nil {
                    return .Failure(error)
                }

                self.dispatchAsyncMainThread({
                    myProfile.statusType = statusType
                    myProfile.statusDate = statusDate
                    myProfile.save()
                })
                let data = ["alert"           : "\(myProfile.name):「\(statusType.name)」",
                    "notificationType": "Status",
                    "type"            : statusType.type.rawValue,
                    "date"            : "\(statusDate.timeIntervalSince1970)"]
                return self.notify(data)
            }
            return .Failure(error == nil ? NSError.code(.NotFoundUser) : error)
        }
    }

    func notify(data: [NSObject : AnyObject]!) -> BaseOperationResult {
        let myProfile = MyProfile.read()

        let userQuery = PFUser.query().whereKey("objectId", equalTo: Partner.read().id)
        let pushQuery = PFInstallation.query().whereKey("user", matchesQuery:userQuery)
        let push = PFPush()
        push.setQuery(pushQuery)
        push.setData(data)

        var error: NSError?
        push.sendPush(&error)
        if error != nil {
            return .Failure(error)
        }
        return .Success(nil)
    }
}
