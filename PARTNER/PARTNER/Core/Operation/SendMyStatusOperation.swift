//
//  SendMyStatusOperation.swift
//  PARTNER
//
//  Created by RyoAbe on 2015/03/04.
//  Copyright (c) 2015年 RyoAbe. All rights reserved.
//

import UIKit

// ???: Parseから返ってくるエラーをちゃんと拾いたい
class SendMyStatusOperation: BaseOperation {

    let partnerId: NSString!
    let statusTypes: StatusTypes!

    init(statusTypes: StatusTypes){
        self.partnerId = Partner.read().id
        self.statusTypes = statusTypes
        super.init()
        self.executeSerialBlock = { self.execute() }
    }

    func execute() -> BaseOperationResult {
        var error: NSError?
        let pfMyProfile = PFUser.currentMyProfile()
        assert(pfMyProfile.isAuthenticated && pfMyProfile.hasPartner, "ログイン出来てないし、パートナーもいない")
        
        // ???: サーバーに自分の情報がなくてもsaveされてしまう問題
        let status = MyStatus(types: statusTypes, date: NSDate())
        
        let pfStatus = PFStatus()
        pfStatus.types = status.types
        pfStatus.date = status.date
        pfStatus.save(&error)
        if error != nil {
            return .Failure(error)
        }
        
        pfMyProfile.appendStatus(pfStatus)
        pfMyProfile.save(&error)
        if error != nil {
            return .Failure(error)
        }
        
        dispatchAsyncMainThread{
            let myProfile = MyProfile.read()
            myProfile.appendStatuses(status)
            myProfile.save()
        }

        return notify(["alert"    : "\(pfMyProfile.username): \(status.types.statusType.name)",
                       "type"     : status.types.rawValue,
                       "category" : APSCategory.ReceivedMessage.rawValue,
                       "date"     : "\(status.date.timeIntervalSince1970)"])
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
