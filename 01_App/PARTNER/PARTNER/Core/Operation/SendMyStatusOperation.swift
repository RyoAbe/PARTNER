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
        self.partnerId = partnerId
        self.statusTypes = statusTypes
        super.init()
        self.executeSerialBlock = {

            var error: NSError?
            // ???: myProfileはcurrentUserから持ってくればいいのでは
            let pfMyProfile = PFUser.currentMyProfile()
            assert(pfMyProfile.isAuthenticated && pfMyProfile.hasPartner, "ログイン出来てないし、パートナーもいない")

            // ???: サーバーに自分の情報がなくてもsaveされてしまう
            let status = MyStatus(types: statusTypes, date: NSDate())

            let pfStatus = PFStatus()
            pfStatus.types = status.types
            pfStatus.date = status.date
            pfStatus.save(&error)
            if error != nil {
                return .Failure(error)
            }

            pfMyProfile.statuses = [pfStatus]
            pfMyProfile.save(&error)
            if error != nil {
                return .Failure(error)
            }
            
            self.dispatchAsyncMainThread({
                let myProfile = MyProfile.read()
                myProfile.statusType = status.types.statusType
                myProfile.statusDate = status.date
                myProfile.appendStatuses(status)
                myProfile.save()
            })

            // ???: パートナーを変えても遅れてしまう。
            let data = ["alert"           : "\(pfMyProfile.username):「\(status.types.statusType.name)」",
                        "notificationType": "Status",
                        "type"            : status.types.rawValue,
                        "date"            : "\(status.date.timeIntervalSince1970)"]
            return self.notify(data as [NSObject : AnyObject])

        }
    }

    func notify(data: [NSObject : AnyObject]!) -> BaseOperationResult {
        let userQuery = PFUser.query()!.whereKey("objectId", equalTo: partnerId)
        let pushQuery = PFInstallation.query()!.whereKey("user", matchesQuery:userQuery)
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
