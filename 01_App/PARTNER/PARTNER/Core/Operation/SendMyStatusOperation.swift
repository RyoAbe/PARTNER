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

    let partnerId: NSString!
    let statusTypes: StatusTypes!

    init(partnerId: NSString, statusTypes: StatusTypes){
        super.init()
        self.partnerId = partnerId
        self.statusTypes = statusTypes
        self.executeSerialBlock = {

            var error: NSError?
            // ???: myProfileはcurrentUserから持ってくればいいのでは
            if let pfMyProfile = PFUser.currentUser() {
                assert(pfMyProfile.isAuthenticated() && pfMyProfile["hasPartner"] as Bool, "ログイン出来てないし、パートナーもいない")

                let status = Status(types: statusTypes, date: NSDate())

                let pfStatus = PFObject(className: "Status")
                pfStatus.setObject(NSNumber(integer: status.types.rawValue), forKey: "type")
                pfStatus.setObject(status.date, forKey: "date")
                pfStatus.save(&error)
                if error != nil {
                    return .Failure(error)
                }

                pfMyProfile.addObjectsFromArray([pfStatus], forKey: "statuses")
                pfMyProfile["statusType"] = status.types.rawValue
                pfMyProfile["statusDate"] = status.date
                pfMyProfile.save(&error)
                if error != nil {
                    return .Failure(error)
                }

                self.dispatchAsyncMainThread({
                    let myProfile = MyProfile.read()
                    myProfile.statusType = status.types.statusType
                    myProfile.statusDate = status.date
//                    myProfile.statuses?.addObject(status)
                    myProfile.save()
                })
                let data = ["alert"           : "\(pfMyProfile.username):「\(status.types.statusType.name)」",
                            "notificationType": "Status",
                            "type"            : status.types.rawValue,
                            "date"            : "\(status.date.timeIntervalSince1970)"]
                return self.notify(data)
            }
            return .Failure(error == nil ? NSError.code(.NotFoundUser) : error)
        }
    }

    func notify(data: [NSObject : AnyObject]!) -> BaseOperationResult {

        let userQuery = PFUser.query().whereKey("objectId", equalTo: partnerId)
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
